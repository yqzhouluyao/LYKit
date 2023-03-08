//
//  MGJViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "MGJViewController.h"
static NSMutableDictionary *titleWithHandlers;
static NSMutableArray *titles;

@interface MGJViewController ()

@end

@implementation MGJViewController

+ (void)registerWithTitle:(NSString *)title handler:(UIViewController *(^)())handler
{
    if (!titleWithHandlers) {
        titleWithHandlers = [[NSMutableDictionary alloc] init];
        titles = [NSMutableArray array];
    }
    [titles addObject:title];
    titleWithHandlers[title] = handler;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *viewController = ((ViewControllerHandler)titleWithHandlers[titles[0]])();
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
