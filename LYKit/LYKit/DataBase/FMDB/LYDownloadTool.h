//
//  LYDownloadTool.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/4.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LYDownloadTool : NSObject
+ (instancetype)shareInstance;

//添加音乐
- (void)addDownloadMusicModel:(LYMusicModel *)musicModel;

//查询已下载的音乐
- (void)fetchDownloadedMusicModel:(void(^)(NSArray <LYMusicModel *>*downloadedMusics))result;

////根据url更新下载音乐的状态
- (void)updateMusicModelStatus:(BOOL)isDownLoaded withURL:(NSString *)url;

//根据url删除下载的音乐
- (void)deleteMusicModelWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
