//
//  MVVMViewController.h
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewController : UIViewController

@property (nonatomic, strong) UserViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *fetchDataButton;

- (IBAction)fetchDataButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
