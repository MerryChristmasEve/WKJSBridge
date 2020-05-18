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

+ (void)getNativeInfo:(NSDictionary *)params :(NSString *)callBackID;
@property (nonatomic, copy) NSString *getNativeInfoCBid;
+ (void)getNativeCallBack:(id)response wkWwebView:(WKWebView *)wkWebview;


+ (void)test:(NSDictionary *)params :(NSString *)callBackID;
@property (nonatomic, copy) NSString *testCBID;
+ (void)testCallBack:(id)rsp wkwebView:(WKWebView *)wkWebView;








+ (ZLJSCoreBridge *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
