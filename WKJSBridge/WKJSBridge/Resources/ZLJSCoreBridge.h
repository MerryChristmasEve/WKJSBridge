//
//  ZLJSCoreBridge.h
//  WKJSBridge
//
//  Created by 樊祯林 on 2020/5/14.
//  Copyright © 2020 樊祯林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLJSCoreBridge : NSObject

/// JS调用的方法
/// @param params JS传递的参数
/// @param callBackID JS传递的callBackID
+ (void)getNativeInfo:(NSDictionary *)params callBackID:(NSString *)callBackID;

/// 给回调的callBackID
@property (nonatomic, copy) NSString *getNativeInfoCBid;

/// 对应getNativeInfo的回调方法
/// @param response 回调参数
/// @param wkWebview 执行回调的wkWebView
+ (void)getNativeCallBack:(id)response wkWwebView:(WKWebView *)wkWebview;


+ (ZLJSCoreBridge *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
