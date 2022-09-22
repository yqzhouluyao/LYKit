//
//  LYCalculatorTool.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYCalculatorTool.h"

@implementation LYCalculatorTool

+ (int)add:(int)a b:(int)b {
    return a + b;
}

+ (int)sub:(int)a b:(int)b {
    return a - b;
}

+ (int)multiple:(int)a b:(int)b {
    return a * b;
}

+ (double)devide:(int)a b:(int)b {
    if(b == 0) {
        return 0;
    }
    return  1.0 * a / b;
}

@end
