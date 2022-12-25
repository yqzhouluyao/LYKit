//
//  ZGAppInfoUtil.m
//  ZGCacheManagerComponent
//
//  Created by zhouluyao on 9/18/20.
//  Copyright © 2020 zhouluyao. All rights reserved.
//

#import "ZGAppInfoUtil.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <UIKit/UIKit.h>
#include <sys/mount.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <netdb.h>
#include <dns.h>
#include <resolv.h>
#include <sys/socket.h>

#define IOS_CELLULAR @"pdp_ip0"
#define IOS_WIFI @"en0"
#define IP_ADDR_IPv4 @"ipv4"
#define IP_ADDR_IPv6 @"ipv6"

#define QUMA_APPID @"44"

@implementation ZGAppInfoUtil

+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)appID {
    return QUMA_APPID;
}

+ (BOOL)isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }

    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = nil;
        if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
            keyWindow = [[UIApplication sharedApplication].delegate window];
        } else {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }

        if (keyWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }

    return iPhoneXSeries;
}

+ (BOOL)isIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (double)systemVersion {
   return [[UIDevice currentDevice].systemVersion doubleValue];
}

+(NSString *)getAPPAndSystemVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    double systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    return [NSString stringWithFormat:@"APPVersion:%@  iOSVersion:%.1f APPID:%@",app_Version,systemVersion,QUMA_APPID];
    
}

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)scaleFromSize:(CGFloat)length {
  BOOL isPortrait =  UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    return isPortrait ?(length*[self screenWidth]/750):(length*[self screenHeight]/750);
}

+ (CGFloat)hotSpotStatusBarHeight {
    return 20;
}

+ (BOOL)isHotSpotConnected {
    CGFloat appStatusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    return appStatusBarHeight == ([self safeAreaTopHeight] + [self hotSpotStatusBarHeight]);
}

+ (CGFloat)navigationBarHeight {
    return [self isIPhoneXSeries] ? 88 : 64;
}

+ (CGFloat)tabBarHeight {
    return [self isIPhoneXSeries] ? 83 : 49;
}

+ (CGFloat)safeAreaTopHeight {
    return [self isIPhoneXSeries] ? 44 : 20;
}

+ (CGFloat)safeAreaBottomHeight {
    return [self isIPhoneXSeries] ? 34 : 0;
}

+ (CGFloat)dockWidth {
    return 80;
}

+ (NSString *)appVersionInfo {
    return [NSString stringWithFormat:@"APPVersion:%@  iOSVersion:%.1f APPID:%@",[self appVersion],[self systemVersion],[self bundleIdentifier]];
}
//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ? @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] : @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];

    NSDictionary *addresses = [[self class] getIPAddresses];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
      address = addresses[key];
      if (address)
          *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)getIPFromHostName:(NSString *)hostName {
    const char *host = [hostName UTF8String];
    // Get host entry info for given host
    struct hostent *remoteHostEnt = gethostbyname(host);
    if (!remoteHostEnt) {
        return nil;
    }
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    
    return [NSString stringWithFormat:@"%s",sRemoteInAddr];
}

#pragma mark -- 获取磁盘剩余空间
+ (NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"%.2f" ,(CGFloat)freespace/1000/1000/1000];
}


#pragma mark -- 获取整个磁盘空间
+(NSString *)getTotalDiskSpaceInBytes {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] cString], &tStats);
    float totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
    return [NSString stringWithFormat:@"%.2f",totalSpace/1000/1000/1000];
}

+ (BOOL)checkPhotoLibraryAuthorizationStatus:(void(^)(UIAlertController *))alertBlock
{
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatus)]) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (PHAuthorizationStatusDenied == authStatus ||
            PHAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开中公开学的访问权限" alertBlock:alertBlock];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus:(void(^)(UIAlertController *))alertBlock
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持拍照" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开中公开学的访问权限" alertBlock:alertBlock];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)chcekMicoAuthorizationStatus:(void(^)(UIAlertController *))alertBlock {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->麦克风”中打开中公开学的访问权限" alertBlock:alertBlock];
            return NO;
        }
    }
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr alertBlock:(void(^)(UIAlertController *))alertBlock;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([app canOpenURL:settingsURL]) {
            [app openURL:settingsURL];
        }
    }]];
//    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad){
//        alert.popoverPresentationController.sourceView = self.topViewController.view;
//        alert.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
//    }
    if (alertBlock) {
        alertBlock(alert);
    }
}

@end

