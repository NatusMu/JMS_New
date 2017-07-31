//
//  JMSLoginViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/12.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSLoginViewController.h"
#import "JMSInPutTextField.h"
#import "JMSSingUpViewController.h"
#import "JMSForgetPasswordViewController.h"
#import "ZYKeyboardUtil.h"
#import "Util.h"
#import "UINavigationBar+Awesome.h"
#import "UIView+XPKit.h"
#import "UILabel+LabelStyle.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import <Masonry.h>
//MD5
#import <CommonCrypto/CommonCrypto.h>
//友盟分享
#import <UMSocialCore/UMSocialCore.h>
#define PASSWORD_LIMITATION_LONG      20
#define PASSWORD_LIMITATION_SHORT     6
//#define MOBILE_LIMITATION             11


typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeWeibo,
    LoginTypeWechat,
    LoginTypeQQ
};
@interface JMSLoginViewController ()<NSURLSessionDataDelegate,UITextFieldDelegate,NSURLSessionDelegate>

@property (weak,nonatomic) IBOutlet UIView *viewInit;
@property (weak,nonatomic) IBOutlet UIView *view0;
@property (weak,nonatomic) IBOutlet UIView *view1;
/** 设置一个NSMutableData类型的对象, 用于接收返回的数据. */
@property (nonatomic, retain) NSMutableData *responseData;
/**---------------------三方登陆的账号息---------------------------------*/

@property (nonatomic,copy) NSString *unionID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconurl;
@property(nonatomic,assign) NSNumber *gender;

/**--------------------------------------------------------*/

@property (nonatomic,strong) NSString *jms;

@property (nonatomic,strong) NSURLSession * session;

@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic,strong) UINavigationController *navController;

//手机号码
@property (nonatomic, strong)JMSInPutTextField * phoneTextField;
//密码
@property (nonatomic, strong)JMSInPutTextField * passwordTextField;

//登陆按钮
@property (nonatomic, strong) UIButton *logInBtn;

//注册按钮
@property (nonatomic, strong) UIButton *signUpBtn;

//忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBtn;

//QQ登陆按钮
@property (nonatomic, strong) UIButton *QQBtn;

//微信登陆按钮
@property (nonatomic, strong) UIButton *WXBtn;

//微博登陆按钮
@property (nonatomic, strong) UIButton *WBBtn;


@end

@implementation JMSLoginViewController


//设置导航条内容
//- (void)setupNavigationBar {
//    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:NORMAL_COLOR];
//    //required
//    //    [MXNavigationBarManager saveWithController:self];
//    //    [MXNavigationBarManager managerWithController:self];
//    //    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//    //    [MXNavigationBarManager setTintColor:NORMAL_COLOR];
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航条内容
    [self setupNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [MXNavigationBarManager reStore];
}

//设置导航条内容
- (void)setupNavigationBar {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    //required
    //    [MXNavigationBarManager saveWithController:self];
    //    [MXNavigationBarManager managerWithController:self];
    //    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    //    [MXNavigationBarManager setTintColor:NORMAL_COLOR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    //关闭键盘
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    [self setupViews];
    // Do any additional setup after loading the view.
}
- (void)pop{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)setupViews{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    //底层backVie
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView = backView;
    //    backView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_backView];
    
    //用户登陆Label
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] text:@"用户登录" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 69 * KHEIGHT_IPHONE6_SCALE, SCREEN_WIDTH, 33);
    [_backView addSubview:titleLabel];
    
    //手机号码
    self.phoneTextField = [JMSInPutTextField inputTextFieldWithFrame:CGRectMake(14, 139, SCREEN_WIDTH - 14, 33) WithPlaceholder:@"手机号码" delegate:self];
    self.phoneTextField.textField.text=@"18030637599";
    _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [_backView addSubview:_phoneTextField];
    
    //密码
    self.passwordTextField = [JMSInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"密码" delegate:self];
    self.passwordTextField.textField.text=@"123456";
    self.passwordTextField.eyeBtn.hidden = NO;
    self.passwordTextField.textField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.textField.secureTextEntry = YES;
    [_backView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(_phoneTextField.mas_bottom).with.offset(14);
        make.height.equalTo(@33);
    }];

    //登陆按钮
    self.logInBtn = [[UIButton alloc]init];
    [_backView addSubview:_logInBtn];
    [_logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_logInBtn setBackgroundColor:NORMAL_COLOR];
    [_logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logInBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_logInBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:0];
    _logInBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(30);
        make.height.equalTo(@42);
    }];
    
    //注册按钮
    self.signUpBtn = [[UIButton alloc]init];
    [_backView addSubview:_signUpBtn];
    [_signUpBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_signUpBtn setBackgroundColor:[UIColor whiteColor]];
    [_signUpBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [_signUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [_signUpBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:1];
    _signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(_logInBtn.mas_bottom).with.offset(12);
        make.height.equalTo(@42);
    }];
    
    //忘记密码按钮
    _forgetBtn = [[UIButton alloc]init];
    [_backView addSubview:_forgetBtn];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_forgetBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signUpBtn);
        make.top.equalTo(_signUpBtn.mas_bottom).with.offset(12);
        make.height.equalTo(@20);
    }];
    
    //QQ按钮
    _QQBtn = [[UIButton alloc]init];
    [_QQBtn setBackgroundImage:[UIImage imageNamed:@"Oval_QQ"] forState:UIControlStateNormal];
    [_QQBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [_QQBtn addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_QQBtn];
    
    //微信按钮
    _WXBtn = [[UIButton alloc]init];
    [_WXBtn setBackgroundImage:[UIImage imageNamed:@"Oval_WX"] forState:UIControlStateNormal];
    [_WXBtn setImage:[UIImage imageNamed:@"WX"] forState:UIControlStateNormal];
    [_WXBtn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_WXBtn];
    
    //微博按钮
    _WBBtn = [[UIButton alloc]init];
    [_WBBtn setBackgroundImage:[UIImage imageNamed:@"Oval_WB"] forState:UIControlStateNormal];
    [_WBBtn setImage:[UIImage imageNamed:@"WB"] forState:UIControlStateNormal];
    [_WBBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_WBBtn];
    
    CGFloat space = (SCREEN_WIDTH - (50 * 2))/3;
    [self.WXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
        //        make.right.equalTo(self.WXBtn.mas_left).with.offset(50);
        make.left.equalTo(self.view).with.offset(space);
    }];
    [self.WBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
            make.right.equalTo(self.view).with.offset(-space);
            //make.centerX.equalTo(self.view.mas_centerX);//添加的
    }];
    //    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.equalTo(@50);
    //        make.height.equalTo(@50);
    //        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
    //        //        make.right.equalTo(self.WXBtn.mas_left).with.offset(50);
    //        make.right.equalTo(self.view).with.offset(-space);
    //    }];
    
    
    //快速登陆label
    UILabel* quickLabel = [[UILabel alloc]init];
    [_backView addSubview:quickLabel];
    [quickLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"快速登录" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentCenter];
    [quickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_WBBtn.mas_top).with.offset(-(30 * KHEIGHT_IPHONE6_SCALE));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@17);
    }];
    
    //左端线条
    UIView * leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = RGBA(238, 238, 238, 1);
    [_backView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12);
        make.right.equalTo(quickLabel.mas_left).with.offset(-12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];
    
    //右端线条
    UIView * rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = RGBA(238, 238, 238, 1);
    [_backView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12);
        make.left.equalTo(quickLabel.mas_right).with.offset(12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];
    
}

//QQ登录
- (void)QQLogin {
    [self loginWithType:LoginTypeQQ];
}

//微信登录
- (void)wechatLogin {
    [self loginWithType:LoginTypeWechat];
}

//微博登录
- (void)weiboLogin {
    [self loginWithType:LoginTypeWeibo];
}
- (void)loginWithType:(LoginType)type {
    if (type == LoginTypeQQ) {
    }
    else if (type == LoginTypeWechat) {
        [self getAuthWithUserInfoFromWechat];
        
    } else if (type == LoginTypeWeibo) {
    }
}
// 在需要进行获取用户信息的UIViewController中加入如下代码
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            self.unionID = resp.unionId;
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            self.name = resp.name;
            self.iconurl = resp.iconurl;
            self.gender = resp.unionGender;
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
    
}

// 第三方登录
- (void)thirtyPartyLoginWithType:(LoginType)type {
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
        return;
    }
    
    //[MBProgressHUD showHUD:nil];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:_phoneTextField.textField.text forKey:@"mobile"];
//    [params setObject:_passwordTextField.textField.text forKey:@"password"];
//    //[request setValue: forHTTPHeaderField:<#(nonnull NSString *)#>]
//    //    [request setHTTPBody:<#(NSData * _Nullable)#>];
//    _jms = [self md5:@"jms_application"];
//    NSLog(_jms);
//    NSURL *url = [NSURL URLWithString:@"http://www.jiumeisheng.com/shouji/index.php/?m=Member&a=login"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //设置Header参数
//    //[request setValue:_jms forHTTPHeaderField:@"token"];
//    
//    //此处发现如果Method是GET，body中放入参数提交，服务端会收不到。
//    
//    //设置Body值方法一，这种方法比较简单，为常用方法，不过只能上送参数
//    [request setHTTPMethod:@"POST"];
//    //NSString *bodyStr = @"";
//    NSString *bodyString = [NSString stringWithFormat:@"&username=%@&password=%@&token=%@", username, password,_jms];
//    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"123123");
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    //创建任务
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
//        NSLog(@"task %@",content);
//    }];
    
    //NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    //开始任务
//    [task resume];
    
    
//    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_OTHER_SIGNUP];
//    DebugLog(@"xxt第三方URL = %@", URL);
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (self.infoID.length) {
//        if (type == LoginTypeQQ) {
//            [params setObject:self.infoID forKey:@"qq_uid"];
//        } else if (type == LoginTypeWechat) {
//            [params setObject:self.infoID forKey:@"wx_unionid"];
//        } else if (type == LoginTypeWeibo) {
//            [params setObject:self.infoID forKey:@"weibo_uid"];
//        }
//    }
    
//    if (self.nickName.length) {
//        [params setObject:self.nickName forKey:@"nickname"];
//    }
//    if (self.icon.length) {
//        [params setObject:self.icon forKey:@"avatar"];
//    }
//    [params setObject:self.gender forKey:@"gender"];
//    
//    DebugLog(@"%@",params);
//    [HFNetWork postWithURL:URL params:params success:^(id response) {
//        [MBProgressHUD hideHUD];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        DebugLog(@"xxt第三方response = %@", response);
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //失败返回
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//        
//        //登录成功
//        User *user =[User mj_objectWithKeyValues:response[@"user"]];
//        user.token = response[@"token"];
//        [User saveUserInformation:user];
//        //注册极光
//        [self networkDidSetup];
//        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
//        [JJCity saveCityArrayInformation:cityArray];
//        DebugLog(@"%ld",user.baby_birthday);
//        //        [NSDate dateWithTimeIntervalSince1970:user.birthday];
//        //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>];
//        //发出通知
//        DebugLog(@"xxt登陆成功%@",response);
//        //前往小海囤首页
//        [self gotoMainView];
//        //成功加载
//        //登录成功 ，user信息本地化
//        //        User *user = [[User alloc] initWithDicionary:response];
//        //        [JJUserInformationManager saveUserInformation:user];
//        //
//        //        //isBindMobile = 1 需要验证手机   isBindMobile = 2 不需要验证手机
//        //        NSInteger isBindMobile = [[[response objectForKey:@"user"] objectForKey:@"is_bind_mobile"] integerValue];
//        //        if (isBindMobile == 1) { //跳转到手机完善信息页面
//        //            DebugLog(@"isBindMobile == %ld", isBindMobile);
//        //            BindMobileViewController *bindMobileVC = [[BindMobileViewController alloc] init];
//        //            bindMobileVC.thirtyAvater = self.icon;
//        //            bindMobileVC.thirtyNickName = self.nickName;
//        //            [self.navigationController pushViewController:bindMobileVC animated:YES];
//        //
//        //        } else if (isBindMobile == 2) { //登录成功 直接进主页
//        //            DebugLog(@"isBindMobile == %ld", isBindMobile);
//        //            [self gotoMainView];
//        //        }
//        
//    } fail:^(NSError *error) {
//        NSInteger errCode = [error code];
//        DebugLog(@"xxt第三方errCode = %ld", errCode);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//    }];
    
}
//点击登陆按钮
- (void)loginAction {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号"hudMode:MBProgressHUDModeText];
        return;
    }
    
    if (!_passwordTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入密码" hudMode:MBProgressHUDModeText];
        return;
    }
    if (_passwordTextField.textField.text.length < PASSWORD_LIMITATION_SHORT || _passwordTextField.textField.text.length > PASSWORD_LIMITATION_LONG ) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入长度为6-16位密码" hudMode:MBProgressHUDModeText];
        return;
        
    }
    [self requestToLogin];
    
}

//手机号登录
- (void)requestToLogin {
    [self.view endEditing:YES];
    if (![Util isNetWorkEnable]) {//先判断网络状态
            [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
            return;
        }
    //[MBProgressHUD showHUD:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTextField.textField.text forKey:@"mobile"];
    [params setObject:_passwordTextField.textField.text forKey:@"password"];
    //[request setValue: forHTTPHeaderField:<#(nonnull NSString *)#>]
//    [request setHTTPBody:<#(NSData * _Nullable)#>];
    _jms = [self md5:@"jms_application"];
    NSLog(_jms);
    NSString *username = _phoneTextField.textField.text;
    NSString *password = _passwordTextField.textField.text;
    NSURL *url = [NSURL URLWithString:@"http://www.jiumeisheng.com/shouji/index.php/?m=Member&a=login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置Header参数
    //[request setValue:_jms forHTTPHeaderField:@"token"];
    
    //此处发现如果Method是GET，body中放入参数提交，服务端会收不到。
    
    //设置Body值方法一，这种方法比较简单，为常用方法，不过只能上送参数
    [request setHTTPMethod:@"POST"];
    //NSString *bodyStr = @"";
    NSString *bodyString = [NSString stringWithFormat:@"&username=%@&password=%@&token=%@", username, password,_jms];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"123123");
    // 登录一般为同步请求，发送同步请求
//    NSURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"12313123123");
//    
//    NSLog(@"%@", result);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
   
   //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        NSLog(@"task %@",content);
    }];
    
    //NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    //开始任务
    [task resume];
    
//   //4.根据会话对象创建一个Task(发送请求）
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
//
//    //5.执行任务
//    [dataTask resume];
//    NSURLSessionDataTask *task3 = [session3 dataTaskWithURL:url];
//    NSURLSessionDataTask *task4 = [session1 dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"task4 %@",response);
//        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
//        NSLog(@"task4 %@",content);
//    }];
//    [task4 resume];
//    
//    [self.view endEditing:YES];
//    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_LOGIN];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:_phoneTextField.textField.text forKey:@"mobile"];
//    [params setObject:_passwordTextField.textField.text forKey:@"password"];
    
    /**
     成功返回
     {
     "error_code": 0,
     "token": "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
     "city": [{
     "id": 1,
     "name": "北京",
     },
     ……………………...
     ],
     "user": [
     "id": 12,
     "username": "蓝求",
     "nickname": "张三",
     "gender": 1,
     "birthday": 111212134343,
     "avatar": "http://adf2212sss.jgp",
     "baby_gender": 1,
     "city": 1,
     "baby_name":"宝宝",
     "baby_gender": 1,
     "baby_birthday": 123412341234123,
     "mobile":1852222222,
     "balance":12,
     ],
     }
     失败返回
     {
     "error_code":1,
     "error_msg":"账号密码错误",
     }
     */
    //    if (![Util isNetWorkEnable]) {//先判断网络状态
    //        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
    //        return;
    //    }
    //    [MBProgressHUD showHUD:nil];
    //    _logInBtn.enabled = NO;
//    [HFNetWork postWithURL:URL params:params success:^(id response) {
//        [MBProgressHUD hideHUD];
//        //        _logInBtn.enabled = YES;
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //登录失败
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
//            return ;
//        }
//        //登录成功
//        User *user =[User mj_objectWithKeyValues:response[@"user"]];
//        user.token = response[@"token"];
//        [User saveUserInformation:user];
//        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
//        [JJCity saveCityArrayInformation:cityArray];
//        DebugLog(@"%ld",user.baby_birthday);
//        //        [NSDate dateWithTimeIntervalSince1970:user.birthday];
//        //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>];
        //发出通知
//        DebugLog(@"登陆成功%@",response);
        //前往首页
        [self gotoMainView];
//        //发出加入购物车通知
//        [[NSNotificationCenter defaultCenter]postNotificationName:ShopCartNotification object:nil];
//        
//    } fail:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        //        _logInBtn.enabled = YES;
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
//        
//    }];
    
}

-(void)gotoMainView {
//    DebugLog(@"%@",self.tabBarController);
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.tabBarController setSelectedIndex:0];
    //    });
    
}

- (void)dealloc{
    DebugLog(@"销毁了");
}
//进入注册界面
- (void)signUp {
    JMSSingUpViewController *vc = [[JMSSingUpViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//进入忘记密码界面
- (void)forgetPassword {
    JMSForgetPasswordViewController *vc = [[JMSForgetPasswordViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 关闭键盘
//触摸屏幕键盘弹下来
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTextField.textField resignFirstResponder];
    [_passwordTextField.textField resignFirstResponder];
}
//关闭键盘
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.passwordTextField.textField == textField) {
        if ([toBeString length] > PASSWORD_LIMITATION_LONG) {
            _passwordTextField.textField.text = [toBeString substringToIndex:PASSWORD_LIMITATION_LONG];
            return NO;
        }
    }
    
    if (self.phoneTextField.textField == textField) {
        
    }
    return YES;
}
//#pragma mark --出入设置
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//}

#pragma mark - NSURLSession DataDelegate
//当接收到服务器响应的时候调用这个方法
//参数1:委托
//参数2:当前任务
//参数3:接收到得响应
//参数4:响应完成的block,必须在当前这个方法中调用，
//否则服务器不会返回数据;
//1.接收到服务器响应的时候调用该方法
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
//        NSDictionary *dic =[NSDictionary dictionary];
//        dic = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
        NSLog(@"返回json%@",dict);
        NSLog(@"返回数据%@",_responseData);
        
    
//        arr = [dic objectForKey:@"data"];
//        //        NSLog(@"%@",arr);
//        arrdic = arr[x];
//        NSString *str = [NSString stringWithFormat:@"http://114.55.2.92/%@",[arrdic objectForKey:@"S_Image"]];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
//        currentScreen = [UIScreen mainScreen];
//        //NSLog(@"applicationFrame.size.height = %f",currentScreen.applicationFrame.size.height);
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentScreen.applicationFrame.size.width, currentScreen.applicationFrame.size.height+20)];
//        imgView.image = image;
//        [self.view addSubview:imgView];
//        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(newtimeMethods) userInfo:nil repeats:NO];
    }else{
        //不可用
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接有误，请重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -- MD5加密
-(NSString *)md5:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    return ret;
}
#pragma mark --设置手势
-(void)addRecoginzer{
    
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
