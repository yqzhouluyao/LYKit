//
//  UIColor+Hex.m
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/17/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import "UIColor+Hex.h"

CGFloat zgColorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (Hex)

+ (UIColor *)zg_colorWithHex:(UInt32)hex{
    return [UIColor zg_colorWithHex:hex andAlpha:1];
}

+ (UIColor *)zg_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)zg_colorWithString:(NSString *)hexString{
    return [self zg_colorWithHexString:hexString];
}

+ (UIColor *)zg_colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = zgColorComponentFrom(colorString, 0, 1);
            green = zgColorComponentFrom(colorString, 1, 1);
            blue  = zgColorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = zgColorComponentFrom(colorString, 0, 1);
            red   = zgColorComponentFrom(colorString, 1, 1);
            green = zgColorComponentFrom(colorString, 2, 1);
            blue  = zgColorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = zgColorComponentFrom(colorString, 0, 2);
            green = zgColorComponentFrom(colorString, 2, 2);
            blue  = zgColorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = zgColorComponentFrom(colorString, 0, 2);
            red   = zgColorComponentFrom(colorString, 2, 2);
            green = zgColorComponentFrom(colorString, 4, 2);
            blue  = zgColorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIColor *)zg_black_1 { // #333333
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor zg_colorWithString:@"#333333"];
            } else {
                return [UIColor zg_colorWithString:@"#DDDDDD"];
            }
        }];
    }
#endif
    return [UIColor zg_colorWithString:@"#333333"];
}

+ (UIColor *)zg_black_2 {  // #666666
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor zg_colorWithString:@"#666666"];
            } else {
                return [UIColor zg_colorWithString:@"#AAAAAA"];
            }
        }];
    }
#endif
    return [UIColor zg_colorWithString:@"#666666"];
}

+ (UIColor *)zg_black_3 {  // #999999
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor zg_colorWithString:@"#999999"];
            } else {
                return [UIColor zg_colorWithString:@"#666666"];
            }
        }];
    }
#endif
    return [UIColor zg_colorWithString:@"#999999"];
}

+ (UIColor *)zg_blue {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor zg_colorWithString:@"#337CC4"];
            } else {
                return [UIColor systemBlueColor];
            }
        }];
    }
#endif
    return [UIColor zg_colorWithString:@"#337CC4"];
}

+ (UIColor *)zg_orange {
    return [UIColor zg_colorWithString:@"#FF8903"];
}

+ (UIColor *)zg_bg{ // #F4F5F6
    return [UIColor zg_colorWithString:@"#F4F5F6"];
}

+ (UIColor *)zg_cellTouch{
    return [self zg_colorWithRed:219 green:219 blue:219];
}

+ (UIColor *)zg_cellTouchDark {
    return [self zg_colorWithRed:47 green:47 blue:47];
}

+ (UIColor *)zg_cellNormal {
    return [UIColor whiteColor];
}

+ (UIColor *)zg_cellNormalDark {
    return [self zg_colorWithRed:35 green:35 blue:35];
}

+ (UIColor *)zg_TextColor {
    return [UIColor blackColor];
}

+ (UIColor *)zg_TextColorDark {
    return [self zg_colorWithRed:217 green:217 blue:217];
}

+ (UIColor *)zg_ControllerBackgroundColor {
    return [self zg_colorWithRed:237 green:237 blue:237];
}

+ (UIColor *)zg_ControllerBackgroundColorDark {
    return [self zg_colorWithRed:25 green:25 blue:25];
}

+ (UIColor *)zg_line {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor zg_colorWithHex:0x000000 andAlpha:0.1];
            } else {
                return [UIColor zg_colorWithHex:0x68686B andAlpha:0.6];
            }
        }];
    }
#endif
    return [UIColor zg_colorWithHex:0x000000 andAlpha:0.1];
}

+ (UIColor *)zg_randomColor {
    CGFloat red = ( arc4random() % 255 / 255.0 );
    CGFloat green = ( arc4random() % 255 / 255.0 );
    CGFloat blue = ( arc4random() % 255 / 255.0 );
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)zg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self zg_colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)zg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    CGFloat redColor = ( red / 255.0 );
    CGFloat greenColor = ( green / 255.0 );
    CGFloat blueColor = ( blue / 255.0 );
    return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
}

@end
