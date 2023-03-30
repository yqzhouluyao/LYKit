//
//  UserModel.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (User *)getUser {
    // Simulate fetching user data
    return [[User alloc] initWithName:@"John Doe" age:30];
}

@end
