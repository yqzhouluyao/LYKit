//
//  InvestmentPrinciplesViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYAVFoundationViewController.h"

@interface LYAVFoundationViewController ()

@end

@implementation LYAVFoundationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"AVFoundationCell";
        self.vcTitle = @"AVFoundation的示例列表";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
