//
//  JMSPlaceViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/29.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSPlaceViewController.h"
#import "PINURLCache.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>
@interface JMSPlaceViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end
@implementation JMSPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地域特色馆";
    self.navigationItem.accessibilityElementsHidden = YES;
    //设置不自动填充
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebView];
    // Do any additional setup after loading the view.
}
//#pragma mark --设置隐藏navigation导航栏
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden =YES;
//}
#pragma mark --初始化web
-(void)setWebView{
    //1.创建View,并设置大小
    //1.创建view,并设置大小，"20"为状态栏高度
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT-20)];
    //隐藏滚动条
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO]; //水平
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];   //竖直
    //防止抖动
    //[_webView.scrollView setBounces:NO];
    // 根据屏幕大小自动调整页面尺寸
    _webView.contentScaleFactor = YES;
//    // 导航代理
//    _webView.navigationDelegate = self;
    // 与webview UI交互代理
    _webView.delegate = self;
    //设置刷新
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _webView.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //开启手势触摸
    _webView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)+50);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.42.237.131/index.php?m=news&a=dyg&l=m"]
                                         ];
    //添加缓存
    PINURLCache *URLCache = [[PINURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
    /**
     * @param URLCache -> 这里的 URLCache 即 [NSURLCache sharedURLCache] 获取的 URLCache
     */
    [PINURLCache setSharedURLCache:URLCache];
    // 3.加载数据
    [_webView loadRequest:request];
    // 4.添加网页视图
    [self.view addSubview:_webView];
}
#pragma mark - 加载网页
- (void)loadData{
    
    NSString *urlString =@"http://121.42.237.131/index.php?m=news&a=dyg&l=m";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationTyp{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self endRefresh];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self endRefresh];
}

#pragma mark - 结束下拉刷新和上拉加载
- (void)endRefresh{
    //
    //    //当请求数据成功或失败后，如果你导入的MJRefresh库不是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    //    [self.webView.scrollView.header endRefreshing];
    //    [self.webView.scrollView.footer endRefreshing];
    //
    //当请求数据成功或失败后，如果你导入的MJRefresh库是最新的库，就用下面的方法结束下拉刷新和上拉加载事件
    [_webView.scrollView.mj_header endRefreshing];
    [_webView.scrollView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //在内存报警时 清空内存
    PINURLCache *URLCache = (PINURLCache *)[NSURLCache sharedURLCache];
    [URLCache removeAllCachedResponses];
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
