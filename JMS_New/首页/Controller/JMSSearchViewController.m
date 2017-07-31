//
//  JMSSearchViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/9.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSSearchViewController.h"
#import "JMSData.h"
#import "JMSDataModel.h"
@interface JMSSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UIView *customNavBar;
@end
#define Width self.view.frame.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@implementation JMSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    
//    for (int i = 0; i < 100; i++) {
//        
//        NSString *str = [NSString stringWithFormat:@"测试数据%d", i];
//        
//        [self.datas addObject:str];
//    }
    
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    // 是否自动隐藏导航
    //        search.hidesNavigationBarDuringPresentation = NO;
    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
    
    search.searchBar.delegate = self;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,Width, Height) style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTable:)];
    move.delegate = self;
    move.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:move];
    [self.view addSubview:self.tableView];
}
/*
 -(void)initScrollView
 {
 self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60)];
 self.scrollView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
 
 [self.scrollView setContentOffset:CGPointMake(0, 0)];
 self.scrollView.delegate = self;
 self.scrollView.showsVerticalScrollIndicator = NO;
 
 [self.tableView addSubview:self.scrollView];
 
 }*/
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}
#pragma mark --设置隐藏navigation导航栏
//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden =YES;
//}
- (UIView *)customNavBar {
    if (_customNavBar == nil) {
        _customNavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _customNavBar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_customNavBar];
    }
    return _customNavBar;
}
- (void)setupNavBar {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 80, 44);
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
}

- (void)backBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        
        cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
    } else {
        
        cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        
        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    for (NSString *str in self.datas) {
        
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [self.results addObject:str];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    CGRect barFrame = self.customNavBar.frame;
    // 移动到屏幕上方
    barFrame.origin.y = - 64;
    
    
    // 调整tableView的frame为全屏
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 20;
    tableFrame.size.height = self.view.frame.size.height -20;
    
    
    self.customNavBar.frame = barFrame;
    self.tableView.frame = tableFrame;
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
        [self.tableView layoutIfNeeded];
    }];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    CGRect barFrame = self.customNavBar.frame;
    // 恢复
    barFrame.origin.y = 0;
    
    
    // 调整tableView的frame为全屏
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 64;
    tableFrame.size.height = self.view.frame.size.height - 64;
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.customNavBar.frame = barFrame;
        self.tableView.frame = tableFrame;
    }];
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
