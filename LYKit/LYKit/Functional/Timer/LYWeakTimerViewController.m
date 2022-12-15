//
//  LYWeakTimerViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/14.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYWeakTimerViewController.h"
#import "YYWeakProxy.h"

@interface LYWeakTimerViewController () {
    int countdown;
}

@property (nonatomic, strong)NSTimer *weakTimer;
@end

@implementation LYWeakTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    countdown = 60;
}



- (void)startTimer {
    if (!_weakTimer) {
        _weakTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self]
                                                selector:@selector(onCheck)
                                                userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)onCheck {
    countdown --;
    if (countdown < 0) {
        [self.weakTimer invalidate];
        self.weakTimer=nil;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.weakTimer == nil)  {
        [self startTimer];
    }
}
@end
