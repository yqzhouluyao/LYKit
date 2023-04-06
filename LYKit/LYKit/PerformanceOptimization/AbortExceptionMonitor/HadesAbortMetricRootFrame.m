//
//  HadesAbortMetricRootFrame.m
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "HadesAbortMetricRootFrame.h"
#import <objc/runtime.h>
static NSString * const TRACE_FMT = @"%-4d%-31s 0x%016lx 0x%lx + %lu\n";


@implementation HadesAbortMetricRootFrame

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        for (NSString *property in [[self class] wpf_propertyNames]) {
            id value = dictionary[property];
            [self setValue:value forKey:property];
        }
        if (_subFrames) {
            NSArray *array = _subFrames;
            NSMutableArray *subFrames = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                HadesAbortMetricRootFrame *frame = [[HadesAbortMetricRootFrame alloc] initWithDictionary:dic];
                [subFrames addObject:frame];
            }
            _subFrames = subFrames;
        }
    }
    return self;
}

- (NSString *)uploadFormatString
{
    NSMutableString *result = [NSMutableString string];
    [self uploadFormat:result fromFrame:self index:0];
    return result;
}

- (void)uploadFormat:(NSMutableString *)uploadFormat fromFrame:(HadesAbortMetricRootFrame *)frame index:(NSInteger)index
{
    int num;
    const char *image = frame.binaryName.UTF8String;
    uintptr_t address = frame.address.unsignedLongValue;
    uintptr_t loadAddress;
    uintptr_t offset;
    
    if (@available(iOS 16.0, *)) {
        num = (int)index;
        offset = frame.offsetIntoBinaryTextSegment.unsignedLongValue;
        loadAddress = address - offset;
    } else {
        num = (int)index;
        loadAddress = frame.offsetIntoBinaryTextSegment.unsignedLongValue;
        offset = address - loadAddress;
    }
    [uploadFormat appendFormat:TRACE_FMT, num, image, address, loadAddress, offset];
    
    for (HadesAbortMetricRootFrame *subFrame in frame.subFrames) {
        [self uploadFormat:uploadFormat fromFrame:subFrame index:index + 1];
    }
    
}


+ (NSArray<NSString *> *)wpf_propertyNames {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    NSMutableArray<NSString *> *propertyNames = [NSMutableArray arrayWithCapacity:propertyCount];
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyNameCStr = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:propertyNameCStr];
        [propertyNames addObject:propertyName];
    }
    
    free(properties);
    
    return propertyNames;
}
@end
