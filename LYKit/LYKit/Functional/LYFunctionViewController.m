//
//  FunctionViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYFunctionViewController.h"

@interface LYFunctionViewController ()

@end

@implementation LYFunctionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"FunctionCell";
        self.vcTitle = @"功能模块";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
