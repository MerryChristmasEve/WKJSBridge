![wkJSBridge.gif](https://upload-images.jianshu.io/upload_images/1483880-359d43dfb0a32e16.gif?imageMogr2/auto-orient/strip)
#前言
**WKWebView**是iOS8 出来的浏览器控件,用来取代**UIWebView**
现在2020年 苹果已经不建议使用**UIWebView**了，所以需要把原来用到的换成**WKWebView**
本篇文章主要作用是实现JS调用OC，并且OC可以给到回调
[WKJSBridge gitHub地址](https://github.com/MerryChristmasEve/WKJSBridge)
>**WKWebView**在iOS9才开始完善，所以建议将工程设置成最低支持iOS9
-----
#1.WKWebView调用JS方法
>**WKWebView**调用JS方法是通过直接执行JS代码来实现的

**iOS中WK的的方法 evaluateJavaScript 就是执行的js代码**
```
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
```

**这个在UIWebview中也有类似的方法，这里就不做过多的介绍**

----

#2.JS调用WKWebView方法
>JS调用**WKWebView**都是通过**WKScriptMessageHandler**协议来实现的

**OC Code**
```
WKUserContentController * userContent = [[WKUserContentController alloc]init];
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
configuration.userContentController = userContent;
WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[ZLJSBridge handlerJS] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
[userContent addUserScript:usrScript];
[userContent addScriptMessageHandler:self name:@"ZLJSBridge"];
 _wkWebView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
 _wkWebView.navigationDelegate = self;
 _wkWebView.UIDelegate = self;
```

**JS Code**
```
let messsage = 'name' : 'lllllin'
window.webkit.messageHandlers.ZLJSBridge.postMessage(message);
```
**iOS在WKScriptMessageHandler协议中的方法接受参数**
message.name为addScriptMessageHandler时传递的name
message.body为JS传递的参数
```
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"ZLJSBridge"])
    {
        NSLog(@"%@",message.body);
    }
}
```

#3. JS调用WKWebView方法并且WKWebView给JS回调
Demo在文章开始的时候已经附上
**ZLJSBridge.js中plugin为约定好OC的类名**
```
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
```
```
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
```
> \+ (void)getNativeInfo:(NSDictionary *)params callBackID:(NSString *)callBackID;

getNativeInfo为暴露给JS的方法名  后面拼的callBackID为demo中写好的固定参数，详见ZLJSBridge.m

**JS Code**
```
var params = {
    'name': 'hello world jack!!!'
};
//getNativeInfo为约定好的方法名 params为参数  res为给的回调内容 
//res格式为jsonString 如果需要用json对象的话需要用JSON.parse(res)转义一下
JSBridge.callAPI("getNativeInfo", params, res => {
    document.getElementById('div2').innerHTML = res;
});
```
>做阅读类APP的QQ群52181885 ![IMG_1517.JPG](https://upload-images.jianshu.io/upload_images/1483880-bf583a93b2410992.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)
QQ群227866345
![QQ群](https://upload-images.jianshu.io/upload_images/1483880-34c3a2433738483a.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/240)

