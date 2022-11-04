//
//  LYMusicModel.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/4.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYMusicModel : NSObject

/**
 专辑ID
 */
@property (nonatomic, assign) NSInteger albumId;

/**
 下载的URL
 */
@property (nonatomic, copy) NSString *downloadUrl;

/**
 专辑名称
 */
@property (nonatomic, copy) NSString *albumTitle;

/**
 是否已经下载
 */
@property (nonatomic, assign) BOOL isDownLoaded;

@end

NS_ASSUME_NONNULL_END
