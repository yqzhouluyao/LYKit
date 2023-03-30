//
//  UserViewModel.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "UserViewModel.h"

@interface UserViewModel ()

@property (nonatomic, strong) UserModel *model;

@end

@implementation UserViewModel

- (instancetype)initWithModel:(UserModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)fetchData {
    User *user = [self.model getUser];
    _userName = user.name;
    _userAge = [NSString stringWithFormat:@"%ld", (long)user.age];
}

@end
