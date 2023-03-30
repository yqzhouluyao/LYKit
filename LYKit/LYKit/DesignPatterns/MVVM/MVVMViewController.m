//
//  MVVMViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "MVVMViewController.h"
#import "UserModel.h"

/*
 此示例演示了 Objective-C iOS 项目中 MVVM 架构的简单实现。
 UserModel 模拟获取用户数据。
 UserViewModel 处理数据并将其公开给 ViewController (View)。
 点击按钮时，ViewController 会使用用户的姓名和年龄更新 UILabel。
 这种架构使您能够分离 UI 和数据处理的职责，从而更容易地独立维护和测试每个部分。
 此外，MVVM 促进了更好的关注点分离，因为 ViewModel 不依赖于 View，这允许组件具有更大的灵活性和可重用性。
 */

@interface MVVMViewController ()

@end

@implementation MVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVVM";
    
    UserModel *userModel = [[UserModel alloc] init];
    UserViewModel *userViewModel = [[UserViewModel alloc] initWithModel:userModel];
    self.viewModel = userViewModel;
}

- (IBAction)fetchDataButtonTapped:(UIButton *)sender {
    [self.viewModel fetchData];
    self.nameLabel.text = self.viewModel.userName;
    self.ageLabel.text = self.viewModel.userAge;
}


@end
