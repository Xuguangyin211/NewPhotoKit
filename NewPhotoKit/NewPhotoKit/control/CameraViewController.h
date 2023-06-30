//
//  CameraViewController.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/27.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraViewController : UIViewController<AVCapturePhotoCaptureDelegate> {
    AVCapturePhotoOutput *captureOutput;
    AVCaptureDeviceInput *frontFacingCameraDeviceInput, *backFacingCameraDeviceInput;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureSession *captureSession;
    NSInteger cameraStatus;
}

@end

NS_ASSUME_NONNULL_END
