//
//  ViewController.m
//  WKJSBridge
//
//  Created by 樊祯林 on 2020/5/13.
//  Copyright © 2020 樊祯林. All rights reserved.
//

#import "ViewController.h"
#import "ZLJSBridge.h"
#import "ZLJSCoreBridge.h"

@interface ViewController ()<UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic,strong) ZLJSBridge *ZL_JSBridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ZL_JSBridge = [[ZLJSBridge alloc] init];
    self.ZL_JSBridge.webView = self.wkWebView;
    [self.view addSubview:self.wkWebView];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 500, 100, 50);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"给回调1" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.masksToBounds = YES;
    btn.tag = 1;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *url = [NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)testMethod:(UIButton *)sender
{
    NSString *random = [NSString stringWithFormat:@"native回调%d",arc4random() % 100];
    NSString *random2 = [NSString stringWithFormat:@"native回调%d",arc4random() % 100];
    [ZLJSCoreBridge getNativeCallBack:@{random:random2} wkWwebView:self.wkWebView];
}


//MARK: - lazy loading
- (WKWebView *)wkWebView
{
    if (!_wkWebView)
    {
        WKUserContentController * userContent = [[WKUserContentController alloc]init];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContent;
        WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[ZLJSBridge handlerJS] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [userContent addUserScript:usrScript];
        [userContent addScriptMessageHandler:self.ZL_JSBridge  name:ZLJSBridgeName];
        _wkWebView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"100===%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:
                      UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          completionHandler();
                      }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}


@end
