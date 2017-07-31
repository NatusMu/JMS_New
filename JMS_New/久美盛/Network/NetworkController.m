//
//  NetworkController.m
//  JSM
//
//  Created by 黄沐 on 2016/10/13.
//  Copyright © 2016年 Jiumeisheng. All rights reserved.
//

#import "NetworkController.h"
#import "JMSGuideViewController.h"
#import "JMSViewController.h"
#import "JMSWebViewController.h"
//判断当前网络状态
#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
@interface NetworkController ()<NSURLSessionDataDelegate>
{
    NSDictionary *dic;
    NSArray *arr;
    NSDictionary *arrdic;
    UIScreen *currentScreen;
    //NSMutableData *responseData;
}
/** 设置一个NSMutableData类型的对象, 用于接收返回的数据. */
@property (nonatomic, retain) NSMutableData *responseData;

@end

@implementation NetworkController
- (void)viewDidLoad {
    [super viewDidLoad];
    if([NetworkController NetworkJudge])
    {
        [self delegate];
    }
    
}
-(void)delegate{
    /** 1. 创建NSURLSessionConfiguration类的对象, 这个对象被用于创建NSURLSession类的对象. */
    //        NSURLSessionConfiguration *configura = [NSURLSessionConfiguration defaultSessionConfiguration];
    //1.url字符串 转 url
    NSURL *url = [NSURL URLWithString:@"http://114.55.2.92/shouji/index.php/?m=Mobile&a=mobileAd"];
    //2.构造Request  （请求url） 基础缓存策略
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSString *DataStr = [NSString stringWithFormat:@"type=移动端广告位	"];
    //将参数字符串 转成 utf-8的数据类型
    NSData *data = [DataStr dataUsingEncoding:NSUTF8StringEncoding];
    //将参数数据添加到 网络请求中
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    //3.获得会话对象,并设置代理
    /*
     第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     第二个参数：谁成为代理，此处为控制器本身即self
     第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     */
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *datatask = [session dataTaskWithRequest:request];
    //5.执行任务
    [datatask resume];
}
+(BOOL)NetworkJudge{
    NSLog(@"网络测试");
    // 创建零地址，0.0.0.0地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    // Get connect flags
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    // 如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        NSLog(@"网络连接失败");
        return NO;
    }
    // 根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
-(NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}
-(void)newtimeMethods
{
    //测试设置为1
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用JMSGuideViewController (用户引导页面) 作为根视图
        JMSGuideViewController *userGuideViewController = [[JMSGuideViewController alloc] init];
        [self presentViewController:userGuideViewController animated:NO completion:nil];
    }
    else
    {
        NSLog(@"不是第一次启动");
        //如果不是第一次启动的话,使用JMSViewController作为根视图
        JMSWebViewController* vc = [[JMSWebViewController alloc]init];
        [self presentViewController:vc animated:NO completion:nil];
        
//        JMSViewController *jjView = [[JMSViewController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:jjView];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - NSURLSession DataDelegate
//当接收到服务器响应的时候调用这个方法
//参数1:委托
//参数2:当前任务
//参数3:接收到得响应
//参数4:响应完成的block,必须在当前这个方法中调用，
//否则服务器不会返回数据;
////1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //在该方法中可以得到响应头信息，即response
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     NSURLSessionResponseBecomeStream        变成一个流
     */
    
    completionHandler(NSURLSessionResponseAllow);
}
//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //拼接服务器返回的数据
    [self.responseData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        dic = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:nil];
        int x = arc4random() %3;//取0到2 整数
        arr = [dic objectForKey:@"data"];
//        NSLog(@"%@",arr);
        arrdic = arr[x];
        NSString *str = [NSString stringWithFormat:@"http://114.55.2.92/%@",[arrdic objectForKey:@"S_Image"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
        currentScreen = [UIScreen mainScreen];
        //NSLog(@"applicationFrame.size.height = %f",currentScreen.applicationFrame.size.height);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentScreen.applicationFrame.size.width, currentScreen.applicationFrame.size.height+20)];
        imgView.image = image;
        [self.view addSubview:imgView];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(newtimeMethods) userInfo:nil repeats:NO];
    }else{
        //不可用
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接有误，请重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

