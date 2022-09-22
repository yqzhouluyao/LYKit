//
//  LYUnitTestViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYUnitTestViewController.h"

@interface LYUnitTestViewController ()

@end

@implementation LYUnitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //在LYKitTests.m 文件中对LYCalculatorTool这个类实现的基本运算功能，进行了单元测试
    //在LYKitTests.m 文件中对LYNetworkRequest这个类实现的网络请求功能，进行了单元测试
    
    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"单元测试" message:@"在LYKitTests.m 文件中对LYCalculatorTool这个类实现的基本运算功能，进行了单元测试" preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self networkRequestUnitTest];
    }])];
    [self presentViewController:alertController1 animated:YES completion:nil];
}

- (void)networkRequestUnitTest {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"单元测试" message:@"在LYKitTests.m 文件中对LYNetworkRequest这个类实现的网络请求功能，进行了单元测试" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
