//
//  APEHomePracticeSubjectsView.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "APEHomePracticeSubjectsView.h"
#import "APEHomePracticeSubjectsViewModel.h"
#import "APEHomePracticeSubjectsCollectionViewCell.h"


@interface APEHomePracticeSubjectsView ()

@property (nonatomic, strong, nullable) UICollectionView *collectionView;

@end

@implementation APEHomePracticeSubjectsView

- (void)bindDataWithViewModel:(nonnull APEHomePracticeSubjectsViewModel *)viewModel {
    self.viewModel = viewModel;
    self.backgroundColor = viewModel.backgroundColor;
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:
(NSIndexPath *)indexPath {
    APEHomePracticeSubjectsCollectionViewCell *cell = [collectionView
dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (0 <= indexPath.row && indexPath.row < self.viewModel.cellViewModels.count) {
        APEHomePracticeSubjectsCollectionCellViewModel *vm =
self.viewModel.cellViewModels[indexPath.row];
        [cell bindDataWithViewModel:vm];
}
    return cell;
}

@end
