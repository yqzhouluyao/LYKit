//
//  LYDanMuBackGroundView.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYDanMuBackGroundViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface LYDanMuBackGroundView : UIView
/**
 弹幕模型数组, 只要外界向这个数组追加数据, 控件内部就会根据时间自动的弹出该弹幕
 */
@property (nonatomic, strong) NSMutableArray *danmuModels;
@property (nonatomic, weak) id<LYDanMuBackGroundViewDelegate> delegate;
- (void)pause;

- (void)resume;
@end

NS_ASSUME_NONNULL_END
