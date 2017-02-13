//
//  VDBeautifyCameraManager.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/7.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "VDBeautifyCameraManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"

#import "VDBeautifyCameraFooter.h"
#import "VDCameraAndPhotoTool.h"

#import "VDBeautifyPhotoView.h"

#import "VDBeautifyPhotoViewController.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kPhotoButtonWidth 70
#define kFooterHeight 100


@interface VDBeautifyCameraManager ()<VDBeautifyCameraFooterDelegate>

/**
 背景视图
 */
@property(nonatomic, strong) VDBeautifyPhotoView *beautifyPhotoView;

/**
 背景视图
 */
@property(nonatomic, strong) UIView *backView;

/**
 底部视图
 */
@property(nonatomic, strong) VDBeautifyCameraFooter *footer;

/**
 用于执行输入设备和输出设备之间的设备传递
 */
@property(nonatomic, strong) AVCaptureSession *session;

/**
 输入设备
 */
@property(nonatomic, strong) AVCaptureDeviceInput *videoInput;

/**
 照片输出流
 */
@property(nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

/**
 预览图层
 */
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation VDBeautifyCameraManager

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initAVCapture];
    [self initUI];
    
    
    
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}

- (void)initUI {
    
    [self.view addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.backView addSubview:self.footer];
    
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kFooterHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAVCapture {
    
    //初始化session
    self.session = [[AVCaptureSession alloc] init];
    
    //创建一个设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设置闪关灯为自动
    //首先需要锁定设备
    [device lockForConfiguration:nil];
    //设置闪光灯
    [device setFlashMode:AVCaptureFlashModeAuto];
    //解锁设备
    [device unlockForConfiguration];
    
    //初始化输入设备
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        
        NSLog(@"%@",error);
    }
    
    //初始化照片输出流
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //设置输出图片格式
    NSDictionary *outputSttings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSttings];
    
    //将输入和输出添加到session中
    if ([self.session canAddInput:self.videoInput]) {
        
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        
        [self.session addOutput:self.imageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    NSLog(@"%f",kMainScreenWidth);
    
    self.previewLayer.frame = CGRectMake(0, 64,kMainScreenWidth,kMainScreenHeight - 64 - kFooterHeight);
    
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer addSublayer:self.previewLayer];
    
}


- (void)VDBeautifyCameraFooterTakePhoto {
    
    AVCaptureConnection *stillImageConnection = [self.imageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
            
            [weakSelf.footer updateImgView];
        }];
        
        VDBeautifyPhotoViewController *vc = [[VDBeautifyPhotoViewController alloc] init];
        
        vc.photo = [UIImage imageWithData:jpegData];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];

    
}

- (void)VDBeautifyCameraFooterClickPicker {
    
    [[VDCameraAndPhotoTool shareInstance] showPhotoInViewController:self andFinishBack:^(UIImage *image, NSString *videoPath) {
        
    }];
}


-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (UIView *)backView {
    
    if (_backView == nil) {
        
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (VDBeautifyCameraFooter *)footer {
    
    if (_footer == nil) {
        
        _footer = [[VDBeautifyCameraFooter alloc] init];
        _footer.delegate = self;
    }
    return _footer;
}

- (VDBeautifyPhotoView *)beautifyPhotoView {
    
    if (_beautifyPhotoView == nil) {
        
        _beautifyPhotoView = [[VDBeautifyPhotoView alloc] initWithFrame:self.view.bounds];
    }
    return self;
}

@end
