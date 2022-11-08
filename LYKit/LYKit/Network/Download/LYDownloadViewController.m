//
//  LYDownloadViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/8.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYDownloadViewController.h"
#import "LYDownloadManager.h"


@interface LYDownloadViewController ()

@end

@implementation LYDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"http://audiodl.pcdn.xmcdn.com/group70/M08/F9/92/wKgO2F4iTNHRKsa2ABfXYkCc4lk758.aac"];
    
    //开始下载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[LYDownloadManager shareInstance] downLoadWithURL:url progressBlock:^(float progress) {
            NSLog(@"progress--%f", progress);
        } successBlock:^(NSString * _Nonnull fileFullPath) {
            //更改数据库状态，为下载完成
            //发送下载完成通知，刷新下载列表、正在下载列表的控制器
        } failBlock:^{
            
        }];
    });
    //取消下载
//    [[LYDownloadManager shareInstance] cancelDownLoadWithURL:url];
//    //暂停下载
//    [[LYDownloadManager shareInstance] pauseDownLoadWithURL:url];
    
}


@end
