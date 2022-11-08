//
//  LYFileManagerTool.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYFileManagerTool.h"

@implementation LYFileManagerTool


+ (long long int)getFileSizeWithPath: (NSString *)filePath {

    // 检测文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return 0;
    }

    NSError *error = nil;
    NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error == nil) {
        return [fileDic[NSFileSize] longLongValue];
    }

    return 0;

}

+ (void)removeFileAtPath: (NSString *)filePath {

    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

}

+ (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
        return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
        return (float) (contentLength / (float)1024);
    else
        return (float) (contentLength);
}
+ (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return @"GB";
    else if(contentLength >= pow(1024, 2))
        return @"MB";
    else if(contentLength >= 1024)
        return @"KB";
    else
        return @"Bytes";
}

@end
