//
//  WPFMetricKitManager.m
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "WPFMetricKitManager.h"

@implementation WPFMetricKitManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _subscribers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (instancetype)sharedManager {
    static WPFMetricKitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WPFMetricKitManager alloc] init];
        if (@available(iOS 13.0, *)) {
            // Set the WPFMetricKitManager instance as a subscriber
            [[MXMetricManager sharedManager] addSubscriber:instance];
        }
    });
    return instance;
}



+ (NSString *)addSubscriber:(WPFMetricPayloadHandler)handler {
    WPFMetricKitManager *manager = [WPFMetricKitManager sharedManager];
    NSString *subscriberID = [[NSUUID UUID] UUIDString];
    manager.subscribers[subscriberID] = handler;
    return subscriberID;
}

+ (void)removeSubscriber:(NSString *)subscriberID {
    WPFMetricKitManager *manager = [WPFMetricKitManager sharedManager];
    [manager.subscribers removeObjectForKey:subscriberID];
}

- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        // Remove the WPFMetricKitManager instance as a subscriber
        [[MXMetricManager sharedManager] removeSubscriber:self];
    }
}

#pragma mark - MXMetricManagerSubscriber
- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> *)payloads {
    for (WPFMetricPayloadHandler handler in self.subscribers.allValues) {
        handler(payloads, WPFMetricPayloadTypeDiagnostic);
    }
}

@end
