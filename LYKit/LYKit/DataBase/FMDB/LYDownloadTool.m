//
//  LYDownloadTool.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/4.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYDownloadTool.h"
#import <FMDB/FMDB.h>


@interface LYDownloadTool ()

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@end

@implementation LYDownloadTool

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static LYDownloadTool *instance;
    dispatch_once(&once, ^{
        instance = [[LYDownloadTool alloc] init];
    });
    return instance;
}

- (FMDatabaseQueue *)dataBaseQueue {
    if (!_dataBaseQueue) {
        NSString *kCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"LYKit.sqlite"];
        _dataBaseQueue = [[FMDatabaseQueue alloc] initWithPath:kCachePath];
        [self createTable];
    }
    return _dataBaseQueue;
}

- (void)createTable {

    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"create table if not exists t_music (id integer primary key autoincrement,albumId text, downloadUrl text unique, albumTitle text, isDownLoaded text default '1')";
        [db executeUpdate:sql];
    }];
}

- (void)addDownloadMusicModel:(LYMusicModel *)musicModel {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {

        BOOL result = [db executeUpdate:@"insert into t_music (albumId , downloadUrl ,  albumTitle ) values (?, ?, ?)" withArgumentsInArray:@[@(musicModel.albumId), musicModel.downloadUrl ,musicModel.albumTitle]];
        if (result)
        {
            NSLog(@"保存歌曲记录成功");
        }else {
            NSLog(@"保存歌曲记录失败");
        }
        
    }];
}

- (void)fetchDownloadedMusicModel:(void(^)(NSArray <LYMusicModel *>*downloadedMusics))result
{
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql = @"select * from t_music where isDownLoaded = '1'";
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *musics = [NSMutableArray array];

        while ([rs next]) {
            LYMusicModel *musicModel = [[LYMusicModel alloc] init];
            [musics addObject:musicModel];

            NSArray *columnNames = @[@"albumId" , @"downloadUrl" , @"albumTitle" , @"isDownLoaded"];

            for (NSString *columnName in columnNames) {
                [musicModel setValue:[rs stringForColumn:columnName] forKey:columnName];
            }
        }
        result(musics);
    }];
}

- (void)updateMusicModelStatus:(BOOL)isDownLoaded withURL:(NSString *)url {

    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql = [NSString stringWithFormat:@"update t_music set isDownLoaded = '%zd' where downLoadUrl = '%@'", isDownLoaded, url];
        if ([db executeUpdate:sql]) {
            NSLog(@"执行成功");
        }else {
            NSLog(@"执行失败");
        }

    }];
}

- (void)deleteMusicModelWithURL:(NSString *)url {

    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql = [NSString stringWithFormat:@"delete from t_music where downLoadUrl = '%@'", url];
        if ([db executeUpdate:sql]) {
            NSLog(@"执行成功");
        }else {
            NSLog(@"执行失败");
        }
    }];
}

@end
