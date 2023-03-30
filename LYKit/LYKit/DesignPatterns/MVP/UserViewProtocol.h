//
//  UserViewProtocol.h
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@protocol UserViewProtocol <NSObject>

- (void)displayUserData:(User *)user;

@end

NS_ASSUME_NONNULL_END
