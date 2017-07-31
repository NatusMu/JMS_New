//
//  JMSHomeViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/11/24.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSHomeViewController.h"
#import "JMSScanViewController.h"
#import "JMSSearchViewController.h"
#import "JMSMessageViewController.h"
#import "JMSWebViewController.h"
#import "JMSCityViewController.h"
#import "JMSVoiceViewController.h"
//购物车
#import "JMSShopViewController.h"
#import "JMSLoginViewController.h"


//缓存
#import "PINURLCache.h"
//下拉刷新
#import <MJRefresh.h>
#import <WebKit/WebKit.h>

#import "JMSDataModel.h"
#import "JMSData.h"

#import <SVProgressHUD.h>
@interface JMSHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,UIActivityItemSource,UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webview;
@property (nonatomic,strong) UIView *SuperView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *NavView;//导航栏
@property (nonatomic) NSURLSession *session;
@property(nonatomic,strong)UIScrollView * ScrollView;//背景的滚动试图
@property (nonatomic,strong) UIButton *city;//左边城市选择
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *twoArray;
@property (nonatomic, strong) NSMutableArray *fiveArray;
/**
 *  猜你喜欢数据源
 */

@property (nonatomic,strong) NSTimer *timer;//模拟数据刷新需要的时间控制器
@property (nonatomic,assign) int time;
@property (nonatomic,strong,readwrite) UIBarButtonItem *returnButton;
@property (nonatomic,strong,readwrite) UIBarButtonItem *closeItem;


@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *recommendArray;
@end
int q = 1;
@implementation JMSHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Home 123");
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    self.automaticallyAdjustsScrollViewInsets = NO; //设置不自动填充,当有多个tableview时
    //添加返回左按钮
    [self addLeftButton];
    [self removeCookie];
//    [self getCookie];
    //[self CreatScrollView];
    if(q == 1){
        [self setWebView_UIWebView];
    }
    //初始化头部
    [self setNav];
    //添加动画
    [self initAddView];
    //手势
    //self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
   
    // Do any additional setup after loading the view.
}
- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.returnButton;
}
#pragma mark - 返回
- (UIBarButtonItem *)returnButton {
    if (!_returnButton) {
        _returnButton = [[UIBarButtonItem alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"sy_back.png"];
        [button setImage:image forState:UIControlStateNormal];//这是一张“<”的图片
        [button setTitle:@" 返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToReturnToBack:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        button.frame = CGRectMake(20, 0, 40, 40);
        _returnButton.customView = button;
        self.navigationItem.leftBarButtonItem = _returnButton;
    }
    return _returnButton;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToReturnToFind:)];
    }
    return _closeItem;
}

- (void)respondsToReturnToBack:(UIButton *)sender {
    if ([self.webview canGoBack]) {//判断当前的H5页面是否可以返回
        //如果可以返回，则返回到上一个H5页面，并在左上角添加一个关闭按钮
        [self.webview goBack];
        self.navigationItem.leftBarButtonItems = @[self.returnButton, self.closeItem];
    } else {
        //如果不可以返回，则直接:
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)respondsToReturnToFind:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --设置隐藏navigation导航栏
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.view.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.view.hidden=NO;
}
-(void)getCookie{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(NSHTTPCookie *cookie in [cookieJar cookies]){
        NSLog(@"cookie %@",cookie);
    }
}
-(void)removeCookie{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Cookie"];
    
}
-(void)setWebView_UIWebView{
    [self removeAdvImage];
    //1.创建view,并设置大小,“20”为状态栏高度
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT)];
    //隐藏滚动条
    [_webview.scrollView setShowsHorizontalScrollIndicator:NO];//水平
    [_webview.scrollView setShowsVerticalScrollIndicator:NO];  //竖直
    //防止抖动
    //[_webview.scrollView setBounces:NO];
    //根据屏幕大小自动调整界面尺寸
    _webview.contentScaleFactor = YES;
    //MJ_Refresh
//    _webview.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //进入刷新状态后会自动调用这个block
//    }];
    //设置刷新
    _webview.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _webview.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _webview.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)+50);
    // 导航代理
    _webview.delegate =self;
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    NSMutableString *cookieValue =[NSMutableString stringWithFormat:@""];
//    NSHTTPCookieStorage *cookieJar =[NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for(NSHTTPCookie *cookie in [cookieJar cookies]){
//        [cookieDic setObject:cookie.value forKey:cookie.name];
//    }
//    //cookie重复,先放到字典进行去重,再进行拼接
//    for(NSString *key in cookieDic){
//        NSString *appendString = [NSString stringWithFormat:@"%@=%@",key,[cookieDic valueForKey:key]];
//        [cookieValue appendString:appendString];
//    }
    //请求头中传入Cookie
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jiumeisheng.com?l=m"]];
    PINURLCache *URLCache = [[PINURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
    /**
     * @param URLCache -> 这里的 URLCache 即 [NSURLCache sharedURLCache] 获取的 URLCache
     */
    [PINURLCache setSharedURLCache:URLCache];
    // 3.加载数据
    [_webview loadRequest:request];
    // 4.添加网页视图
    [self.view addSubview:_webview];
    q++;
}
-(void)CreatScrollView{
    _ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _ScrollView.delegate=self;
    [self.view addSubview:_ScrollView];
}

#pragma mark - 加载网页
- (void)loadData{
    
    NSString *urlString =@"http://www.jiumeisheng.com?l=m";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
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
    [_webview.scrollView.mj_header endRefreshing];
    [_webview.scrollView.mj_footer endRefreshing];
}

#pragma mark --初始化头部
//重新初始化头部,考虑到navigationController定制度很高
-(void)setNav
{
    _NavView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    _NavView.backgroundColor = [UIColor whiteColor];
    _NavView.backgroundColor = [_NavView.backgroundColor colorWithAlphaComponent:0];
//    [self.view addSubview:_NavView];
//    左边按钮
//    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cityBtn.frame = CGRectMake(20, 23, 40, 35);
//    [cityBtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
//
//    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    
//    [cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
//    
//    cityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
//    
//    JMSData *item = [[JMSDataModel sharedStore] allItems][0];
//    if (item.city == nil)
//    {
//        [cityBtn setTitle:@"南充" forState:UIControlStateNormal];
//    }else
//    {
//        [cityBtn setTitle:item.city forState:UIControlStateNormal];
//    }
//    //leftbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
//    
//    cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [cityBtn addTarget:self action:@selector(city:) forControlEvents:UIControlEventTouchUpInside];
//    _city = cityBtn;
    //[_NavView addSubview:_city];
    
    //左边按钮
    _city= [UIButton buttonWithType:UIButtonTypeCustom];
    [_city setTitle:@"城市" forState:UIControlStateNormal];
    _city.frame = CGRectMake(20, 20, 40, 30);
    _city.titleLabel.font = [UIFont systemFontOfSize:13];
    _city.titleLabel.textColor = [UIColor blackColor];
    _city.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _city.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _city.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    // [_city setBackgroundImage:[UIImage imageNamed:@"icon_homepage_map"] forState:UIControlStateNormal];
    [_city addTarget:self action:@selector(city:)forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_city];
    
    
    //右边按钮
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"home-10-03"] forState:UIControlStateNormal];
    scanBtn.frame = CGRectMake(SCREEN_WIDTH-64, 20, 20, 23);
    [scanBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    scanBtn.tag = 401;
    
    //购物车
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopBtn setBackgroundImage:[UIImage imageNamed:@"home-10-04"] forState:UIControlStateNormal];
    shopBtn.frame = CGRectMake(SCREEN_WIDTH-34, 20, 24, 23);
    [shopBtn addTarget:self action:@selector(shopping:) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.tag = 402;
    
    [self.navigationController.view addSubview:scanBtn];
    [self.navigationController.view addSubview:shopBtn];
    
    //中间
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(70, 20,SCREEN_WIDTH-145, 28)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    view.layer.cornerRadius = 10;//设置那个圆角的有多圆
    view.layer.borderWidth = 0.2;//设置边框的宽度，当然可以不要
    view.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    view.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-145, 25)];
    searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    searchBar.placeholder = @"搜索商品";
    //searchBar.delegate = self;
    searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchBar.bounds.size];
    UIView *searchTextField = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        searchBar.barTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    } else
    { // iOS6以下版本searchBar内部子视图的结构不一样
        for (UIView *subView in searchBar.subviews)
        {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                searchTextField = subView;
            }
        }
    }
    searchTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    searchBar.showsScopeBar = NO;
    [view addSubview:searchBar];
    
    //语音按钮
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    voiceBtn.frame = CGRectMake(SCREEN_WIDTH-180, 0, 45, 25);
    [voiceBtn addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
    
    //键盘旁搜索按钮
    UIButton *sousuo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sousuo.backgroundColor colorWithAlphaComponent:0];
    sousuo.frame = CGRectMake(0, 0, SCREEN_WIDTH-145, 25);
    [sousuo addTarget:self action:@selector(sousuo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sousuo];
    [view addSubview:voiceBtn];
    [self.navigationController.view addSubview:view];
}
#pragma mark - 左边 城市 city
-(void)city:(UIButton *)button
{
    //NSLog(@"城市");
    JMSCityViewController *cityVC = [[JMSCityViewController alloc] init];
    //cityVC.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController: cityVC animated:YES completion:nil];
}

#pragma mark - 右边 扫一扫 scan
-(void)scan:(UIButton *)button
{
    NSLog(@"扫一扫");
    JMSScanViewController *sao = [[JMSScanViewController alloc]init];
    
    sao.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:sao animated:YES];//1.点击，相应跳转
}
#pragma mark --购物车 shopping
-(void)shopping:(UIButton *)button
{
    NSLog(@"购物车");
    JMSShopViewController *shopcartVC = [[JMSShopViewController alloc] init];
    [self.navigationController pushViewController:shopcartVC animated:YES];
//    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
//    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}
#pragma mark --语音 voice
-(void)voice:(UIButton *)button
{
    NSLog(@"语音");
    
    JMSVoiceViewController *voice = [[JMSVoiceViewController alloc]init];
    
    [self presentViewController:voice animated:YES completion:nil];//1.点击，相应跳转
}
#pragma mark --搜索按钮 sousuo
-(void)sousuo:(UIButton *)button
{
    NSLog(@"搜索");
    //[searchBar setShowsCancelButton:NO animated:YES];
    //self.tableView.allowsSelection=NO;
    //self.tableView.scrollEnabled=NO;
    
    JMSSearchViewController *search = [[JMSSearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];//1.点击，相应跳转
    
}
#pragma mark - 搜索事件   UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar//不使用
{
    //[searchBar setShowsCancelButton:NO animated:YES];
    //self.tableView.allowsSelection=NO;
    //self.tableView.scrollEnabled=NO;
    
    JMSSearchViewController *search = [[JMSSearchViewController alloc]init];
    
    search.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    //[self.navigationController pushViewController:search animated:YES];//1.点击，相应跳转
    [self presentViewController:search animated:NO completion:nil];
}

#pragma mark --加载动画
- (void)initAddView{
    _SuperView = [[UIView alloc]initWithFrame:CGRectMake(0, -0, SCREEN_WIDTH,SCREEN_HEIGHT+0)];
    _SuperView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *ChangeImages = [NSMutableArray array];
    for (NSUInteger i=1; i<=9; i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];;
        [ChangeImages addObject:image];
    }
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-70, 200, 120)];
    _imageView.animationImages = ChangeImages;
    [_SuperView addSubview:_imageView];
    [self.view addSubview:_SuperView];
    _SuperView.hidden = NO;
    //设置执行一次完整动画的时长
    _imageView.animationDuration = 9*0.15;
    //动画重复次数 (0为重复播放)
    _imageView.animationRepeatCount = 3;
    [_imageView startAnimating];
    
}

#pragma mark --移除动画
-(void)removeAdvImage
{
    [UIView animateWithDuration:0.3f animations:^{
        _SuperView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _SuperView.alpha = 0.f;
    } completion:^(BOOL finished) {
        //[_yourSuperView removeFromSuperview];//会直接移除，不能再次使用，故使用隐藏
        _SuperView.hidden = YES;
    }];
}

//取消searchbar背景色  生成纯色image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark --UITableViewDataSource

#pragma mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //在内存报警时 清空内存
    PINURLCache *URLCache = (PINURLCache *)[NSURLCache sharedURLCache];
    [URLCache removeAllCachedResponses];
    q=1;
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
