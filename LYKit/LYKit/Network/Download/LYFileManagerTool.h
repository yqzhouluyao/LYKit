//
//  LYFileManagerTool.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYFileManagerTool : NSObject

+ (long long int)getFileSizeWithPath: (NSString *)filePath;

+ (void)removeFileAtPath: (NSString *)filePath;

+ (float)calculateFileSizeInUnit:(unsigned long long)contentLength;

+ (NSString *)calculateUnit:(unsigned long long)contentLength;

@end

NS_ASSUME_NONNULL_END
