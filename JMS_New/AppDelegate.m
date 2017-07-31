//
//  AppDelegate.m
//  JMS_New
//
//  Created by 黄沐 on 2016/11/23.
//  Copyright © 2016年 Hm. All rights reserved.
//
#import "AppDelegate.h"
#import "NetworkController.h"

#import "JMSHomeViewController.h"
#import "JMSPersonViewController.h"
#import "JMSMeViewController.h"
#import "JMSOtherViewController.h"
#import "JMSPlaceViewController.h"
#import "JMSShopViewController.h"

/*
    第三方SDK
*/

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//微信 微博SDK
#import <UserNotifications/UserNotifications.h>
//#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate,UITabBarControllerDelegate>
{
//    BMKMapManager* _mapManager;
    UITabBarController *rootTabbarCtr;
}
////iOS10以前的UIUserNotificationAction相关属性
//// 行为标识符，用于调用代理方法时识别是哪种行为。
//@property (nonatomic, copy, readonly) NSString *identifier;
//// 行为名称。
//@property (nonatomic, copy, readonly) NSString *title;
//// 即行为是否打开APP。
//@property (nonatomic, assign, readonly) UIUserNotificationActivationMode activationMode;
//// 是否需要解锁。
//@property (nonatomic, assign, readonly, getter=isAuthenticationRequired) BOOL authenticationRequired;
//// 这个决定按钮显示颜色，YES的话按钮会是红色。
//@property (nonatomic, assign, readonly, getter=isDestructive) BOOL destructive;

//iOS10的UNNotificationAction相关属性
// The unique identifier for this action.
@property (NS_NONATOMIC_IOSONLY, copy, readonly) NSString *identifier;

// The title to display for this action.
@property (NS_NONATOMIC_IOSONLY, copy, readonly) NSString *title;

// The options configured for this action.
@property (NS_NONATOMIC_IOSONLY, readonly) UNNotificationActionOptions options;
@end
#define USHARE_DEMO_APPKEY @"583513dff29d984dbb0008c2" //友盟Key
#define Baidu_APPKEY @"lZUYrZf2N3GNNigmSN8KhcG64SieFlOT"//百度Key
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
//    [ShareSDK registerActivePlatforms:@[
//                                        @(SSDKPlatformTypeSinaWeibo),
//                                        @(SSDKPlatformTypeWechat),
//                                       ]
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//    onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"wxf654b8c8113e4231"
//                                    appSecret:@"2ee41ecfdd0a527fbfe2dc606acd5dc9"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wxf654b8c8113e4231"
//                                    appSecret:@"26d35099ada2e821f601ed471d4605c5"];
//                 break;
//           
//            default:
//                   break;
//                   }
//    }];
    
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window =window;
    
    [self initTabbarItem];
//    //百度地图
//    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:Baidu_APPKEY generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
//    NSLog(@"%@",_mapManager);
    
    //友盟推送
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
//    [UMessage startWithAppkey:UMeng_APPKEY launchOptions:launchOptions];
//    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
//    [UMessage registerForRemoteNotifications];
//    //iOS10必须加下面这段代码。
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate=self;
//    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//            //点击允许
//            //这里可以添加一些自己的逻辑
//        } else {
//            //点击不允许
//            //这里可以添加一些自己的逻辑
//        }
//    }];
//    //打开日志，方便调试
//    [UMessage setLogEnabled:YES];
    
//    NetworkController *vc = [[NetworkController alloc]init];
//    _window.rootViewController = vc;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    //设置缓存 满足缓存需求
    NSURLCache *urlCache = [[NSURLCache alloc]initWithMemoryCapacity:4*1024*1024
                                                        diskCapacity:20*1024*1024
                                                            diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    return YES;
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa3d7950295b1e821" appSecret:@"26d35099ada2e821f601ed471d4605c5" redirectURL:@"http://www.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1182829687"  appSecret:@"2ee41ecfdd0a527fbfe2dc606acd5dc9" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
-(void)initTabbarItem
{
    rootTabbarCtr = [[UITabBarController alloc] init];
    rootTabbarCtr.delegate = self;
    
    JMSHomeViewController *home = [[JMSHomeViewController alloc]init];
    [self controller:home title:@"首页" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    JMSOtherViewController *jing = [[JMSOtherViewController alloc]init];
    [self controller:jing title:@"分类" image:@"分类" selectedimage:@"分类-选中"];
    
    JMSPlaceViewController *place = [[JMSPlaceViewController alloc]init];
    [self controller:place title:@"地域特色馆" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    JMSShopViewController *yuan = [[JMSShopViewController alloc]init];
    [self controller:yuan title:@"购物车" image:@"购物车" selectedimage:@"购物车-选中"];
    
    JMSPersonViewController *my = [[JMSPersonViewController alloc]init];
    [self controller:my title:@"个人中心" image:@"icon_tab_wode_normal" selectedimage:@"icon_tab_wode_highlight"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];//颜色
    [rootTabbarCtr setSelectedIndex:0];
    self.window.rootViewController = rootTabbarCtr;
}
//初始化一个自控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage
{
    TS.tabBarItem.title = title;
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    [rootTabbarCtr addChildViewController:nav];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    /*
     long index = tabBarController.selectedIndex;
     
     switch (index)
     {
     case 0:
     
     break;
     case 1:
     NSLog(@"af");
     break;
     case 2:
     NSLog(@"af");
     break;
     default:
     break;
     }*/
    AudioServicesPlaySystemSound(1306);//系统声音 1000~2000
    
}
//禁止多次点击
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;
    if([tbselect isEqual:viewController]){
        return NO;
    }
    return YES;
}


//#pragma mark - 加载图片广告
//-(void)initAdvView
//{
//    //这个逻辑处理，会导致，开启时间过长，最好改成开启后读取缓存的广告
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
//    //NSLog(@"filePath:  %@",filePath);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = FALSE;
//    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
//    
//    if (isExit)
//    {
//        NSLog(@"存在");
//        _advImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        [_advImage setImage:[UIImage imageWithContentsOfFile:filePath]];
//        [self.window addSubview:_advImage];
//        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
//        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //加载启动广告并保存到本地沙盒，因为保存的图片较大，每次运行都要保存，所以注掉了
//            //[self getLoadingImage];
//        });
//    }else
//    {
//        NSLog(@"不存在");
//        /*
//         NSMutableArray *refreshingImages = [NSMutableArray array];
//         for (NSUInteger i = 1; i<=9; i++)
//         {
//         UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
//         [refreshingImages addObject:image];
//         }
//         _advImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-70, 200, 120)];
//         _advImage.animationImages = refreshingImages;
//         [self.window addSubview:_advImage];
//         
//         //设置执行一次完整动画的时长
//         _advImage.animationDuration = 9*0.15;
//         //动画重复次数 （0为重复播放）
//         _advImage.animationRepeatCount = 1.5;
//         [_advImage startAnimating];
//         
//         [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:2];
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//         [self getLoadingImage];
//         });*/
//    }
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JMS_New"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
