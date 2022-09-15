//
//  APESubject.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APEUserSubjectStatus)
{
    APEUserSubjectStatusOn = 0,
    APEUserSubjectStatusOff = 1,
};


NS_ASSUME_NONNULL_BEGIN

//APESubject 是科目的资源结构，包含了 Subject 的 id 和 name 等资源属性，这部分属性是用户无关的
@interface APESubject : NSObject
@property (nonatomic, strong, nullable) NSNumber *id;
@property (nonatomic, strong, nullable) NSString *name;
@end

//APEUserSubject 是用户的科目信息，包含了用户是否打开某个学科的属性
@interface APEUserSubject : NSObject
@property (nonatomic, strong, nullable) NSNumber *id;
@property (nonatomic, strong, nullable) NSNumber *updatedTime;
///  On or Off
@property (nonatomic) APEUserSubjectStatus status;
@end

NS_ASSUME_NONNULL_END
