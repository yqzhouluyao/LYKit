//
//  LYNetworkViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYNetworkViewController.h"
#import "LYDownloadViewController.h"
#import "LYWebUploadViewController.h"

@interface LYNetworkViewController ()

@end

@implementation LYNetworkViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"NetworkCell";
        self.vcTitle = @"网络模块";
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
    

    [self.items addObject:[self itemWithTitle:@"电脑局域网传输文件到手机" viewController:[LYWebUploadViewController new]]];
    [self.items addObject:[self itemWithTitle:@"网络下载断点续传" viewController:[LYDownloadViewController new]]];

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
