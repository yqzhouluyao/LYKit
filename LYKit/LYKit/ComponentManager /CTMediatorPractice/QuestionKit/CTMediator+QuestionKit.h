//
//  CTMediator+QuestionKit.h
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (QuestionKit)

- (UIViewController *)questionKitViewControllerWithCallback:(void(^)(NSString *result))callback;

@end

NS_ASSUME_NONNULL_END
