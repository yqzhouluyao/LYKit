//
//  CrashReportManager.h
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashReportManager : NSObject

+ (instancetype)sharedManager;

- (void)subscribeToCrashReports;
- (void)unsubscribeFromCrashReports;

@end

NS_ASSUME_NONNULL_END
