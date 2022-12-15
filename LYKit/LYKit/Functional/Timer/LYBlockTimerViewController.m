//
//  LYBlockTimerViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/15.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYBlockTimerViewController.h"

@interface LYBlockTimerViewController ()
@property (nonatomic,strong)dispatch_source_t timer;
@end

@implementation LYBlockTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self blockTimerWithInetrval:20];
}

- (void)blockTimerWithInetrval:(NSUInteger)time {
    // GCD 方法
    __block NSUInteger timeout = time;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        timeout--;
        if (timeout <= 0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
               //刷新UI界面
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:@"%ld秒后重发", (unsigned long)timeout];
                NSLog(@"title - %@",title);
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)cancelBlockTimer {
    if (self.timer) {
      dispatch_source_cancel(self.timer);
    }
}

@end
