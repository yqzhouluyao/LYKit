//
//  LYFMDBViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/4.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYFMDBViewController.h"
#import "LYDownloadTool.h"

@interface LYFMDBViewController ()

@end

@implementation LYFMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取已下载的列表
    [[LYDownloadTool shareInstance] fetchDownloadedMusicModel:^(NSArray<LYMusicModel *> * _Nonnull downloadedMusics) {
        NSLog(@"music - %@",downloadedMusics);
        
    }];
    
    //删除数据库的歌曲
//    [[LYDownloadTool shareInstance] deleteMusicModelWithURL:@"www.baidu.com/music/2.mp3"];
    
    //更新数据库的歌曲的状态
    [[LYDownloadTool shareInstance] updateMusicModelStatus:NO withURL:@"www.baidu.com/music/2.mp3"];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    LYMusicModel *model = [LYMusicModel new];
    model.albumId = 2;
    model.downloadUrl = @"www.baidu.com/music/2.mp3";
    model.albumTitle = @"这个世界会好吗";
    model.isDownLoaded = YES;

    [[LYDownloadTool shareInstance] addDownloadMusicModel:model];
}

-(void)dealloc {
    
}

@end
