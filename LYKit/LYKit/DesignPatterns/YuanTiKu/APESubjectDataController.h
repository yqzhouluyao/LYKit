//
//  APESubjectDataController.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "APEBaseDataController.h"
@class APESubject;
typedef void(^APEDataCallback)(NSError * _Nullable error,id _Nullable data);

NS_ASSUME_NONNULL_BEGIN

@interface APESubjectDataController : APEBaseDataController
@property (nonatomic, strong, nonnull, readonly) NSArray<APESubject *> *openSubjectsWithCurrentPhase;
// 2
- (void)requestAllSubjectsWithCallback:(nonnull APEDataCallback)callback;
// 3
- (void)requestUserSubjectsWithCallback:(nonnull APEDataCallback)callback;
@end

NS_ASSUME_NONNULL_END
