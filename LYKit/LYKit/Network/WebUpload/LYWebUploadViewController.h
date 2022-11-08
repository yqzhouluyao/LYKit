//
//  LYWebUploadViewController.h
//  LYKit
//
//  Created by zhouluyao on 2022/11/9.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYWebUploadViewController : UITableViewController
@property (nonatomic, copy) void(^didChooseMusic)(NSString *filePath);
@end

NS_ASSUME_NONNULL_END
