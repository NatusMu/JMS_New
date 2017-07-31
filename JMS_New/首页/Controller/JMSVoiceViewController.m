//
//  JMSVoiceViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/12.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSVoiceViewController.h"

@interface JMSVoiceViewController ()

@end
#define Width self.view.frame.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@implementation JMSVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    // Do any additional setup after loading the view.
}
-(void)initNav
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width,Height)];
    backView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.view addSubview:backView];
    //退出
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 35, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"icon_nav_quxiao_normal"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(Close:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
}
-(void)Close:(UIButton*)sender{
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
