//
//  LYDataBaseViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 https://github.com/yqzhouluyao. All rights reserved.
//

#import "LYDataBaseViewController.h"
#import "LYKeyValueStoreViewController.h"
#import "LYFMDBViewController.h"
#import "LYCoreDataViewController.h"

@interface LYDataBaseViewController ()

@end

@implementation LYDataBaseViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"DataBaseCell";
        self.vcTitle = @"数据库存储方案列表";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"FMDB操作模型数据" viewController:[[LYFMDBViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"猿题库数据存储方案" viewController:[[LYKeyValueStoreViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"CoreData实现级联查询" viewController:[LYCoreDataViewController new]]];
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

-(void)dealloc {
    
}
@end
