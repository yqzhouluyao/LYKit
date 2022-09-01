//
//  FunctionViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYFunctionViewController.h"
#import "LYThemeManagerViewController.h"
#import "LYHitTestViewController.h"

@interface LYFunctionViewController ()

@end

@implementation LYFunctionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"FunctionCell";
        self.vcTitle = @"功能模块";
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
    
    [self.items addObject:[self itemWithTitle:@"图文混排" viewController:[[LYThemeManagerViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"主题切换" viewController:[[LYThemeManagerViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"Socket通信" viewController:[[LYThemeManagerViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"响应链扩大响应区域" viewController:[[LYHitTestViewController alloc] init]]];
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
