//
//  UserViewModel.h
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserViewModel : NSObject

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *userAge;

- (instancetype)initWithModel:(UserModel *)model;
- (void)fetchData;


@end

NS_ASSUME_NONNULL_END
