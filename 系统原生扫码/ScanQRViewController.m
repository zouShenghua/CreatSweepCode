//
//  ScanQRViewController.m
//  系统原生扫码
//
//  Created by 邹 on 16/10/18.
//  Copyright © 2016年 邹. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    //NSTimer *timer;
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UIView *lineView;
@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatCaptureDevice];
}
- (void)creatCaptureDevice{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理，一旦扫描到指定类型的数据，就会通过代理输出
    //在扫描的过程中，会分析扫描的内容，分析成功后就会调用代理方法在队列中输出
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定当扫描到二维码的时候，产生输出
    //AVMetadataObjectTypeQRCode 指定二维码
    //指定识别类型一定要放到添加到session之后
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //设置扫描信息的识别区域，左上角为(0,0),右下角为(1,1),不设的话全屏都可以识别。设置过之后可以缩小信息扫描面积加快识别速度。
    //这个属性并不好设置，整了半天也没太搞明白，到底x,y,width,height,怎么是对应的，这是我一点一点试的扫描区域，看不到只能调一下，扫一扫试试
    [self.output setRectOfInterest:CGRectMake(0.1 ,0.3 , 0.4, 0.4)];
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
}
#pragma mark 输出的代理
//metadataObjects ：把识别到的内容放到该数组中
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //停止扫描
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
    [self.lineView removeFromSuperview];
    if ([metadataObjects count] >= 1) {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        //拿到扫描内容在这里进行个性化处理
        NSLog(@"识别成功%@",qrObject.stringValue);
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
