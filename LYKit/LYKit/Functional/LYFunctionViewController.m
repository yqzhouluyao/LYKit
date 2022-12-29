//
//  FunctionViewController.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYFunctionViewController.h"
#import "LYThemeManagerViewController.h"
#import "LYHitTestViewController.h"
#import "LYWebViewController.h"
#import "LYUnitTestViewController.h"
#import "LYDanMuViewController.h"
#import "RichTextViewController.h"
#import "LYRotationViewController.h"
#import "LYWebUploadViewController.h"
#import "LYGrayStyleViewController.h"

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
    //猿题库架构设计 https://www.cnblogs.com/yulang314/p/5091342.html
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"图文混排" viewController:[RichTextViewController new]]];
    [self.items addObject:[self itemWithTitle:@"主题切换" viewController:[LYThemeManagerViewController new]]];
    [self.items addObject:[self itemWithTitle:@"电脑局域网传输文件到手机" viewController:[LYWebUploadViewController new]]];
    [self.items addObject:[self itemWithTitle:@"Socket通信" viewController:[LYThemeManagerViewController new]]];
    [self.items addObject:[self itemWithTitle:@"响应链扩大响应区域" viewController:[LYHitTestViewController new]]];
    [self.items addObject:[self itemWithTitle:@"JS与OC的交互" viewController:[LYWebViewController new]]];
    [self.items addObject:[self itemWithTitle:@"单元测试" viewController:[LYUnitTestViewController new]]];
    [self.items addObject:[self itemWithTitle:@"弹幕" viewController:[LYDanMuViewController new]]];
    [self.items addObject:[self itemWithTitle:@"计时器" viewController:[LYDanMuViewController new]]];
    [self.items addObject:[self itemWithTitle:@"iOS16屏幕旋转，view的变化" viewController:[LYRotationViewController new]]];
    [self.items addObject:[self itemWithTitle:@"纪念日置灰" viewController:[LYGrayStyleViewController new]]];
    

}

- (LYKitCellItem *)itemWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    
    void(^block)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController pushViewController:viewController animated:YES];
            }
        });
    };
    LYKitCellItem *item = [LYKitCellItem itemWithTitle:title block:block];
    return item;
}

@end
