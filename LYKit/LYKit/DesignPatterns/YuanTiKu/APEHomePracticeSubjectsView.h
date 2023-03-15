//
//  APEHomePracticeSubjectsView.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APEHomePracticeSubjectsViewModel;
@class APEHomePracticeSubjectsView;

NS_ASSUME_NONNULL_BEGIN

@protocol APEHomePracticeSubjectsViewDelegate <NSObject>
- (void)homePracticeSubjectsView:(nonnull APEHomePracticeSubjectsView *)subjectView
             didPressItemAtIndex:(NSInteger)index;
@end

@interface APEHomePracticeSubjectsView : UIView

@property (nonatomic, strong, nullable) APEHomePracticeSubjectsViewModel *viewModel;
@property (nonatomic, weak, nullable) id<APEHomePracticeSubjectsViewDelegate> delegate;
- (void)bindDataWithViewModel:(nonnull APEHomePracticeSubjectsViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
