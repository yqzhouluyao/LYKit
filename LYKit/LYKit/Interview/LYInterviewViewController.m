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
    // Do any additional setup after loading the view.
}


@end
