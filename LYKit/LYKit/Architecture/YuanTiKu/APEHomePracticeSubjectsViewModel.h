//
//  APEHomePracticeSubjectsViewModel.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APEHomePracticeSubjectsCollectionCellViewModel.h"
//我们只把会因为业务变化而变化的部分设为 ViewModel 的一部分
@class APEHomePracticeSubjectsViewModel;
@class APESubject;
NS_ASSUME_NONNULL_BEGIN

@interface APEHomePracticeSubjectsViewModel : NSObject

@property (nonatomic, strong, nonnull) NSArray<APEHomePracticeSubjectsCollectionCellViewModel *>
*cellViewModels;
@property (nonatomic, strong, nonnull) UIColor *backgroundColor;

+ (APEHomePracticeSubjectsViewModel *)viewModelWithSubjects:(nonnull NSArray<APESubject *> *)openSubjects;

@end

NS_ASSUME_NONNULL_END
