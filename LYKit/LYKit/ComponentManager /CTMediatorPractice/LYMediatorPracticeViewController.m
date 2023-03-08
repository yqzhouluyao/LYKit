//
//  LYMediatorPracticeViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYMediatorPracticeViewController.h"
#import "CTMediator+QuestionKit.h"

@interface LYMediatorPracticeViewController ()
@property (nonatomic, strong) UIButton *pushAViewControllerButton;
@end

@implementation LYMediatorPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.pushAViewControllerButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.pushAViewControllerButton sizeToFit];
    
}

- (void)didTappedPushAViewControllerButton:(UIButton *)button
{
    UIViewController *viewController = [[CTMediator sharedInstance] questionKitViewControllerWithCallback:^(NSString * _Nonnull result) {
        
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - getters and setters
- (UIButton *)pushAViewControllerButton
{
    if (_pushAViewControllerButton == nil) {
        _pushAViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushAViewControllerButton.frame = CGRectMake(100, 200, 300, 50);
        [_pushAViewControllerButton setTitle:@"push A view controller" forState:UIControlStateNormal];
        [_pushAViewControllerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_pushAViewControllerButton addTarget:self action:@selector(didTappedPushAViewControllerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushAViewControllerButton;
}

@end
