//
//  ZLJSCoreBridge.m
//  WKJSBridge
//
//  Created by 樊祯林 on 2020/5/14.
//  Copyright © 2020 樊祯林. All rights reserved.
//

#import "ZLJSCoreBridge.h"


@implementation ZLJSCoreBridge


+ (void)getNativeInfo:(NSDictionary *)params callBackID:(nonnull NSString *)callBackID
{
    [ZLJSCoreBridge sharedInstance].getNativeInfoCBid = callBackID;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"js传递过来的参数"message:[NSString stringWithFormat:@"%@",params] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[[UIApplication sharedApplication] windows].firstObject.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    NSLog(@"getNativeInfo %@  callBackID:%@",params,callBackID);
}
+ (void)getNativeCallBack:(id)response wkWwebView:(WKWebView *)wkWebview
{
    [self callBackWithCallBackID:[ZLJSCoreBridge sharedInstance].getNativeInfoCBid callParams:response webView:wkWebview];
}











+ (ZLJSCoreBridge *)sharedInstance
{
    static ZLJSCoreBridge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ZLJSCoreBridge alloc] init];
        }
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (void)callBackWithCallBackID:(NSString *)callBackID callParams:(id)response webView:(WKWebView *)_webView
{
    WKWebView *weakWebView = _webView;
    if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSMutableDictionary class]] || [response isKindOfClass:[NSArray class]] || [response isKindOfClass:[NSMutableArray class]]) {
        NSData *data=[NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        response = jsonStr;
    }
    NSString *js = [NSString stringWithFormat:@"JSBridge.callBack('%@','%@');",callBackID,response];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakWebView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            
        }];
    });
}

@end
