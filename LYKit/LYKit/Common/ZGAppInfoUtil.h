//
//  ZGAppInfoUtil.h
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/18/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGAppInfoUtil : NSObject

+ (NSString *)bundleIdentifier;

///趣码APPID 44
+ (NSString *)appID;

+ (BOOL)isIPhoneXSeries;

+ (BOOL)isIpad;

+ (NSString *)appVersion;

+ (double)systemVersion;

+ (NSString *)getAPPAndSystemVersion;

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;


/// 相对于屏幕宽为750像素的尺寸缩放
/// @param length 传入的宽或高
+ (CGFloat)scaleFromSize:(CGFloat)length;

+ (CGFloat)hotSpotStatusBarHeight;

+ (BOOL)isHotSpotConnected;

+ (CGFloat)navigationBarHeight;

+ (CGFloat)tabBarHeight;

+ (CGFloat)safeAreaTopHeight;

+ (CGFloat)safeAreaBottomHeight;

+ (CGFloat)dockWidth;

+ (NSString *)appVersionInfo;

//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)getIPFromHostName:(NSString *)hostName;

/**
 *获取剩余空间大小
 */
+ (NSString *)freeDiskSpaceInBytes;

/*
 *获取磁盘全部大小
 */
+ (NSString *)getTotalDiskSpaceInBytes;

+ (BOOL)checkPhotoLibraryAuthorizationStatus:(void(^)(UIAlertController *))alertBlock;

+ (BOOL)checkCameraAuthorizationStatus:(void(^)(UIAlertController *))alertBlock;

+ (BOOL)chcekMicoAuthorizationStatus:(void(^)(UIAlertController *))alertBlock;

@end

NS_ASSUME_NONNULL_END
