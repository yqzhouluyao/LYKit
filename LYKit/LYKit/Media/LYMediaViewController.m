//
//  LYMediaViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/1.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYMediaViewController.h"
#import "LYAudioViewController.h"
#import "LYVideoViewController.h"
#import "LYOpenGLViewController.h"

@interface LYMediaViewController ()

@end

@implementation LYMediaViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"MediaCell";
        self.vcTitle = @"音视频及图像";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //猿题库架构设计 https://www.cnblogs.com/yulang314/p/5091342.html
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"视频" viewController:[[LYVideoViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"OpenGL" viewController:[[LYOpenGLViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"音频" viewController:[[LYAudioViewController alloc] init]]];
}

- (LYKitCellItem *)itemWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    
    void(^block)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController pushViewController:viewController animated:YES];
            }
        });
    };
    LYKitCellItem *item = [LYKitCellItem itemWithTitle:title block:block];
    return item;
}



@end
