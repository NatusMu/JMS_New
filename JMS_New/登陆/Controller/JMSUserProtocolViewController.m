//
//  JMSUserProtocolViewController.m
//  JMS_New
//
//  Created by 黄沐 on 12/07/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSUserProtocolViewController.h"

@interface JMSUserProtocolViewController ()



@end

@implementation JMSUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.navigationItem.title = @"用户许可协议";
    
//    [self.view addSubview:self.webView];
//    self.webView.scalesPageToFit = YES;
//    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
//    self.webView.remoteUrl = self.url;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    
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
