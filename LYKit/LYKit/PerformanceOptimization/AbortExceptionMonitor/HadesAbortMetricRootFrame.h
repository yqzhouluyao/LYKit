//
//  HadesAbortMetricRootFrame.h
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HadesAbortMetricRootFrame : NSObject

@property (nonatomic, copy) NSString *binaryName;
@property (nonatomic, copy) NSString *binaryUUID;
@property (nonatomic, strong) NSNumber *offsetIntoBinaryTextSegment;
@property (nonatomic, strong) NSNumber *address;
@property (nonatomic, strong) NSArray<HadesAbortMetricRootFrame *> *subFrames;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)uploadFormatString;

@end

NS_ASSUME_NONNULL_END
