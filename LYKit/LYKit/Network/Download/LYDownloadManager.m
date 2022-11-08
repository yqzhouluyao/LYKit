//
//  LYDownloadManager.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYDownloadManager.h"

@interface LYDownloadManager ()

@property (nonatomic, strong) NSMutableDictionary *downLoadTaskDict;

@end

@implementation LYDownloadManager

static LYDownloadManager *_shareInstance;
+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static LYDownloadManager *instance;
    dispatch_once(&once, ^{
        instance = [[LYDownloadManager alloc] init];
    });
    return instance;
}

- (LYDownloadTask *)downloadTaskWithURL:(NSURL *)url {
    return self.downLoadTaskDict[url.lastPathComponent];
}

- (void)pauseDownLoadWithURL:(NSURL *)url {
    LYDownloadTask *downloadTask = [self downloadTaskWithURL:url];
    [downloadTask pause];
}

- (void)resumeDownLoadWithURL:(NSURL *)url {
    LYDownloadTask *downloadTask = [self downloadTaskWithURL:url];
    [downloadTask resume];
}

- (void)cancelDownLoadWithURL:(NSURL *)url {
    LYDownloadTask *downloadTask = self.downLoadTaskDict[url.lastPathComponent];
    if (downloadTask) {
        [downloadTask cancel];
    }else {
        [LYDownloadTask removeCacheFileWithURL:url];
    }
}

- (void)downLoadWithURL:(NSURL *)url progressBlock:(void(^)(float progress))progressBlock successBlock:(void(^)(NSString *fileFullPath))successBlock failBlock:(void(^)())failBlock {
    LYDownloadTask *downloadTask = [self downloadTaskWithURL:url];
    __weak LYDownloadManager *weakManager = self;
    if (!downloadTask) {
        downloadTask = [[LYDownloadTask alloc] init];
        [self.downLoadTaskDict setValue:downloadTask forKey:url.lastPathComponent];
        [downloadTask downLoadWithURL:url withProgressBlock:^(float progress) {
            progressBlock(progress);
        } success:^(NSString *downLoadPath) {
            successBlock(downLoadPath);
            // 移除对象
            [weakManager.downLoadTaskDict removeObjectForKey:downLoadPath.lastPathComponent];
        } failed:^{
            failBlock();
        }];

    }else {
        [downloadTask resume];
    }
}

#pragma mark -getter
- (NSMutableDictionary *)downLoadTaskDict {
    if (!_downLoadTaskDict) {
        _downLoadTaskDict = [NSMutableDictionary dictionary];
    }
    return _downLoadTaskDict;
}
@end
