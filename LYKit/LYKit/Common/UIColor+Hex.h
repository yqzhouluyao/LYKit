//
//  UIColor+Hex.h
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/17/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

/// 用法：[UIColor zg_colorWithHex:0x337CC4]
+ (UIColor *)zg_colorWithHex:(UInt32)hex;

/// 用法： [UIColor zg_colorWithHex:0x999999 andAlpha:0.2]
+ (UIColor *)zg_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/// 用法： [UIColor zg_colorWithHexString:@"#337CC4"]
+ (UIColor *)zg_colorWithHexString:(NSString *)hexString;

///用法：[UIColor zg_colorWithString:@"#324456"]
+ (UIColor *)zg_colorWithString:(NSString *)hexString;

+ (UIColor *)zg_black_1;//#333333
+ (UIColor *)zg_black_2;//#666666
+ (UIColor *)zg_black_3;//#999999
+ (UIColor *)zg_blue;//#337CC4
+ (UIColor *)zg_orange; //#FF8903

+ (UIColor *)zg_line;//[UIColor zg_colorWithHex:0x000000 andAlpha:0.1];

+ (UIColor *)zg_randomColor;

+ (UIColor *)zg_bg; //#F4F5F6

+ (UIColor *)zg_cellTouch; //cell触摸时颜色

+ (UIColor *)zg_cellTouchDark; //DarkModel cell触摸时颜色

+ (UIColor *)zg_cellNormal; //cell颜色

+ (UIColor *)zg_cellNormalDark; //DarkModel cell颜色

+ (UIColor *)zg_TextColor; //标题颜色

+ (UIColor *)zg_TextColorDark; //DarkModel 标题颜色

+ (UIColor *)zg_ControllerBackgroundColor; //控制器背景颜色

+ (UIColor *)zg_ControllerBackgroundColorDark; //DarkModel 控制器背景颜色
@end

NS_ASSUME_NONNULL_END
