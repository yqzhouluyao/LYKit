//
//  ArchitectureViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//

#import "LYArchitectureViewController.h"
#import "APEHomePracticeViewController.h"
#import "LYMVVMViewController.h"

@interface LYArchitectureViewController ()

@end

@implementation LYArchitectureViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"ArchitectureCell";
        self.vcTitle = @"App架构列表";
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
    
    [self.items addObject:[self itemWithTitle:@"猿题库架构实现demo" viewController:[[APEHomePracticeViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"MVVM架构" viewController:[[LYMVVMViewController alloc] init]]];
    
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
