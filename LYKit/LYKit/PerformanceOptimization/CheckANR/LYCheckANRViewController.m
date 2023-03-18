//
//  LYCheckANRViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYCheckANRViewController.h"
#import "LYLagMonitor.h"

@interface LYCheckANRViewController ()

@end

@implementation LYCheckANRViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"CheckANRCell";
        self.vcTitle = @"检测卡顿的方案列表";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //猿题库架构设计 https://www.cnblogs.com/yulang314/p/5091342.html
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"根据主线程runloop的状态判断是否卡顿" viewController:[[UIViewController alloc] init]]];
    
}

- (void)ANRCheck {
    [[LYLagMonitor shareInstance] beginMonitor];
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
