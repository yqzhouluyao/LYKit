//
//  LYKitBaseViewController.h
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYKitBaseViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *vcTitle;

- (void)setupItems;

@end

NS_ASSUME_NONNULL_END
