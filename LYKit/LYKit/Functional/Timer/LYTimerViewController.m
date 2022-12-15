//
//  LYTimerViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/14.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYTimerViewController.h"
#import "LYWeakTimerViewController.h"
#import "LYBlockTimerViewController.h"

@interface LYTimerViewController ()

@end

@implementation LYTimerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"TimerCell";
        self.vcTitle = @"计时器列表";
    }
    return self;
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"weak Timer" viewController:[LYWeakTimerViewController new]]];
    [self.items addObject:[self itemWithTitle:@"block Timer" viewController:[LYBlockTimerViewController new]]];
}

- (LYKitCellItem *)itemWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    
    void(^block)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController pushViewController:viewController animated:YES];
            }
        });
    };
    LYKitCellItem *item = [LYKitCellItem itemWithTitle:title block:block];
    return item;
}

@end
