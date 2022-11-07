//
//  LYDanMuBackGroundViewDelegate.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYDanMuModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LYDanMuBackGroundViewDelegate <NSObject>
/**
 当前时间
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;


/**
 根据model 获取相应的弹幕视图(又外界来控制)

 @param model 弹幕模型

 @return 弹幕视图
 */
- (UIView *)danmuViewWithModel: (LYDanMuModel*)model;
@end

NS_ASSUME_NONNULL_END
