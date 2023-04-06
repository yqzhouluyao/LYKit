//
//  WPFMetricKitManager.h
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetricKit/MetricKit.h>

/*
 感谢货拉拉，这个模块代码是根据货拉拉给的思路及代码片段进行的补全
 https://juejin.cn/post/7212622837064368165
 */

typedef NS_ENUM(NSInteger, WPFMetricPayloadType) {
    WPFMetricPayloadTypeDiagnostic,
    // Add other payload types if needed
};

NS_ASSUME_NONNULL_BEGIN
typedef void (^WPFMetricPayloadHandler)(NSArray *payload, WPFMetricPayloadType type);


API_AVAILABLE(ios(13.0))
@interface WPFMetricKitManager : NSObject <MXMetricManagerSubscriber>
@property (nonatomic, strong) NSMutableDictionary<NSString *, WPFMetricPayloadHandler> *subscribers;

+ (instancetype)sharedManager;
+ (NSString *)addSubscriber:(WPFMetricPayloadHandler)handler;
+ (void)removeSubscriber:(NSString *)subscriberID;

@end

NS_ASSUME_NONNULL_END
