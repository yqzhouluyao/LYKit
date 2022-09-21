//
//  APEHomePracticeSubjectsCollectionCellViewModel.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class APESubject;
NS_ASSUME_NONNULL_BEGIN

@interface APEHomePracticeSubjectsCollectionCellViewModel : NSObject

@property (nonatomic, strong, nonnull) UIImage *image;
@property (nonatomic, strong, nonnull) UIImage *highlightedImage;
@property (nonatomic, strong, nonnull) NSString *title;
@property (nonatomic, strong, nonnull) UIColor *titleColor;
@property (nonatomic, strong, nonnull) UIColor *backgroundColor;
+ (nonnull APEHomePracticeSubjectsCollectionCellViewModel *)viewModelWithSubject:(nonnull
APESubject *)subject;
+ (nonnull APEHomePracticeSubjectsCollectionCellViewModel *)viewModelForMore;

@end

NS_ASSUME_NONNULL_END
