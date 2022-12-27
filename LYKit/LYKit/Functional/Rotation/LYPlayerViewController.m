//
//  LYPlayerViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/26.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYPlayerViewController.h"

@interface LYPlayerViewController (){
    BOOL isLandscape;
}

@end

@implementation LYPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isLandscape = NO;
    
    //监听self.view.Frame的变化
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        NSLog(@"change - %@",change);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    isLandscape = !isLandscape;
    [self changeOrientationToLandScape:isLandscape];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
//    NSLog(@"size - %@",NSStringFromCGSize(size));
}

- (void)changeOrientationToLandScape:(BOOL)isLandscape {
    
    
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] init];
        geometryPreferences.interfaceOrientations = isLandscape ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
        [ws requestGeometryUpdateWithPreferences:geometryPreferences
            errorHandler:^(NSError * _Nonnull error) {
            //业务代码
        }];
    } else {
        //设置屏幕的转向为横屏
        [[UIApplication sharedApplication] setStatusBarOrientation: isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        //设置横屏
         NSNumber *orientationTarget = [NSNumber numberWithInt:isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
         [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;

    if (isLandscape) {
        self.view.frame = CGRectMake(x, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } else {
        self.view.frame = CGRectMake(x, y, w, h);
    }
}
@end
