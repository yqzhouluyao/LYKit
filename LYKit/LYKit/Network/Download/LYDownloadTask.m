//
//  LYDownloadTask.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYDownloadTask.h"
#import "LYFileManagerTool.h"

#define kLocalPath NSTemporaryDirectory()
#define kHeaderFilePath @"header.plist"

@interface LYDownloadTask ()<NSURLSessionDelegate>
/**
 文件名称
 */
@property (nonatomic, copy) NSString *fileFullPath;

/**
 存储文件总大小
 */
@property (nonatomic, assign) long long int fileTotalSize;


/**
 当前文件已下载大小
 */
@property (nonatomic, assign) long long int fileCurrentSize;


/**
 下载任务
 */
@property (nonatomic ,strong) NSURLSessionDataTask *downLoadTask;


/**
 文件输出流
 */
@property (nonatomic, strong) NSOutputStream *stream;



/**
 进度代码块
 */
@property (nonatomic, copy) void(^progressBlock)(float progress);

/**
 下载成功代码块
 */
@property (nonatomic, copy) void(^sucessBlock)(NSString *downLoadPath);

/**
 下载失败代码块
 */
@property (nonatomic, copy) void(^failBlock)();
@end

@implementation LYDownloadTask

- (void)downLoadWithURL: (NSURL *)url withProgressBlock: (void(^)(float progress))progress success:(void(^)(NSString *downLoadPath))sucess failed:(void(^)())fail {

    _downLoadURL = url;

    self.progressBlock = progress;
    self.sucessBlock = sucess;
    self.failBlock = fail;



    if (self.isDownloading) {
        NSLog(@"正在下载");
        return;
    }


    // 1. 获取需要下载的文件头信息
    BOOL result = [self getRemoteFileHeaderInfo];
    if (!result) {
        NSLog(@"下载出错, 请重新尝试");
        self.failBlock();
        _isDownloading = NO;
        return;
    }

    // 2. 根据需要下载的文件头信息, 验证本地信息
    // 2.1 如果本地文件存在
    //        进行以下验证:
    //          文件大小 == 服务器文件大小; 文件已经存在 不需要做处理
    //          文件大小 > 服务器文件大小; 删除本地文件, 重新下载
    //          文件大小 < 服务器文件大小; 根据本地缓存, 继续断点下载
    // 2.2 如果文件不存在, 则直接下载

    BOOL isRequireDownLoad = [self isNeedDownload];
    if (isRequireDownLoad) {
        NSLog(@"根据文件缓存大小, 执行下载操作");
        [self startDownLoad];
    }else {
        NSLog(@"文件已经存在--%@", self.fileFullPath);
        self.sucessBlock(self.fileFullPath);

    }
}

#pragma mark - 任务操作
- (void)startDownLoad {

    _isDownloading = YES;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downLoadURL];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", self.fileCurrentSize] forHTTPHeaderField:@"Range"];


    self.downLoadTask = [session dataTaskWithRequest:request];

    [self.downLoadTask resume];


    NSLog(@"down---%zd", self.downLoadTask.state);

}

- (void)pause {
    NSLog(@"暂停");
    _isDownloading = NO;
    [self.downLoadTask suspend];
    NSLog(@"---%zd", self.downLoadTask.state);
}

- (void)resume {
    NSLog(@"继续");
    _isDownloading = YES;
    if (self.downLoadTask) {
        [self.downLoadTask resume];
    }else {
        [self downLoadWithURL:self.downLoadURL withProgressBlock:self.progressBlock success:self.sucessBlock failed:self.failBlock];
    }

    NSLog(@"---%zd", self.downLoadTask.state);
}

- (void)cancel {
    NSLog(@"取消");
    _isDownloading = NO;
    [self.downLoadTask cancel];
    NSLog(@"---%zd", self.downLoadTask.state);
    self.downLoadTask = nil;

    // 清空缓存
    [LYFileManagerTool removeFileAtPath:self.fileFullPath];
}

#pragma mark - 获取文件头信息、检查本地文件
- (BOOL)getRemoteFileHeaderInfo {


    // 对信息进行本地缓存, 方便下次使用
    NSString *headerMsgPath = [kLocalPath stringByAppendingPathComponent:kHeaderFilePath];


    NSString *fileName = self.downLoadURL.lastPathComponent;

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:headerMsgPath];
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
    }
    if ([dic.allKeys containsObject:fileName]) {
        self.fileTotalSize = [dic[fileName] longLongValue];
        self.fileFullPath = [kLocalPath stringByAppendingPathComponent:fileName];
        return YES;
    }


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downLoadURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    request.HTTPMethod = @"HEAD";

    NSURLResponse *response = nil;
    NSError *error = nil;

    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //把请求头信息写入plist文件(文件名：文件总大小)
    if (error == nil) {
        self.fileTotalSize = response.expectedContentLength;
        self.fileFullPath = [kLocalPath stringByAppendingPathComponent:response.suggestedFilename];
        [dic setValue:@(response.expectedContentLength) forKey:fileName];
        [dic writeToFile:headerMsgPath atomically:YES];
        return YES;
    }
    return NO;

}

/**
 检测文件是否需要下载
 */
- (BOOL)isNeedDownload {

    self.fileCurrentSize = [LYFileManagerTool getFileSizeWithPath:self.fileFullPath];

    if (self.fileCurrentSize > self.fileTotalSize) {
        // 删除文件, 并重新下载
        [LYFileManagerTool removeFileAtPath:self.fileFullPath];
        return YES;
    }

    if (self.fileCurrentSize < self.fileTotalSize) {
        return YES;
    }

    return NO;
}

#pragma mark NSURLSessionDataDelegate
/*1.当接收到服务器响应的时候调用*/
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{

    //创建输出流
    NSOutputStream *stream = [[NSOutputStream alloc]initToFileAtPath:self.fileFullPath append:YES];
    self.stream = stream;
    [self.stream open];

    NSLog(@"didReceiveResponse");
    //通过该block告诉系统要如何处理服务器返回给我们的数据
    /*
     NSURLSessionResponseCancel = 0, //取消,不接受数据
     NSURLSessionResponseAllow = 1, //接收
     NSURLSessionResponseBecomeDownload = 2,  //变成下载请求
     NSURLSessionResponseBecomeStream //变成stream
     */
    completionHandler(NSURLSessionResponseAllow);

}

/*2.当接收到服务器返回的数据的时候调用,可能被调用多次*/
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];

    //    NSLog(@"didReceiveData");
    //计算文件下载进度
    self.fileCurrentSize += data.length;
    _progress = 1.0 * self.fileCurrentSize / self.fileTotalSize;

    self.progressBlock(self.progress);

}

/*3.当请求结束的时候调用,如果请求失败,那么error有值*/
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError--%@", error.localizedDescription);


    [self.stream close];
    self.stream = nil;
    _isDownloading = NO;
    
    if (error == nil) {
        self.sucessBlock(self.fileFullPath);
    }else {
        self.failBlock();
    }

}

@end
