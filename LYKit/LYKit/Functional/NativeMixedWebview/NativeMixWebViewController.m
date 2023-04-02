//
//  NativeMixWebViewController.m
//  LYKit
//
//  Created by zhouluyao on 4/3/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "NativeMixWebViewController.h"


@interface NativeMixWebViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation NativeMixWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    // Initialize the WKWebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1) configuration:config];
    self.webView.navigationDelegate = self;
    [self.scrollView addSubview:self.webView];
    
    // Load your web content
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // Initialize the UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 132) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.tableView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error == nil && result != nil) {
            CGFloat webViewHeight = [result floatValue];
            CGRect webViewFrame = webView.frame;
            webViewFrame.size.height = webViewHeight;
            webView.frame = webViewFrame;
            
            CGRect tableViewFrame = self.tableView.frame;
            tableViewFrame.origin.y = CGRectGetMaxY(webViewFrame);
            self.tableView.frame = tableViewFrame;
            
            CGFloat scrollViewHeight = webViewHeight + tableViewFrame.size.height;
            self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, scrollViewHeight);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row + 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end
