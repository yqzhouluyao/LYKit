//
//  Device.m
//  LYKit
//
//  Created by zhouluyao on 4/22/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "Device.h"

@implementation Device

- (instancetype)initWithName:(NSString *)name ip:(NSString *)ip {
    self = [super init];
    if (self) {
        _name = name;
        _ip = ip;
    }
    return self;
}

@end
