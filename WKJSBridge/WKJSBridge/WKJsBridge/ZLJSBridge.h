//
//  ZLJSBridge.h
//  WKJSBridge
//
//  Created by 樊祯林 on 2020/5/13.
//  Copyright © 2020 樊祯林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <webkit/webkit.h>

static NSString * _Nullable const ZLJSBridgeName = @"JSBridge";

NS_ASSUME_NONNULL_BEGIN

@interface ZLJSBridge : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;

+ (NSString *)handlerJS;

/**
 清空handler的数据信息， 注入的脚本。绑定事件信息等等
 */
+ (void)cleanHandler:(ZLJSBridge *)handler;

/**
 执行js脚本

 @param js js脚本
 @param completed 回调
 */
- (void)evaluateJavaScript:(NSString *)js
                 completed:(void(^)(id data, NSError *error))completed;

/// 执行js脚本，同步返回
/// @param js js脚本
/// @param error 错误
- (id)synEvaluateJavaScript:(NSString *)js
                      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
