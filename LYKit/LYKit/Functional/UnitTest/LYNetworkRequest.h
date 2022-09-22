//
//  LYNetworkRequest.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LYNetworkRequest;
@protocol LYNetworkRequestDelegate <NSObject>
@optional
- (void)http:(LYNetworkRequest *)http receiveData:(nullable NSData *)data error:(nullable NSError *)error;
@end


@interface LYNetworkRequest : NSObject

@property (nonatomic, weak) id<LYNetworkRequestDelegate>  delegate;

- (void)fetchUrl;

@end

NS_ASSUME_NONNULL_END
