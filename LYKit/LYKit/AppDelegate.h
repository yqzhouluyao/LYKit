//
//  AppDelegate.h
//  LYKit
//
//  Created by zhouluyao on 2022/8/29.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
/// 兼容iOS13之前的版本
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) id subscribeID;

- (void)subscribeMetricData;

- (void)unsubscribeMetricData;
@end

