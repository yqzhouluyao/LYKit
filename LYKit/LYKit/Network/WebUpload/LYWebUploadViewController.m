//
//  LYWebUploadViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/9.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYWebUploadViewController.h"
#import <GCDWebServer/GCDWebUploader.h>

@interface LYWebUploadViewController ()<GCDWebUploaderDelegate>
@property (nonatomic, strong) GCDWebUploader *webUploader;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@end

@implementation LYWebUploadViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加配乐
    self.title = @"添加配乐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从电脑下载" style:0 target:self action:@selector(rigthClick)];
}

//从电脑下载点击调用
- (void)rigthClick {
    
    //设置服务器路径
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
   documentsPath = [documentsPath stringByAppendingPathComponent:@"addMusic"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //开始服务器
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
//    _webServer.delegate = self;
//    _webServer.allowHiddenItems = YES;
    if ([_webUploader start]) {
        NSLog(@"服务器启动");
    } else {
        NSLog(@"启动失败");
    }

//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//      _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
//      [_webUploader start];
      NSLog(@"Visit %@ in your web browser", _webUploader.serverURL);
    
    //获取IP
    NSString *ip = [_webUploader.serverURL absoluteString];
    NSLog(@"%@",ip);
    NSInteger index = ip.length - 1;
    ip = [ip substringToIndex:index];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"在电脑浏览器输入以下网址" message:[NSString stringWithFormat:@"%@\n保持手机与电脑连接同一WIFI,上传过程中请勿关闭此弹框",ip] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_webUploader stop];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.uploadFiles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"fileMusicCell";
//    XMGFileMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [XMGFileMusicCell fileMusicCell];
//    }
//
//    NSString *filePath = self.fileNameAray[indexPath.row];
//    cell.filePath = filePath;
//    cell.indexPath = indexPath;
//
//    //点击播放按钮
//    __weak typeof(self)weakSelf = self;
//    cell.playBtnTask = ^(NSIndexPath *indexPath) {
//
//        //如果点的是同一个Cell的播放按钮, 真接让按钮状态取反
//        if (indexPath == weakSelf.preIndexPath) {
//            XMGFileMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.playBtn.selected = !cell.playBtn.selected;
//            weakSelf.preIndexPath = indexPath;
//            return ;
//        }
//
//        //不是同一个Cellr 的按钮
//        if (weakSelf.preIndexPath) {
//            //获取上一个按钮所在的Cell
//            XMGFileMusicCell *preCell = [tableView cellForRowAtIndexPath:weakSelf.preIndexPath];
//            //把该Cell的状态取消选中
//            preCell.playBtn.selected = NO;
//        }
//
//        //获取当前点击的Cell
//        XMGFileMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        //把当前Cell的按钮成为选中状态
//        cell.playBtn.selected = YES;
//
//        //记录当前点击的Cell位置
//        weakSelf.preIndexPath = indexPath;
//
//    };
    
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"已下载音乐";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = self.uploadFiles[indexPath.row];
    if (self.didChooseMusic) {
        self.didChooseMusic(fileName);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    [self.tableView reloadData];
}

#pragma mark -getter
- (NSMutableArray *)uploadFiles {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *fromPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fromPath = [fromPath stringByAppendingPathComponent:@"addMusic"];
    NSArray *subpaths =  [[NSFileManager defaultManager] subpathsAtPath:fromPath];
    
    for (NSString *file in subpaths) {
        NSString *lastName = [file lastPathComponent];
        if ([lastName containsString:@".mp3"]) {
            [tempArray addObject:[fromPath stringByAppendingPathComponent:file]];
        }
    }
    _uploadFiles = tempArray;
    
    return _uploadFiles;
}

@end
