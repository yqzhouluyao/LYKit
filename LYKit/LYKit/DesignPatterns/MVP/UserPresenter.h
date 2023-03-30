//
//  UserPresenter.h
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewProtocol.h"
#import "UserModel.h"
#import "UserPresenterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserPresenter : NSObject <UserPresenterProtocol>

@property (nonatomic, weak) id<UserViewProtocol> view;
@property (nonatomic, strong) UserModel *model;

- (instancetype)initWithView:(id<UserViewProtocol>)view model:(UserModel *)model;


@end

NS_ASSUME_NONNULL_END
