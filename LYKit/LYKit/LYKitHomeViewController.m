//
//  LYKitHomeViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYKitHomeViewController.h"
#import "LYKitCellItem.h"
#import "FunctionViewController.h"
#import "InterviewViewController.h"
#import "InvestmentPrinciplesViewController.h"

@interface LYKitHomeViewController ()

@end

@implementation LYKitHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"HomeCell";
        self.vcTitle = @"LYKit";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"功能模块" viewController:[[FunctionViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"面试题代码实现" viewController:[[InterviewViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"投资原则" viewController:[[InvestmentPrinciplesViewController alloc] init]]];
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
