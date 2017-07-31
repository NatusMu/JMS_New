//
//  ViewController.m
//  Pagecontrol
//
//  Created by 黄沐 on 2016/12/5.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSGuideViewController.h"
#import "JMSWebViewController.h"
@interface JMSGuideViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView* scrollview;
@property (strong,nonatomic) UIPageControl* pageControl;
@property (strong,nonatomic) NSTimer* timer;

@property (nonatomic) CGFloat screenWith;
@property (nonatomic) CGFloat screenHith;

@property(nonatomic,strong)UIView* setView;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;

@end

@implementation JMSGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollview];
    [self pagecontrol];
    [self button];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark --scrollview 设置
-(void)scrollview{
    //获取屏幕长 宽
    _screenWith =CGRectGetWidth(self.view.frame);
    _screenHith =CGRectGetHeight(self.view.frame);
    //1.设置主view
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,_screenWith,_screenHith)];
    _scrollview.backgroundColor = [UIColor whiteColor];
    //2.scrollview可以滚动的范围 表示有几个视图
    _scrollview.contentSize = CGSizeMake(_screenWith*3,_screenHith);
    //3.加载图片
    for(int i=0;i<3;i++){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_screenWith*i,0,_screenWith,_screenHith)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"launcher%d.jpg",i+1]]];
        [_scrollview addSubview:imageView];
    }
    //在整体界面上加一条白边
    UIView *linearView = [[UIView alloc]initWithFrame:CGRectMake(0,_screenHith-60, _screenWith*3, 2)];
    linearView.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:linearView];
    
    //4.滑动式，自动滑动到下一个view,而不是滑动多少就显示到什么位置的view
    [_scrollview setPagingEnabled:YES];
    //5.隐藏滑动条
    [_scrollview setShowsHorizontalScrollIndicator:NO];
    ////避免弹跳效果,避免把根视图露出来
    [_scrollview setBounces:NO];
    [_scrollview setDelegate:self];
    [self.view addSubview:_scrollview];
}
#pragma mark --滚动条
-(void)pagecontrol{
    //设置滚动条
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_scrollview.frame) -40, _screenWith, 20)];
    //设置总页数
    _pageControl.numberOfPages = 3;
    //设置当前页数 默认为0
    _pageControl.currentPage = 0;
    //设置分页指示色
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //设置总页数指示色
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    //加载
    [self.view addSubview:_pageControl];
    
    [self button];
    //[self initTimer];//循环跳动
}
-(void)button{
    _setView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 50)];
    _setView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_setView];
    _button1 = [self button1];
    _button2 = [self button2];
    _button3 = [self button3];
    [_setView addSubview:_button1];
    [_setView addSubview:_button2];
    [_setView addSubview:_button3];
    _button1.hidden = YES;
    _button2.hidden = NO;
    _button3.hidden = NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x/_screenWith);
    if(_pageControl.currentPage == 2)
    {
        _button1.hidden = NO;
        _button2.hidden = YES;
        _button3.hidden = YES;
    }
    else
    {
        _button1.hidden = YES;
        _button2.hidden = NO;
        _button3.hidden = NO;
    }
}
#pragma mark  -Getters
-(UIButton *)button1
{
    if(!_button1)
    {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
        [_button1 setTitle:@"立即进入" forState:UIControlStateNormal];
        [_button1 setFrame:CGRectMake(_screenWith-80-20, 18, 100, 25)];
        [_button1 addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
        _button1.titleLabel.font = [UIFont fontWithName:@"Times" size:17];
        
    }
    return _button1;
}

-(UIButton *)button2
{
    if(!_button2)
    {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button2 setTitle:@"跳过" forState:UIControlStateNormal];
        [_button2 setFrame:CGRectMake(0, 18, 100, 25)];
        [_button2 addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
        _button2.titleLabel.font = [UIFont fontWithName:@"Times" size:17];
    }
    return _button2;
}

-(UIButton *)button3
{
    if(!_button3)
    {
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button3 setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateNormal];
        [_button3 setFrame:CGRectMake(_screenWith-60, 18, 25, 25)];
        [_button3 addTarget:self action:@selector(respondsToButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
    
}
- (void)firstpressed
{
    //点击button跳转到根视图
    JMSWebViewController* vc = [[JMSWebViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)respondsToButton
{
    [_scrollview setContentOffset:CGPointMake(self.view.frame.size.width*(_pageControl.currentPage+1), 0) animated:YES];
}
#pragma mark --循环跳动
//循环跳动
//-(void)initTimer{
//    NSLog(@"init");
//    if(!self.timer){
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRepet) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
//    }
//}
//-(void)timeRepet{
//    NSInteger currentPage =self.pageControl.currentPage+1;
//    if(currentPage>=3){
//        currentPage = 0;
//    }
//    [self.scrollview setContentOffset:CGPointMake(currentPage *_screenWith, 0)animated:YES];
//}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if(self.timer){
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self initTimer];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
