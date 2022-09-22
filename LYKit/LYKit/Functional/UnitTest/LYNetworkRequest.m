//
//  LYNetworkRequest.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYNetworkRequest.h"

@implementation LYNetworkRequest

- (void)fetchUrl {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self.delegate respondsToSelector:@selector(http:receiveData:error:)]) {
            [self.delegate http:self receiveData:data error:error];
        }
    }];
    [task resume];
}

@end
