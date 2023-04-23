//
//  LYCoreDataViewController.h
//  LYKit
//
//  Created by zhouluyao on 4/18/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYCoreDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

- (IBAction)addEmployeeButtonPressed:(UIButton *)sender;
- (IBAction)queryButtonPressed:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
