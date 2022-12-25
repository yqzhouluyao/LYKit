//
//  UIView+Frame.m
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/17/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import "UIView+Frame.h"
#define Zg_SCREEN_SCALE                    ([[UIScreen mainScreen] scale])
#define Zg_PIXEL_INTEGRAL(pointValue)      (round(pointValue * Zg_SCREEN_SCALE) / Zg_SCREEN_SCALE)

@implementation UIView (Frame)


@dynamic zg_x, zg_y, zg_width, zg_height, zg_origin, zg_size;

// Setters
-(void)setZg_x:(CGFloat)x{
    self.frame      = CGRectMake(Zg_PIXEL_INTEGRAL(x), self.zg_y, self.zg_width, self.zg_height);
}

-(void)setZg_y:(CGFloat)y{
    self.frame      = CGRectMake(self.zg_x, Zg_PIXEL_INTEGRAL(y), self.zg_width, self.zg_height);
}

-(void)setZg_width:(CGFloat)width{
    self.frame      = CGRectMake(self.zg_x, self.zg_y, Zg_PIXEL_INTEGRAL(width), self.zg_height);
}

-(void)setZg_height:(CGFloat)height{
    self.frame      = CGRectMake(self.zg_x, self.zg_y, self.zg_width, Zg_PIXEL_INTEGRAL(height));
}

-(void)setZg_origin:(CGPoint)origin{
    self.zg_x          = origin.x;
    self.zg_y          = origin.y;
}

-(void)setZg_size:(CGSize)size{
    self.zg_width      = size.width;
    self.zg_height     = size.height;
}

-(void)setZg_right:(CGFloat)right {
    self.zg_x          = right - self.zg_width;
}

-(void)setZg_bottom:(CGFloat)bottom {
    self.zg_y          = bottom - self.zg_height;
}

-(void)setZg_left:(CGFloat)left{
    self.zg_x          = left;
}

-(void)setZg_top:(CGFloat)top{
    self.zg_y          = top;
}

-(void)setZg_centerX:(CGFloat)centerX {
    self.center     = CGPointMake(Zg_PIXEL_INTEGRAL(centerX), self.center.y);
}

-(void)setZg_centerY:(CGFloat)centerY {
    self.center     = CGPointMake(self.center.x, Zg_PIXEL_INTEGRAL(centerY));
}

// Getters
-(CGFloat)zg_x{
    return self.frame.origin.x;
}

-(CGFloat)zg_y{
    return self.frame.origin.y;
}

-(CGFloat)zg_width{
    return self.frame.size.width;
}

-(CGFloat)zg_height{
    return self.frame.size.height;
}

-(CGPoint)zg_origin{
    return CGPointMake(self.zg_x, self.zg_y);
}

-(CGSize)zg_size{
    return CGSizeMake(self.zg_width, self.zg_height);
}

-(CGFloat)zg_right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)zg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)zg_left{
    return self.zg_x;
}

-(CGFloat)zg_top{
    return self.zg_y;
}

-(CGFloat)zg_centerX {
    return self.center.x;
}

-(CGFloat)zg_centerY {
    return self.center.y;
}

-(UIViewController*)viewController{
    for(UIView *next =self.superview ; next ; next = next.superview){
        UIResponder*nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return(UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
