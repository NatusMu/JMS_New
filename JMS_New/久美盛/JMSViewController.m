//
//  JMSViewController.m
//  JSM
//
//  Created by 黄沐 on 2016/10/10.
//  Copyright © 2016年 Jiumeisheng. All rights reserved.
//

#import "JMSViewController.h"
#import "JMSMessageViewController.h"
#import "JMSScanViewController.h"
#import "JMSGPSViewController.h"
//#import "JMSGPSViewController.h"
@interface JMSViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIButton *scanBtn;
@property(nonatomic,strong)UIButton *messageBtn;
@end

@implementation JMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self GetGPS];
    //设置标题
    [self setTitle];
    //1.初始化网页视图
    [self setWebView];
    //2.配置加载请求
    //注意:网络资源地址 必须以"http://"开头 这里https就需要加证书了
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jiumeisheng.com?l=m"]];
    // 3.加载数据
    [_webView loadRequest:request];
    // 4.添加网页视图
    [self.view addSubview:_webView];
    
    //5.初始化控件
    [self setControl];
}
//- (void)GetGPS
//{
//    JMSGPSViewController* vc =[[JMSGPSViewController alloc]init];
//    //1.设置代理
//    [vc setGPS];
//    //1.获取经纬度
//    [vc GetTitude];
//    //2.获取地点
//    [vc Place];
//    //3.获取时间
//    [vc Time];
//    //4.向服务器传输GPS信息
//    [vc GPS];
//}
//设置标题
- (void)setTitle
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"久美盛特产商城-只卖地道食品";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //显示工具栏
    self.navigationController.toolbarHidden = YES;
}
//1.初始化网页视图
- (void)setWebView
{
    _webView = [[UIWebView alloc] init];
    _webView.bounds = CGRectMake(0, 0,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    _webView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)+50);
}
//5.初始化控件
- (void)setControl
{
    //导航栏按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    button.frame = CGRectMake(0, 0, 50, 50);//button的frame
    button.backgroundColor = [UIColor clearColor];//button的背景颜色
    [button setImage:[UIImage imageNamed:@"scan.png"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,12,20,8);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];//设置button的title
    button.titleLabel.font = [UIFont systemFontOfSize:11];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    button.titleEdgeInsets = UIEdgeInsetsMake(25, -button.titleLabel.bounds.size.width-60, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    
    [button addTarget:self action:@selector(respondsToScanBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    
    
    UIButton  *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 50, 50);
    [button1 setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 20, 8);
    [button1 setTitle:@"消息" forState:UIControlStateNormal];
    button1.titleEdgeInsets = UIEdgeInsetsMake(25, -button1.titleLabel.bounds.size.width-60, 0, 0);
    button1.titleLabel.font = [UIFont fontWithName:@"Times" size:11];
    button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button1 addTarget:self action:@selector(respondsToMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *messageBtn = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = messageBtn;
}

#pragma mark - responds event
- (void)respondsToSegmentedControl:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
            // 返回
        case 0:[_webView goBack];break;
            // 加载
        case 1:[_webView reload];break;
            // 停止加载
        case 2:[_webView stopLoading];break;
            // 前进
        case 3:[_webView goForward];break;
        default:
            break;
    }
}
#pragma mark -Methods
-(void)respondsToScanBtn
{
    if([self isCameraAvailable])
    {
        NSLog(@"responds");
        JMSScanViewController *scanVc = [[JMSScanViewController alloc]init];
        [self.navigationController pushViewController:scanVc animated:YES];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)respondsToMessageBtn
{
    JMSMessageViewController *messageVc = [[JMSMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVc animated:YES];
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

