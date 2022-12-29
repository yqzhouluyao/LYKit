//
//  LYGrayStyle.h
//  LYKit
//
//  Created by zhouluyao on 2022/12/29.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYGrayStyle : NSObject

//全局置灰
+ (void)openGlobalGrayStyle;
//关闭全局置灰
+ (void)closeGlobalGrayStyle;

//指定的View置灰
+ (void)openGrayStyleWithView:(UIView *)view;

//关闭指定View置灰
+ (void)closeGrayStyleWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
