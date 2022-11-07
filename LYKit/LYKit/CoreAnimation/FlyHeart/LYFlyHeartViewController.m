//
//  LYFlyHeartViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYFlyHeartViewController.h"
#import "DMHeartFlyView.h"

@interface LYFlyHeartViewController ()

@end

@implementation LYFlyHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGester:)];
    [self.view addGestureRecognizer:tapGester];
    
}

- (void)tapGester: (UITapGestureRecognizer *)tap {

    CGPoint point = [tap locationInView:self.view];

    CGFloat _heartSize = 36;
    DMHeartFlyView *heart = [[DMHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    heart.center = point;
    [heart animateInView:self.view];
}

@end
