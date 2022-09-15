//
//  APEHomePracticeDataController.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//



#import "APEBaseDataController.h"
typedef void(^APECompletionCallback)(NSError * _Nullable );
@class APESubject;

NS_ASSUME_NONNULL_BEGIN

@interface APEHomePracticeDataController : APEBaseDataController
// 1
@property (nonatomic, strong, nonnull, readonly) NSArray<APESubject *> *openSubjects; //openSubjects这个 property会存储用户打开的科目列表
// 2
- (void)requestSubjectDataWithCallback:(nonnull APECompletionCallback)callback;
@end

NS_ASSUME_NONNULL_END
