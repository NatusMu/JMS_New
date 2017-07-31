//
//  JMSCityViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/12.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSCityViewController.h"
#import "JMSData.h"
#import "JMSDataModel.h"
@interface JMSCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;//服务器数据
@property (nonatomic,strong) NSMutableArray *indexSource;//引用数据
@end

@implementation JMSCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initData];
    [self initTableView];
    // Do any additional setup after loading the view.
}
-(void)initNav
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    backView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.view addSubview:backView];
    //退出
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 30, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"icon_nav_quxiao_normal"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 30, 100, 25)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"选择城市";
    [backView addSubview:titleLabel];
}
-(void)initTableView
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    
    _tableview.dataSource = self;
    _tableview.delegate = self;
    
    _tableview.sectionIndexColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    [self.view addSubview:_tableview];
}
-(void)initData
{
    self.dataSource = [[NSMutableArray alloc] init];
    self.indexSource = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *city = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _dataSource = [self sortArray:city];
}

-(void)OnCloseBtn:(UIButton *)sender//推出设置
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - 排序并按首字母分组

-(NSMutableArray *)sortArray:(NSMutableArray *)arrayToSort
{
    NSMutableArray *arrayForArrays = [[NSMutableArray alloc] init];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    //排序
    [arrayToSort sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    
    //分组
    for (int i = 0; i < arrayToSort.count; i++)
    {
        NSString *pinyin = [arrayToSort[i] objectForKey:@"pinyin"];
        NSString *firstChar = [pinyin substringToIndex:1];
        //NSLog(@"%@",firstChar);
        if (![_indexSource containsObject:[firstChar uppercaseString]])
        {
            [_indexSource addObject:[firstChar uppercaseString]];//建立字母表
            tempArray = [[NSMutableArray alloc] init];
            flag = NO;
        }
        if ([_indexSource containsObject:[firstChar uppercaseString]])
        {
            [tempArray addObject:arrayToSort[i]];
            if (flag == NO)
            {
                [arrayForArrays addObject:tempArray];
                flag = YES;
            }
        }
    }
    
    return arrayForArrays;
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}
//字母分段  且在最上显示
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_indexSource objectAtIndex:section];
}
//右侧的字母表
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexSource;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"selectedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text = [[self.dataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JMSData *item = [[JMSDataModel sharedStore] allItems][0];
    item.city = [[self.dataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
