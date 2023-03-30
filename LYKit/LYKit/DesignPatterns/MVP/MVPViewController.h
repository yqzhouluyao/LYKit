//
//  LYMVPViewController.h
//  LYKit
//
//  Created by zhouluyao on 3/30/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewProtocol.h"
#import "UserPresenterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVPViewController : UIViewController <UserViewProtocol>

@property (nonatomic, strong) id<UserPresenterProtocol> presenter;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *fetchDataButton;

- (IBAction)fetchDataButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
