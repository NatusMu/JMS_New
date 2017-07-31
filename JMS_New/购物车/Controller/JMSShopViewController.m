//
//  JMSShopViewController.m
//  JMS_New
//
//  Created by 黄沐 on 21/05/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSShopViewController.h"
#import "SideSwitchViewController.h"
#import "JMSShopAllController.h"
#import "JMSShopPayController.h"
#import "JMSShopReceiveController.h"
#import "JMSShopFinishController.h"
@interface JMSShopViewController ()
@end
@implementation JMSShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self create];
        // Do any additional setup after loading the view.
}
-(void)create{
    JMSShopAllController *All = [[JMSShopAllController alloc]init];
    JMSShopPayController *Pay = [[JMSShopPayController alloc]init];
    JMSShopReceiveController *Receive = [[JMSShopReceiveController alloc]init];
    JMSShopFinishController *Finish = [[JMSShopFinishController alloc]init];
    SideSwitchViewController *sideSwitchController = [[SideSwitchViewController alloc]initViewContollreWithTitles:@[@"全部订单",@"待付款",@"待收货",@"完成"] controllers:@[All,Pay,Receive,Finish] TitleHeight:40 present:YES];
    
    sideSwitchController.title = @"";
    
    [self presentViewController:sideSwitchController animated:NO completion:nil];
}
#pragma mark - 点击跳转
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    JMSShopAllController *All = [[JMSShopAllController alloc]init];
//    JMSShopPayController *Pay = [[JMSShopPayController alloc]init];
//    JMSShopReceiveController *Receive = [[JMSShopReceiveController alloc]init];
//    JMSShopFinishController *Finish = [[JMSShopFinishController alloc]init];
//    SideSwitchViewController *sideSwitchController = [[SideSwitchViewController alloc]initViewContollreWithTitles:@[@"全部订单",@"待付款",@"待收货",@"完成"] controllers:@[All,Pay,Receive,Finish] TitleHeight:40 present:YES];
//    
//    sideSwitchController.title = @"";
//    
//    [self presentViewController:sideSwitchController animated:YES completion:nil];
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
