//
//  AppDelegate.m
//  LYKit
//
//  Created by zhouluyao on 2022/8/29.
//

#import "AppDelegate.h"
#import "LYKitHomeViewController.h"
#import "CrashReportManager.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 13.0, *))
    {
        // 在SceneDelegate里创建UIWindow
    }
    else
    {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        LYKitHomeViewController *homeVC = [[LYKitHomeViewController alloc]init];
        [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:homeVC]];
        [self.window makeKeyAndVisible];
    }
    //订阅异常终止数据
    [[CrashReportManager sharedManager] subscribeToCrashReports];

    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[CrashReportManager sharedManager] unsubscribeFromCrashReports];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}



@end
