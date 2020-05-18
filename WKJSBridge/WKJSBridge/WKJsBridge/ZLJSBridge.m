//
//  ZLJSBridge.m
//  WKJSBridge
//
//  Created by 樊祯林 on 2020/5/13.
//  Copyright © 2020 樊祯林. All rights reserved.
//

#import "ZLJSBridge.h"

@interface ZLJSBridge ()

@end

@implementation ZLJSBridge


+ (void)cleanHandler:(ZLJSBridge *)handler{
    if (handler.webView) {
        [handler.webView evaluateJavaScript:@"JSBridge.removeAllCallBacks();" completionHandler:nil];//删除所有的回调事件
        [handler.webView.configuration.userContentController removeScriptMessageHandlerForName:ZLJSBridgeName];
    }
    handler = nil;
    
}
+ (NSString *)handlerJS{

    NSString *path =[[NSBundle bundleForClass:[self class]] pathForResource:@"ZLJSBridge" ofType:@"js"];
    NSString *handlerJS = [NSString stringWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    handlerJS = [handlerJS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return handlerJS;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:ZLJSBridgeName])
    {
        NSString *plugin = [message.body valueForKey:@"plugin"];
        NSString *funcName = [message.body valueForKey:@"func"];
        NSDictionary *params = [message.body valueForKey:@"params"];
        NSString *callBackID = [message.body valueForKey:@"callBackID"];
        [self interactWithPlugin:plugin funcName:funcName params:params callBackID:callBackID];
    }
}

- (void)interactWithPlugin:(NSString *)plugin
                  funcName:(NSString *)funcName
                    params:(NSDictionary *)params
                callBackID:(NSString *)callBackID
{
    funcName = [NSString stringWithFormat:@"%@:callBackID:",funcName];
    SEL selector =NSSelectorFromString(funcName);
    Class realHandler = NSClassFromString(plugin);
    if ([realHandler respondsToSelector:selector])
    {
        IMP imp = [realHandler methodForSelector:selector];
        void (*func)(id, SEL, id, id) = (void *)imp;
        func(realHandler, selector, params, callBackID);
    }
}

- (void)evaluateJavaScript:(NSString *)js
                 completed:(void(^)(id data, NSError *error))completed{
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (completed) {
            completed(data,error);
        }
    }];
}

- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error
{
    __block id result = nil;
    __block BOOL success = NO;
    __block NSError *resultError = nil;
    [self.webView evaluateJavaScript:js completionHandler:^(id tmpResult, NSError * _Nullable tmpError) {
        if (!tmpError)
        {
            result = tmpResult;
            success = YES;
        }
        else
        {
            resultError = tmpError;
        }
        success = YES;
    }];
    
    while (!success)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (error != NULL)
    {
        *error = resultError;
    }
    return result;
}

@end
