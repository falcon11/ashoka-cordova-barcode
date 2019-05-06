//
//  ASCDVBarCodeViewController.m
//  Tutorial
//
//  Created by Ashoka on 2019/5/6.
//

#import <AVFoundation/AVFoundation.h>
#import "ASCDVBarCodeViewController.h"

@interface ASCDVBarCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
}

@end

@implementation ASCDVBarCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        self.callback(error, @[]);
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];

    //初始化链接对象
    _session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置代理
    dispatch_queue_t queue = dispatch_queue_create("com.ashoka.barcode", nil);
    [output setMetadataObjectsDelegate:self queue:queue];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容) 需要先将 output 加到 session 才能设置 MetadataObjectTypes
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];

    //开始捕获
    dispatch_async(queue, ^{
        [_session startRunning];
    });

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height - 10, 80, 44)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)dismiss {
    AVCaptureSession *session = _session;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [session stopRunning];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSMutableArray *results = @[].mutableCopy;
    if (metadataObjects.count > 0) {
        for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
            [results addObject:metadata.stringValue];
        }
        self.callback(nil, results);
        [self dismiss];
    }
}

@end
