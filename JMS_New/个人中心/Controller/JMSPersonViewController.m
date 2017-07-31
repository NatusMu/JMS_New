//
//  JMSPersonViewController.m
//  JMS_New
//
//  Created by 黄沐 on 28/04/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSPersonViewController.h"
#import <SDAutoLayout.h>
#import "JMSCollectionViewCell.h"
#import "JMSLoginViewController.h"
#import "JMSSetViewController.h"

static NSString *ID = @"ID";
static NSString *HeaderID = @"HeaderID";
static NSString *FooterID = @"FooterID";
@interface JMSPersonViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong)UICollectionView *cv;
@property (nonatomic,strong)UIView *header;
@property (nonatomic, strong)UICollectionReusableView *reuseView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *imageArray;

@end
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
@implementation JMSPersonViewController
#pragma mark - UICollectionview
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self CreateData];
    //添加头视图
    [self CreateHeaderView];
    //创立cv
    [self CreateCv];
}
#pragma mark -设置隐藏navigation导航栏
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
}
#pragma mark -创建数据源
-(void)CreateData{
    _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"我的订单", @"我的团购", @"收货地址"], @[@"我的积分", @"退货/退款", @"取消订单"], @[@"绑定账号", @"签到有礼", @"安全退出"], nil];
    //单个添加 一维数组[self.dataArray addObject:arr1];
    //    NSArray * brr1 = @[@"wait_money",@"wait_product",@"wait_comment"];
    //    _imageArray = [[NSMutableArray alloc]initWithObjects:brr1,nil];
}
-(void)CreateCv{
    //1.设置layout
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    //设置同一行相邻两个Cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //设置collectionview滚动方向 s竖直
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    //设置headerView的尺寸大小
    //    _layout.headerReferenceSize = CGSizeMake(Width, 100);
    //该方法也可以设置itemSize
    //_layout.itemSize = CGSizeMake(110, 150);
    _cv = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Height/5, Width, Height)collectionViewLayout:layout];
    _cv.backgroundColor = [UIColor whiteColor];
    _cv.dataSource = self;
    _cv.delegate = self;
    
    [_cv registerClass:[JMSCollectionViewCell class] forCellWithReuseIdentifier:ID];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    //UICollectionElementKindSectionHeader注册是固定的
    [_cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    [_cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterID];
    [self.view addSubview:_cv];
    //layout.headerReferenceSize = CGSizeMake(Width, Height/6);
    //layout.footerReferenceSize = CGSizeMake(Width, Height/3-48);
    // 判断系统版本9.0以后才有这个功能
    //    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
    //
    //        // 当前组如果还在可视范围时让头部视图停留
    //       layout.sectionHeadersPinToVisibleBounds = YES;
    //    }
}
#pragma mark - headerview
- (void)CreateHeaderView {
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Width, Height/5)];
    _header.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_header];
//    //头像
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [UIImage imageNamed:@"login_head"];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setImage:[UIImage imageNamed:@"login_head"] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login_Btn:)forControlEvents:UIControlEventTouchDown];
        [_header sd_addSubviews:@[loginBtn]];
    //[_header sd_addSubviews:@[headImageView]];
    loginBtn.sd_layout
    .leftSpaceToView(_header,15)
    .centerYEqualToView(_header)
    .widthIs(80)
    .heightIs(80);
//    //登陆按钮
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginBtn setImage:[UIImage imageNamed:@"login_bt"] forState:UIControlStateNormal];
//    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchDown];
//    [_header sd_addSubviews:@[loginBtn]];
//    loginBtn.sd_layout
//    .leftSpaceToView(headImageView,15)
//    .centerYEqualToView(headImageView)
//    .widthIs(164/2)
//    .heightIs(67/2);
//    
//    //设置按钮
//    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [setBtn setImage:[UIImage imageNamed:@"my_set"] forState:UIControlStateNormal];
//    [setBtn addTarget:self action:@selector(setBtn:) forControlEvents:UIControlEventTouchDown];
//    [_header sd_addSubviews:@[setBtn]];
//    setBtn.sd_layout
//    .rightSpaceToView(_header,20)
//    .topSpaceToView(_header,20)
//    .widthIs(30)
//    .heightIs(30);
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
-(void)login_Btn:(id)sender{
    JMSLoginViewController * vc = [[JMSLoginViewController alloc]initWithNibName:@"JMSLoginViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
//-(void)setBtn:(id)sender{
//    
//}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMSCollectionViewCell *cell = (JMSCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    //找到每一个按钮
    UIButton *ImageButton = cell.imageButton;
    [ImageButton addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //给每一个cell加边框
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 0.6;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width/3, Height/6);
}
////设置单元格间的竖向间距
//- (CGFloat) collectionView:(UICollectionView *)collectionView
//                    layout:(UICollectionViewLayout *)collectionViewLayout
//minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1;
//}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark -UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //设置背景图片
    //[cell.imageButton setBackgroundImage:[UIImage imageNamed:@0] forState:UIControlStateNormal];
    
}
//返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
#pragma mark -按钮点击
-(void)ButtonPressed:(id)sender{
    //获取父类view
    UIView *cv =[sender superview];
    //获取cell
    JMSCollectionViewCell *cell =(JMSCollectionViewCell *)[cv superview];
    NSIndexPath *indexpath = [_cv indexPathForCell:cell];
    NSLog(@"设备图片按钮被点击:%ld        %ld",(long)indexpath.section,(long)indexpath.row);
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
