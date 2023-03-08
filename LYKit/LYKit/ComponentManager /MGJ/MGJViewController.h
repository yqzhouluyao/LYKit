//
//  MGJViewController.h
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef UIViewController *(^ViewControllerHandler)();
NS_ASSUME_NONNULL_BEGIN

@interface MGJViewController : UIViewController

+ (void)registerWithTitle:(NSString *)title handler:(ViewControllerHandler)handler;

@end

NS_ASSUME_NONNULL_END
