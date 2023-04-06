//
//  CrashTestingViewController.m
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "CrashTestingViewController.h"

@interface CrashTestingViewController ()

@end

@implementation CrashTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"Division by Zero", @"Array Out of Bounds", @"Uncaught Exception", @"Null Pointer Exception"];
    SEL selectors[] = {@selector(triggerDivisionByZero),
                       @selector(triggerArrayOutOfBounds),
                       @selector(triggerUncaughtException),
                       @selector(triggerNullPointerException)};
    
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 40;
    CGFloat padding = 20;
    CGFloat initialY = 100;
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((self.view.bounds.size.width - buttonWidth) / 2,
                                  initialY + i * (buttonHeight + padding),
                                  buttonWidth,
                                  buttonHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:selectors[i] forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)triggerDivisionByZero {
    int x = 0;
    int y = 10 / x;
}

- (void)triggerArrayOutOfBounds {
    NSArray *array = @[@"one", @"two", @"three"];
    id element = array[5];
}

- (void)triggerUncaughtException {
    @throw [NSException exceptionWithName:@"UncaughtException" reason:@"Testing uncaught exception" userInfo:nil];
}

- (void)triggerNullPointerException {
    NSMutableArray *mutableArray = nil;
    [mutableArray addObject:@"test"];
}


@end
