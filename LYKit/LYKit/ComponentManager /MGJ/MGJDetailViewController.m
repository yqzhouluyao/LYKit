//
//  MGJDetailViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "MGJDetailViewController.h"
#import "MGJViewController.h"
#import "MGJRouter.h"

@interface MGJDetailViewController ()
@property (nonatomic) SEL selectedSelector;
@end

@implementation MGJDetailViewController

+ (void)load
{
    MGJDetailViewController *detailViewController = [[MGJDetailViewController alloc] init];
    [MGJViewController registerWithTitle:@"基本使用" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoBasicUsage);
        return detailViewController;
    }];
    
    [MGJViewController registerWithTitle:@"Open 结束后执行 Completion Block" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoCompletion);
        return detailViewController;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)demoBasicUsage
{
    [MGJRouter registerURLPattern:@"mgj://foo/bar" toHandler:^(NSDictionary *routerParameters) {
        NSLog(@"routerParameters:%@", routerParameters);
    }];
    
    [MGJRouter openURL:@"mgj://foo/bar"];
}

- (void)demoCompletion
{
[MGJRouter registerURLPattern:@"mgj://detail" toHandler:^(NSDictionary *routerParameters) {
    NSLog(@"匹配到了 url, 一会会执行 Completion Block");
    
    // 模拟 push 一个 VC
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        void (^completion)() = routerParameters[MGJRouterParameterCompletion];
        if (completion) {
            completion();
        }
    });
}];

[MGJRouter openURL:@"mgj://detail" withUserInfo:nil completion:^{
    
}];
}

@end
