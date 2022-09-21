//
//  LYWebViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/21.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYWebViewController.h"
#import <WebKit/WebKit.h>

@interface LYWebViewController ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *  webView;

@end

@implementation LYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationItem];
    [self.view addSubview:self.webView];
}

- (void)setupNavigationItem{
    
    UIBarButtonItem * reloadHtmlItem = [[UIBarButtonItem alloc] initWithTitle:@"重新加载" style:UIBarButtonItemStyleDone target:self action:@selector(reloadLocalHtml)];

    //OC调用JS的代码
    UIBarButtonItem * changeColorItem = [[UIBarButtonItem alloc] initWithTitle:@"改背景(OC调JS)" style:UIBarButtonItemStyleDone target:self action:@selector(changeColor)];
    self.navigationItem.rightBarButtonItems = @[reloadHtmlItem,changeColorItem];
    
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - WKScriptMessageHandler ，JS调用OC
//JS调用OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary * parameter = message.body;
    //JS调用OC
    if([message.name isEqualToString:@"JSInvokeOC"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js调用到了oc" message:parameter[@"params"] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - WKNavigationDelegate，拦截html中的链接
//拦截html中的链接
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"juejin://";
    if([urlStr hasPrefix:htmlHeadString]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拦截链接" message:@"是否打开我的博客首页?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"juejin://url?" withString:@""]];
            [[UIApplication sharedApplication] openURL:url];
            
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate ，处理JS代码中调用alert()

/**
 *  JS代码中调用alert()函数时，会调用该方法
 *   *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JS中调用了alert()函数" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Event
- (void)reloadLocalHtml {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NativeInvokeJS.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark -OC调用JS代码更改webView的背景颜色
- (void)changeColor {
    //changeColor()是NativeInvokeJS.html文件中定义的函数
    NSString *jsString = [NSString stringWithFormat:@"changeColor()"];
    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变webView的背景色");
    }];
}

#pragma mark - Getter
- (WKWebView *)webView{
    if(_webView == nil){
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.javaScriptEnabled = YES;

        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为JSInvokeOC的js方法
        [wkUController addScriptMessageHandler:self  name:@"JSInvokeOC"];
        
        config.userContentController = wkUController;
        
        //适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NativeInvokeJS.html" ofType:nil];
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        
    }
    return _webView;
}
@end
