//
//  LYGrayStyleViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/29.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYGrayStyleViewController.h"
#import "LYGrayStyle.h"

@interface LYGrayStyleViewController ()
@property (nonatomic, strong) UIImageView *coverImageView;
@end

@implementation LYGrayStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.coverImageView];
    
    UIButton *grayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 80, 30)];
    [grayStyleBtn addTarget:self action:@selector(grayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [grayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [grayStyleBtn setTitle:@"全局置灰" forState:UIControlStateNormal];
    [self.view addSubview:grayStyleBtn];
    
    UIButton *cancelGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 80, 30)];
    [cancelGrayStyleBtn addTarget:self action:@selector(cancelGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelGrayStyleBtn setTitle:@"取消置灰" forState:UIControlStateNormal];
    [self.view addSubview:cancelGrayStyleBtn];
    
    UIButton *imageGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, 120, 30)];
    [imageGrayStyleBtn addTarget:self action:@selector(imageGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [imageGrayStyleBtn setTitle:@"置灰图片1" forState:UIControlStateNormal];
    [self.view addSubview:imageGrayStyleBtn];
    
    
    UIButton *cancelImageGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 400, 120, 30)];
    [cancelImageGrayStyleBtn addTarget:self action:@selector(cancelImageGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelImageGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelImageGrayStyleBtn setTitle:@"取消置灰图片1" forState:UIControlStateNormal];
    [self.view addSubview:cancelImageGrayStyleBtn];
    
    
}

- (void)grayStyleBtnClick {
    [LYGrayStyle openGlobalGrayStyle];
}

- (void)cancelGrayStyleBtnClick {
    [LYGrayStyle closeGlobalGrayStyle];
}

- (void)imageGrayStyleBtnClick {
    [LYGrayStyle openGrayStyleWithView:self.coverImageView];
}

- (void)cancelImageGrayStyleBtnClick {
    [LYGrayStyle closeGrayStyleWithView:self.coverImageView];
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
        _coverImageView.image = [UIImage imageNamed:@"years_share_icon"];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

@end
