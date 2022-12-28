//
//  LYWebUploadViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/9.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYWebUploadViewController.h"
#import <GCDWebServer/GCDWebUploader.h>

@interface LYWebUploadViewController ()<GCDWebUploaderDelegate>
@property (nonatomic, strong) GCDWebUploader *webUploader;
@property (nonatomic, strong) NSMutableArray *uploadFiles;
@end

@implementation LYWebUploadViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kMusicCellIdentifier"];

    self.title = @"文件上传";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从电脑上传" style:0 target:self action:@selector(rigthItemClick)];
}

//从电脑上传点击调用
- (void)rigthItemClick {
    
    //设置服务器路径
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
   documentsPath = [documentsPath stringByAppendingPathComponent:@"Musics"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //开始服务器
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    _webUploader.delegate = self;
    if ([_webUploader start]) {
        NSLog(@"服务器启动");
    } else {
        NSLog(@"启动失败");
    }

    //获取IP
    NSString *ip = [_webUploader.serverURL absoluteString];
    NSInteger index = ip.length - 1;
    ip = [ip substringToIndex:index];

    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"在电脑浏览器输入以下网址" message:[NSString stringWithFormat:@"%@\n保持手机与电脑连接同一WIFI,上传过程中请勿关闭此弹框",ip] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.webUploader stop];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.uploadFiles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMusicCellIdentifier" forIndexPath:indexPath];
    NSString *path = self.uploadFiles[indexPath.row];
    cell.textLabel.text = path.lastPathComponent;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"已上传文件";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = self.uploadFiles[indexPath.row];
    if (self.didChooseMusic) {
        self.didChooseMusic(fileName);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    [self.tableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    [self.tableView reloadData];
}

#pragma mark -getter
- (NSMutableArray *)uploadFiles {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *fromPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fromPath = [fromPath stringByAppendingPathComponent:@"Musics"];
    NSArray *subpaths =  [[NSFileManager defaultManager] subpathsAtPath:fromPath];
    
    for (NSString *file in subpaths) {
        [tempArray addObject:[fromPath stringByAppendingPathComponent:file]];
    }
    _uploadFiles = tempArray;
    
    return _uploadFiles;
}

@end
