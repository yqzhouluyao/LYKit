//
//  LYCalculatorTool.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYCalculatorTool : NSObject

+ (int)add:(int)a b:(int)b;
+ (int)sub:(int)a b:(int)b;
+ (int)multiple:(int)a b:(int)b;
+ (double)devide:(int)a b:(int)b;

@end

NS_ASSUME_NONNULL_END
