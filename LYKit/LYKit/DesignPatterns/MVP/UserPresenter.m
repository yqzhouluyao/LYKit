//
//  UserPresenter.m
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "UserPresenter.h"

@implementation UserPresenter

- (instancetype)initWithView:(id<UserViewProtocol>)view model:(UserModel *)model {
    self = [super init];
    if (self) {
        _view = view;
        _model = model;
    }
    return self;
}

- (void)fetchData {
    User *user = [self.model getUser];
    [self.view displayUserData:user];
}


@end
