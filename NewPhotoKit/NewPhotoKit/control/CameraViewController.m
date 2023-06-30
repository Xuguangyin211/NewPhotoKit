//
//  CameraViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/27.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    cameraStatus = 1;
    [self findFrontAndBackDevice];
    [self initCapture];
}

- (void)findFrontAndBackDevice {
        NSArray<AVCaptureDeviceType> *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera];
        NSArray *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified].devices;
        
        for (AVCaptureDevice *device in devices) {
            if ([device hasMediaType:AVMediaTypeVideo]) {
                if ([device position] == AVCaptureDevicePositionBack) {
                    if (!backFacingCameraDeviceInput){
                        backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                    }
                }
                else {
                    if (!frontFacingCameraDeviceInput) {
                        frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                    }
                }
            }
        }
    }

- (void)initCapture {
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 44, 80, 30);
    backBtn.backgroundColor = UIColor.grayColor;
    [backBtn setTitle:@"Back" forState:normal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    
    if (!backFacingCameraDeviceInput) {
        return;
    }

    if (!captureOutput) {
        captureOutput = [[AVCapturePhotoOutput alloc]init];
    }

    if (!captureSession) {
        captureSession = [[AVCaptureSession alloc]init];
    }
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;

    if ([captureSession canAddInput:backFacingCameraDeviceInput]) {
        [captureSession addInput:backFacingCameraDeviceInput];
    }

    if ([captureSession canAddOutput:captureOutput]) {
        [captureSession addOutput:captureOutput];
    }

    if (!captureVideoPreviewLayer) {
        captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    }

    self.view.backgroundColor = UIColor.clearColor;
    captureVideoPreviewLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    captureVideoPreviewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:captureVideoPreviewLayer atIndex:0];
    [captureSession startRunning];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    NSLog(@"yess");
}

@end
