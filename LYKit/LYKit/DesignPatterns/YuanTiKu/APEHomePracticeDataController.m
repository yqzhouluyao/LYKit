//
//  APEHomePracticeDataController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "APEHomePracticeDataController.h"
#import "APESubjectDataController.h"

@interface APEHomePracticeDataController ()
@property (nonatomic, strong, nonnull) APESubjectDataController *subjectDataController;

@end

@implementation APEHomePracticeDataController

- (void)requestSubjectDataWithCallback:(nonnull APECompletionCallback)callback {
    APEDataCallback dataCallback = ^(NSError *error, id data) {
        callback(error);
    };
    [self.subjectDataController requestAllSubjectsWithCallback:dataCallback];
    [self.subjectDataController requestUserSubjectsWithCallback:dataCallback];
}

- (nonnull NSArray<APESubject *> *)openSubjects {
    return self.subjectDataController.openSubjectsWithCurrentPhase ?: @[];
}

@end
