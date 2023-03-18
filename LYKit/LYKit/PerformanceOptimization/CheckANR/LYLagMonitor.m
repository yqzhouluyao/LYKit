//
//  LYLagMonitor.m
//  LYKit
//
//  Created by zhouluyao on 3/17/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//
#import "LYLagMonitor.h"

@interface LYLagMonitor () {
    int timeoutCount; // Counter for consecutive timeouts
    CFRunLoopObserverRef runLoopObserver; // Observer for main thread's run loop
    dispatch_semaphore_t dispatchSemaphore; // Semaphore for synchronization
    CFRunLoopActivity runLoopActivity; // Activity of main thread's run loop
}
@property (nonatomic, strong) NSTimer *cpuMonitorTimer; // Timer for CPU monitoring
@end

@implementation LYLagMonitor

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)beginMonitor {
    if (runLoopObserver) { // Check if observer is already registered
        return;
    }
    
    dispatchSemaphore = dispatch_semaphore_create(0); // Create semaphore for synchronization
    
    // Create a context for the observer with a reference to the monitor object
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    
    // Create an observer for all activities on the main thread's run loop
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    
    // Add the observer to the main thread's run loop in the common modes
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    // Create a background thread for monitoring the main thread's run loop
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES) {
            //dispatch_semaphore_wait 函数将阻塞当前线程，直到使用 dispatch_semaphore_signal 向信号量发送信号或 dispatch_time 指定的200ms超时结束。
            long semaphoreWait = dispatch_semaphore_wait(dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 200*NSEC_PER_MSEC));
            
            //如果在接收到信号之前信号量等待超时，则 dispatch_semaphore_wait 函数将返回一个非零值
            if (semaphoreWait != 0) { // Timeout occurred
                //为什么监听kCFRunLoopBeforeSources、kCFRunLoopAfterWaiting这两个活动去判断卡顿？
                //kCFRunLoopBeforeSources表示主线程即将去处理sources、timers、network events、 user input，如果主线程卡在这个状态，可能存在潜在的卡顿
                //kCFRunLoopAfterWaiting表示主线程已经处理完sources准备去休眠，等待下一个时间唤醒，如果主线程卡在这个状态，可能存在潜在的卡顿
                if (runLoopActivity == kCFRunLoopBeforeSources || runLoopActivity == kCFRunLoopAfterWaiting) {
                    // Check if the main thread has been stalled for more than 3 consecutive timeouts
                    if (++timeoutCount < 3) {
                        continue;
                    }
                    
                    NSLog(@"Main thread has been stalled");
                    
                    // Create a high-priority background thread for logging the main thread's stack trace
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        [self logMainThreadStackTrace];
                    });
                }
            } else { // 没有阻塞计数器置为0
                timeoutCount = 0;
            }
        }
    });
}

- (void)stopMonitoring {
    if (runLoopObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
        CFRelease(runLoopObserver);
        runLoopObserver = NULL;
    }
    
    if (dispatchSemaphore) {
        dispatchSemaphore = nil;
    }
}

#pragma mark - Private
//只要主线程Runloop的状态改变就会调用 runLoopObserverCallBack,runloop有6种状态
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    LYLagMonitor *lagMonitor = (__bridge LYLagMonitor*)info;
    //更新主线程runloop的状态为最新的状态
    lagMonitor->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    //状态更新时，dispatch_semaphore_signal 向信号量发送信号，wait 函数将停止阻塞当前线程
    dispatch_semaphore_signal(semaphore);
}

- (void)logMainThreadStackTrace {
    // 打印主线程的调用堆栈
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSString *callStackString = [callStackSymbols componentsJoinedByString:@"\n"];
    NSLog(@"Main Thread Call Stack:\n%@", callStackString);
}

@end


