//
//  JMSScanViewController.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/9.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>
@interface JMSScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;//输入输出的中间桥梁
}
@end
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#define SCAN_WIDTH 255

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@implementation JMSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"扫一扫";
    
    if (SIMULATOR == 1)
    {
        NSLog(@"模拟器");
    }else{
        [self OpenScan];
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [imageview setImage:[UIImage imageNamed:@"qrcode_scan_bg_Green_iphone5"]];
    [self.view addSubview:imageview];
    // Do any additional setup after loading the view.
}   

-(void)scanAgainBtn:(UIButton *)sender//再次扫描
{
    [_session startRunning];
}

-(void)OpenScan
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGFloat topMargin = 128.0;
    //    output.rectOfInterest = CGRectMake(y坐标/父bounds.高, x坐标/父bounds.宽, 高/父bounds.高, 宽/父bounds.宽);
    output.rectOfInterest = CGRectMake(topMargin/screen_height, (screen_width-SCAN_WIDTH)/2/screen_width, SCAN_WIDTH/screen_height, SCAN_WIDTH/screen_width);
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

#pragma mark - **************** AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showInfoWithStatus:metadataObject.stringValue];
    }
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
