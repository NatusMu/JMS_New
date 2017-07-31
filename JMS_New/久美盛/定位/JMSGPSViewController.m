//
//  JMSGPSViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/6.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSGPSViewController.h"
//#import <CoreLocation/CLLocation.h>
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
@interface JMSGPSViewController ()

@end
//@interface JMSGPSViewController () <BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

//@property (strong,nonatomic) BMKLocationService* locService;
//@property (strong,nonatomic) BMKPoiSearch* poisearch;
//@property (strong,nonatomic) NSString* text1; //经度
//@property (strong,nonatomic) NSString* text2; //维度
//@property (strong,nonatomic) BMKGeoCodeSearch* geocodesearch;
//@property (strong,nonatomic) NSString *dateString; //时间
//@property (strong,nonatomic) NSString *User_ID; //用户ID


@implementation JMSGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self set];
    //1.设置代理
}
//#pragma mark -初始化
//-(void)set
//{
//    //初始化定位服务
//    _locService= [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];//启动定位服务
//    //初始化检索对象
//    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
//    _geocodesearch.delegate = self;
//    
////    BOOL flag = [_geocodesearch geoCode:geoCode];
////    if(flag)
////    {
////        NSLog(@"geo检索发送成功");
////    }
////    else
////    {
////        NSLog(@"geo检索发送失败");
////    }
//    //发起检索
//    //POI详情检索
//    _option = [[BMKPoiDetailSearchOption alloc] init];
//    _option.poiUid = @"此处为POI的uid";//POI搜索结果中获取的uid
//    //_option.poiUid = @"此处为POI的uid";//POI搜索结果中获取的uid
//    BOOL flag = [_poisearch poiDetailSearch:_option];
//    if(flag)
//    {
//        NSLog(@"详情检索发起成功");
//        
//    }
//    else
//    {
//        NSLog(@"详情检索发送失败");
//    }
//}
//#pragma mark --定位代理
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
////    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    _text1 = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
////    NSLog(@"%@",_text1);
//    _text2 = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
//}
//#pragma mark --POI检索代理
//-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
//{
//    if(errorCode == BMK_SEARCH_NO_ERROR){
//        //在此处理正常结果
//        _option.poiUid = poiDetailResult.uid;
//    }
//}
//#pragma mark - GPS检索
//-(void)GPS
//{
//    _User_ID=@"xiaoxz";
//    //    BOOL ret = [_mapManager start:@"lZUYrZf2N3GNNigmSN8KhcG64SieFlOT"  generalDelegate:nil];
//    //    if (!ret) {
//    //        NSLog(@"manager start failed!");
//    //    }
//    //NSString *URLStr = [NSString stringWithFormat:@"http://114.55.2.92/shouji/index.php/?m=Mobile&a=mobileAd"];
//    //在这里并没有设置缓存
//    //http://114.55.2.92/shouji/index.php/?m=Position&a=saveUserPosition&Longitude=&Latitude=&Address=&Pio=&Date=&User_Id=
//    //参数是Longitude、Latitude、Address、Pio、Date、User_Id
//    //1.url字符串 转 url
//    NSURL *url = [NSURL URLWithString:@"http://114.55.2.92/shouji/index.php/?m=Position&a=saveUserPosition"];
//    //2.构造Request  （请求url） 基础缓存策略
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//    //2.1.设置请求方式为 POST
//    [request setHTTPMethod:@"POST"];
//    //[request setTimeoutInterval:60]; 超时设置
//    //2.2设置请求头
//    //[request setAllHTTPHeaderFields:nil];
//    //2.3 声明请求参数的字符串 设置请求体
//    NSString *DataStr = [NSString stringWithFormat:@"&Loongitude=%@&Latitude=%@Address=%@Pio=%@Date=%@User_Id=%@",_text1,_text2,_option.poiUid,_dateString,_User_ID];
//    //将参数字符串 转成 utf-8的数据类型
//    NSData *data = [DataStr dataUsingEncoding:NSUTF8StringEncoding];
//    //将参数数据添加到 网络请求中
//    [request setHTTPBody:data];
//}
//////遵循代理写在viewwillappear中
////- (void)viewWillAppear:(BOOL)animated {
////    _locService.delegate = self;
////    _geocodesearch.delegate = self;
////    _poisearch.delegate = self;
////    
////}
//#pragma mark - 获取经纬度
//-(void)GetTitude
//{
//    //启动LocationService
//    NSLog(@"定位的经度:%f,定位的纬度:%f",_locService.userLocation.location.coordinate.longitude,_locService.userLocation.location.coordinate.latitude);
//    _text1 = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.longitude];
//    _text2 = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.latitude];
//}
//#pragma mark - 获取时间
//-(void)Time
//{
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
//    _dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",_dateString);
//}
//#pragma mark - 获取地点
//-(void)Place
//{
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
//    if (_locService.userLocation.location.coordinate.longitude!= 0
//        && _locService.userLocation.location.coordinate.latitude!= 0) {
//        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
//        pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude,
//            _locService.userLocation.location.coordinate.longitude};
//    }
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的店为pt
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//}
//
////实现相关delegate 处理位置信息更新
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//}
//#pragma mark - 经纬度代理 反馈
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    BMKCoordinateRegion region;
//    region.center.latitude  = userLocation.location.coordinate.latitude;
//    region.center.longitude = userLocation.location.coordinate.longitude;
//    region.span.latitudeDelta  = 0.0001;
//    region.span.longitudeDelta = 0.0001;
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [_locService stopUserLocationService];//停止获取用户的位置
//}
//#pragma mark - Poi检索
////实现PoiSearchDeleage处理回调结果
//-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
//{
//    if(errorCode == BMK_SEARCH_NO_ERROR){
//        //在此处理正常结果
//    }
//    
//}
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
