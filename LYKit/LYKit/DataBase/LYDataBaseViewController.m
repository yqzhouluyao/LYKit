//
//  LYDataBaseViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 https://github.com/yqzhouluyao. All rights reserved.
//

#import "LYDataBaseViewController.h"
#import "LYKeyValueStoreViewController.h"

@interface LYDataBaseViewController ()

@end

@implementation LYDataBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //猿题库架构设计 https://www.cnblogs.com/yulang314/p/5091342.html
}

- (void)setupItems {
    [super setupItems];
    
    
    [self.items addObject:[self itemWithTitle:@"猿题库数据存储方案" viewController:[[LYKeyValueStoreViewController alloc] init]]];
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
