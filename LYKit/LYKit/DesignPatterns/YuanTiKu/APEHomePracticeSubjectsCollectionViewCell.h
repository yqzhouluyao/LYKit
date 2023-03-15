//
//  APEHomePracticeSubjectsCollectionViewCell.h
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APEHomePracticeSubjectsCollectionCellViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface APEHomePracticeSubjectsCollectionViewCell : UICollectionViewCell
- (void)bindDataWithViewModel:(APEHomePracticeSubjectsCollectionCellViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
