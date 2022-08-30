//
//  InterviewViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "InterviewViewController.h"

@interface InterviewViewController ()

@end

@implementation InterviewViewController

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
