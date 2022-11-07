//
//  CALayer+Animation.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Animation)
// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;
@end

NS_ASSUME_NONNULL_END
