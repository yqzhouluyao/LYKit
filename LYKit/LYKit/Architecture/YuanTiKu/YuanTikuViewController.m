//
//  YuanTikuViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//

//本demo的实现基于https://www.cnblogs.com/yulang314/p/5091342.html
#import "YuanTikuViewController.h"

@interface YuanTikuViewController ()

@end

@implementation YuanTikuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"YuanTikuCell";
        self.vcTitle = @"猿题库架构实现demo";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
