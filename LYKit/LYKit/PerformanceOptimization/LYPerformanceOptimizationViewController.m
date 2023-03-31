//
//  LYPerformanceOptimizationViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYPerformanceOptimizationViewController.h"
#import "LYCrashProtectorViewController.h"
#import "LYCheckANRViewController.h"
#import "LYThreadManagementViewController.h"
#import "LoadLargeImageViewController.h"
#import "ImageDecodeViewController.h"

@interface LYPerformanceOptimizationViewController ()

@end

@implementation LYPerformanceOptimizationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"PerformanceOptimizationCell";
        self.vcTitle = @"性能优化方案";
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
    
    [self.items addObject:[self itemWithTitle:@"线程治理" viewController:[[LYThreadManagementViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"卡顿检测及优化" viewController:[[LYCheckANRViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"防崩溃处理" viewController:[[LYCrashProtectorViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"加载大图优化" viewController:[[LoadLargeImageViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"图像解码和调整大小" viewController:[[ImageDecodeViewController alloc] init]]];
    

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
