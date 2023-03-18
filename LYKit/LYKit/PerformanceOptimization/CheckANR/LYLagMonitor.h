//
//  LYLagMonitor.h
//  LYKit
//
//  Created by zhouluyao on 3/17/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYLagMonitor : NSObject
+ (instancetype)shareInstance;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视
@end

NS_ASSUME_NONNULL_END
