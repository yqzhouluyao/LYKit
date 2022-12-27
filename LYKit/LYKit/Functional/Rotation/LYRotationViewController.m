//
//  LYChangeOrientationViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/25.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYRotationViewController.h"
#import "LYPlayerViewController.h"

@interface LYRotationViewController (){
    BOOL isLandscape;
}
@property(nonatomic,strong) LYPlayerViewController *playerVC;
@end

@implementation LYRotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS16旋转屏幕";
    self.view.backgroundColor = [UIColor blueColor];
    isLandscape = NO;
    
    // 转屏通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeRotate) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [self setupUI];
}

- (void)setupUI {
    _playerVC = [[LYPlayerViewController alloc] init];
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.playerVC.view.frame = CGRectMake(x, y, w, h);
    self.playerVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:self.playerVC];
    [self.view addSubview:self.playerVC.view];
}

-(void)didChangeRotate
{
    //据我实验在iOS 16中转屏的时候，直接获取设备方向： UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;  将返回UIDeviceOrientationUnknown，是不是神坑！！！！！
    BOOL isLandscape = NO;
    if (@available(iOS 16.0, *)) {
        
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        
        if(ws.interfaceOrientation == UIInterfaceOrientationPortrait || ws.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            isLandscape = NO;
        } else {
            isLandscape = YES;
        }
    } else {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait
            || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown){
            isLandscape = NO;
        } else {
            isLandscape = YES;
        }
    }
    
    NSLog(@"%@",isLandscape?@"横屏":@"竖屏");
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
        [self prefersStatusBarHidden];
        //设置横屏
         NSNumber *orientationTarget = [NSNumber numberWithInt:isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
         [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    
    NSLog(@"self.view - %@",self.view);
}


@end
