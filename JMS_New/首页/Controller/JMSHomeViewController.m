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
#import <SVProgressHUD.h>
@interface JMSHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UIView *SuperView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) 
@end
#define Width self.view.frame.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@implementation JMSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    JMSWebViewController *vc = [[JMSWebViewController alloc]init];
    [self initAddView];
    [vc initWebView];
    
    
    //手势
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    // Do any additional setup after loading the view.
}
#pragma mark --初始化头部
//重新初始化头部,考虑到navigationController定制度很高
-(void)setNav
{
    
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(-0.5, -0.5, [UIScreen mainScreen].bounds.size.width+1, 64.5)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
    [self.view addSubview:self.NavView];
    //左边按钮
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(20, 23, 40, 35);
    [leftbtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
    
    leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    
    leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    if (item.city == nil)
    {
        [leftbtn setTitle:@"绍兴" forState:UIControlStateNormal];
    }else
    {
        [leftbtn setTitle:item.city forState:UIControlStateNormal];
    }
    //leftbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    leftbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftbtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftbtn = leftbtn;
    [self.NavView addSubview:leftbtn];
    
    //右边按钮
    UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-08"] forState:UIControlStateNormal];
    EBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-64, 30, 20, 20);
    [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    EBtn.tag = 401;
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"home-10-07"] forState:UIControlStateNormal];
    XBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-34, 28, 24, 24);
    [XBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    XBtn.tag = 402;
    
    [self.NavView addSubview:EBtn];
    [self.NavView addSubview:XBtn];
    
    //中间
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(70, 25, [UIScreen mainScreen].bounds.size.width-145, 30)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    view.layer.cornerRadius = 10;//设置那个圆角的有多圆
    view.layer.borderWidth = 0.2;//设置边框的宽度，当然可以不要
    view.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    view.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30)];
    searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    searchBar.placeholder = @"搜索商家或地点";
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
    
    UIButton *YBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [YBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    YBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-180, 0, 45, 30);
    [YBtn addTarget:self action:@selector(rightBtnClick3:) forControlEvents:UIControlEventTouchUpInside];
    searchBar.showsScopeBar = NO;
    
    [view addSubview:searchBar];
    //键盘上放一个按钮
    UIButton *sousuo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sousuo.backgroundColor colorWithAlphaComponent:0];
    sousuo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30);
    [sousuo addTarget:self action:@selector(sousuo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sousuo];
    [view addSubview:YBtn];
    [self.NavView addSubview:view];
}
#pragma mark --加载动画
- (void)initAddView{
    _SuperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width,Height)];
    _SuperView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *ChangeImages = [NSMutableArray array];
    for (NSUInteger i=1; i<=9; i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];;
        [ChangeImages addObject:image];
    }
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-100, Height/2-70, 200, 120)];
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
#pragma  mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
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
