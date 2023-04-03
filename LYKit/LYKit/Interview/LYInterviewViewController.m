//
//  InterviewViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYInterviewViewController.h"

@interface LYInterviewViewController ()

@end

@implementation LYInterviewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"InterviewCell";
        self.vcTitle = @"面试题代码实现";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:view];
    view.bounds = CGRectMake(10, 10, 150, 150);
    NSLog(@"1: %@", NSStringFromCGRect(view.frame));
    view.layer.anchorPoint = CGPointMake(0, 0);
    NSLog(@"2: %@", NSStringFromCGRect(view.frame));
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    NSLog(@"3: %@", NSStringFromCGRect(view.frame));
}


@end
