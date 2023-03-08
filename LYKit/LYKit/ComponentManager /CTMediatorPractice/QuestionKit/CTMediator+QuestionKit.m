//
//  CTMediator+QuestionKit.m
//  LYKit
//
//  Created by zhouluyao on 3/8/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "CTMediator+QuestionKit.h"

@implementation CTMediator (QuestionKit)

- (UIViewController *)questionKitViewControllerWithCallback:(void(^)(NSString *result))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callback"] = callback;
    return [self performTarget:@"QuestionKit" action:@"Category_ViewController" params:params shouldCacheTarget:NO];
}

@end
