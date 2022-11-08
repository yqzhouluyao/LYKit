//
//  LYDownloadTask.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYDownloadTask : NSObject

- (void)downLoadWithURL: (NSURL *)url withProgressBlock: (void(^)(float progress))progress success:(void(^)(NSString *downLoadPath))sucess failed:(void(^)())fail;

@property (nonatomic, strong, readonly) NSURL *downLoadURL;


/**
 用于记录是否正在下载
 */
@property (nonatomic, assign, readonly) BOOL isDownloading;

/**
 当前下载任务的进度
 */
@property (nonatomic, assign, readonly) float progress;

- (void)pause;
- (void)resume;
- (void)cancel;

+ (long long int)cacheFileSizeWithURL:(NSURL *)url;
+ (void)removeCacheFileWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
