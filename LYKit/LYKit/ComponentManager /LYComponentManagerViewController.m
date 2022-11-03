//
//  LYComponentManagerViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYComponentManagerViewController.h"
#import "LYLinkHomeViewController.h"
#import "LYMediatorPracticeViewController.h"

@interface LYComponentManagerViewController ()

@end

@implementation LYComponentManagerViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"ModuleCell";
        self.vcTitle = @"组件化方案";
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
    
    [self.items addObject:[self itemWithTitle:@"链家组件化方案" viewController:[[LYLinkHomeViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"CTMediator的实践" viewController:[[LYMediatorPracticeViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"Target-Action 蘑菇街方案" viewController:[[LYMediatorPracticeViewController alloc] init]]];
    
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
