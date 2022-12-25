//
//  UIView+Frame.h
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/17/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (Frame)

/** View's X Position */
@property (nonatomic, assign) CGFloat   zg_x;

/** View's Y Position */
@property (nonatomic, assign) CGFloat   zg_y;

/** View's width */
@property (nonatomic, assign) CGFloat   zg_width;

/** View's height */
@property (nonatomic, assign) CGFloat   zg_height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint   zg_origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize    zg_size;

/** Y value representing the bottom of the view **/
@property (nonatomic, assign) CGFloat   zg_bottom;

/** X Value representing the right side of the view **/
@property (nonatomic, assign) CGFloat   zg_right;

/** X Value representing the top of the view (alias of x) **/
@property (nonatomic, assign) CGFloat   zg_left;

/** Y Value representing the top of the view (alias of y) **/
@property (nonatomic, assign) CGFloat   zg_top;

/** X value of the object's center **/
@property (nonatomic, assign) CGFloat   zg_centerX;

/** Y value of the object's center **/
@property (nonatomic, assign) CGFloat   zg_centerY;

- (UIViewController*)viewController;

@end


