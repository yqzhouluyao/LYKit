//
//  LYMVPViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "MVPViewController.h"
#import "UserModel.h"
#import "UserPresenter.h"

/*
 UserModel 模拟获取用户数据，当点击按钮时，
 UserPresenter 使用获取的数据更新 ViewController (View)。
 */

@interface MVPViewController ()

@end

@implementation MVPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVP";
    
    UserModel *userModel = [[UserModel alloc] init];
    UserPresenter *userPresenter = [[UserPresenter alloc] initWithView:self model:userModel];
    self.presenter = userPresenter;
}

- (void)displayUserData:(User *)user {
    self.nameLabel.text = user.name;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)user.age];
}

- (IBAction)fetchDataButtonTapped:(UIButton *)sender {
    [self.presenter fetchData];
}

@end
