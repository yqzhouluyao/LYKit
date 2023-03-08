//
//  Target_QuestionKit.m
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "Target_QuestionKit.h"
#import "LYQuestionKitViewController.h"

@implementation Target_QuestionKit

- (UIViewController *)Action_Category_ViewController:(NSDictionary *)params
{
    typedef void (^CallbackType)(NSString *);
    CallbackType callback = params[@"callback"];
    if (callback) {
        callback(@"success");
    }
    LYQuestionKitViewController *viewController = [[LYQuestionKitViewController alloc] init];
    return viewController;
}

@end
