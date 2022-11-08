//
//  LYDownloadManager.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYDownloadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYDownloadManager : NSObject

+ (instancetype)shareInstance;

- (LYDownloadTask *)downloadTaskWithURL:(NSURL *)url;

- (void)pauseDownLoadWithURL:(NSURL *)url;

- (void)resumeDownLoadWithURL:(NSURL *)url;

- (void)cancelDownLoadWithURL:(NSURL *)url;

- (void)downLoadWithURL:(NSURL *)url progressBlock:(void(^)(float progress))progressBlock successBlock:(void(^)(NSString *fileFullPath))successBlock failBlock:(void(^)())failBlock;

@end

NS_ASSUME_NONNULL_END
