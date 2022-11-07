//
//  LYDanMuModel.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYDanMuModel : NSObject

/** 弹幕标题 */
@property (nonatomic, strong) NSString *title;
/** 弹幕开始弹出时间点 */
@property (nonatomic, assign) NSTimeInterval beginTime;
/** 弹幕存活时间(动画时间) */
@property (nonatomic, assign) NSTimeInterval liveTime;
@end

NS_ASSUME_NONNULL_END
