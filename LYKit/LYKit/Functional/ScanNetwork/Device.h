//
//  Device.h
//  LYKit
//
//  Created by zhouluyao on 4/22/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ip;

- (instancetype)initWithName:(NSString *)name ip:(NSString *)ip;

@end
