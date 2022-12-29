//
//  LYGrayStyle.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/29.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYGrayStyle.h"

@interface CoverGrayView : UIView

@end

@implementation CoverGrayView

+(NSMutableArray *)grayStyleViews {
    static NSMutableArray *grayStyleViews;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        grayStyleViews = [NSMutableArray array];
    });
    return grayStyleViews;
}

+ (void)addGrayStyleToView:(UIView *)grayView {
    if (@available(iOS 13, *)) {
        // iOS13 以后支持

        // 遍历是否已添加 gray cover view
        for (UIView *subview in grayView.subviews) {
            if ([subview isKindOfClass:CoverGrayView.class]) {
                return;
            }
        }

        CoverGrayView *coverView = [[CoverGrayView alloc] initWithFrame:grayView.bounds];
        coverView.userInteractionEnabled = NO;
        coverView.backgroundColor = [UIColor lightGrayColor];
        coverView.layer.compositingFilter = @"saturationBlendMode";
        coverView.layer.zPosition = FLT_MAX;
        [grayView addSubview:coverView];
        
        [self.grayStyleViews addObject:coverView];
    }

}

@end

@implementation LYGrayStyle

//全局置灰
+ (void)openGlobalGrayStyle {
    NSAssert(NSThread.isMainThread, @"必须在主线程调用!");
    NSMutableSet *windows = [NSMutableSet set];
    [windows addObjectsFromArray:UIApplication.sharedApplication.windows];
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) {
                continue;
            }
            [windows addObjectsFromArray:scene.windows];
        }
    }
    // 遍历所有window，给它们加上蒙版
    for (UIWindow *window in windows) {
        NSString *className = NSStringFromClass(window.class);
        if (![className containsString:@"UIText"]) {
            [CoverGrayView addGrayStyleToView:window];
        }
    }
}
//关闭全局置灰
+ (void)closeGlobalGrayStyle {
    NSAssert(NSThread.isMainThread, @"必须在主线程调用!");
    for (UIView *coverView in CoverGrayView.grayStyleViews) {
        [coverView removeFromSuperview];
    }
}

//指定的View置灰
+ (void)openGrayStyleWithView:(UIView *)view {
    [CoverGrayView addGrayStyleToView:view];
}

//关闭指定View置灰
+ (void)closeGrayStyleWithView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:CoverGrayView.class]) {
            [subview removeFromSuperview];
        }
    }
}

@end
