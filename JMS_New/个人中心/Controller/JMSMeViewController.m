//
//  JMSMeViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/11/24.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSMeViewController.h"
#import "JMSLoginViewController.h"
#import "JMSSetViewController.h"
#import <SDAutoLayout.h>
@interface JMSMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
@implementation JMSMeViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人中心";
    [self CreateData];
    [self CreateTableView];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark --设置隐藏navigation导航栏
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
}
#pragma mark --创建表
-(void)CreateTableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,Width,Height)style:UITableViewStylePlain];
    }
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.tableHeaderView = [self tableViewHead];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
#pragma mark --创建数据源
-(void)CreateData{
    _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"我的订单", @"我的团购", @"收货地址"], @[@"我的积分", @"退货/退款", @"取消订单"], @[@"绑定账号", @"签到有礼", @"安全退出"], nil];
    //单个添加 一维数组[self.dataArray addObject:arr1];
//    NSArray * brr1 = @[@"wait_money",@"wait_product",@"wait_comment"];
//    _imageArray = [[NSMutableArray alloc]initWithObjects:brr1,nil];
}
#pragma mark --Table
-(UIView*)tableViewHead{
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    //设置不可操作
    headView.userInteractionEnabled = YES;
    headView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(210);
    //头像
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [UIImage imageNamed:@"login_head"];
    [headView sd_addSubviews:@[headImageView]];
    headImageView.sd_layout
    .leftSpaceToView(headView,15)
    .centerYEqualToView(headView)
    .widthIs(80)
    .heightIs(80);
    //登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setImage:[UIImage imageNamed:@"login_bt"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchDown];
    [headView sd_addSubviews:@[loginBtn]];
    loginBtn.sd_layout
    .leftSpaceToView(headImageView,15)
    .centerYEqualToView(headImageView)
    .widthIs(164/2)
    .heightIs(67/2);
    
    //设置按钮
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"my_set"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtn:) forControlEvents:UIControlEventTouchDown];
    [headView sd_addSubviews:@[setBtn]];
    setBtn.sd_layout
    .rightSpaceToView(headView,20)
    .topSpaceToView(headView,20)
    .widthIs(30)
    .heightIs(30);
    return headView;
}
-(void)loginBtn:(UIButton*)btn{
    JMSLoginViewController * vc = [[JMSLoginViewController alloc]initWithNibName:@"JMSLoginViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)setBtn:(UIButton*)btn{
    JMSSetViewController *vc = [[JMSSetViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
////一行有多少个
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *arr =_dataArray[section];
//    return arr.count;
//}

//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    return arr.count;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CELL%ld%ld",(long)[indexPath section],(long)[indexPath section]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag = 1;
        UILabel *label = [[UILabel alloc]init];
        label.tag = 2;
        [cell sd_addSubviews:@[imageView,label]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView * imageview =(UIImageView*)[cell viewWithTag:1];
    UILabel * label =(UILabel *)[cell viewWithTag:2];
    label.font=[UIFont systemFontOfSize:16];
    label.alpha=.7;
    imageview.sd_layout
    .leftSpaceToView(cell,20)
    .centerYEqualToView(cell)
    .widthIs(18)
    .heightIs(18);
    
    label.sd_layout
    .leftSpaceToView(imageview,10)
    .centerYEqualToView(imageview)
    .heightIs(20);
    [label setSingleLineAutoResizeWithMaxWidth:120];
    imageview.image=[UIImage imageNamed:_imageArray[indexPath.section][indexPath.row]];
    label.text=_dataArray[indexPath.section][indexPath.row];
    return cell;
}
#pragma mark --表的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            //管理
            Class class;
        }
    }
}
//设置内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
