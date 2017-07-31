//
//  JMSWebViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/7.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface JMSWebViewController ()<WKNavigationDelegate,WKUIDelegate>
//WKWebView 替换 UIWebView WKUIDelegate处理JS脚本,确认框,警告框
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIActivityIndicatorView *activity;
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@end

@implementation JMSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark --加载网页
-(void)initWebView
{
    //1.创建view,并设置大小，"20"为状态栏高度
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,40,Width,Height-40)];
    //隐藏滚动条 失败
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    //防止抖动
    [_webView.scrollView setBounces:NO];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    NSLog(@"web调用网络测试");
    //指定进度轮的大小
    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,30,30)];
    //指定进度轮中心点
    [_activity setCenter:CGPointMake(160,140)];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:_activity];
    
    // NSURL *url = [NSURL URLWithString:@"http://www.jiumeisheng.com?l=m"];
    //2.创建请求
    NSLog(@"12313");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jiumeisheng.com?l=m"]];
    //3.加载网页
    NSLog(@"1231231");
    [_webView loadRequest:request];
    //4.将WebView加载到界面上
    [self.view addSubview:_webView];
}
#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    // 如果响应的地址是目标地址，则允许跳转
//    if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"http://www.jiumeisheng.com?l=m"]) {
    
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    // 如果请求的是目标地址，则延迟5s以后跳转
//    if ([navigationAction.request.URL.host.lowercaseString isEqual:@"http://www.jiumeisheng.com?l=mm"]) {
//        
//        //        // 延迟5s之后跳转
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //
//        //            // 允许跳转
//        //            decisionHandler(WKNavigationActionPolicyAllow);
//        //        });
//        
//        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
}
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
