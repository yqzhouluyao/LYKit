//
//  LYChangeOrientationViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/25.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYChangeOrientationViewController.h"

@interface LYChangeOrientationViewController (){
    BOOL isLandscape;
}

@end

@implementation LYChangeOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isLandscape = NO;
    
    // Do any additional setup after loading the view.
    [self addObserver:self.view forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath - %@,change - %@",keyPath,change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    isLandscape = !isLandscape;
    [self changeOrientationToLandScape:isLandscape];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSLog(@"size - %@",NSStringFromCGSize(size));
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
    
    NSLog(@"self.view - %@",self.view);
}


@end
