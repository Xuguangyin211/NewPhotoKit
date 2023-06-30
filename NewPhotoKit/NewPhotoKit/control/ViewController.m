//
//  ViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/26.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "PhotoViewController.h"
#import "ToNorthViewController.h"
#import "ReachAbility.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *camera;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *north;
@property (nonatomic, strong) UIButton *wifiStatus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat x = (self.view.bounds.size.width - 130)/2;

    self.camera = [[UIButton alloc]initWithFrame:CGRectMake(x, 100, 130, 44)];
    self.camera.backgroundColor = UIColor.redColor;
    [self.camera setTitle:@"camera" forState:normal];
    [self.camera addTarget:self action:@selector(getCameraView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.camera];

    self.photos = [[UIButton alloc] initWithFrame:CGRectMake(x, 200, 130, 44)];
    self.photos.backgroundColor = UIColor.blueColor;
    [self.photos setTitle:@"Photo" forState:normal];
    [self.photos addTarget:self action:@selector(getPhotoView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.photos];

    self.north = [[UIButton alloc]initWithFrame:CGRectMake(x, 300, 130, 44)];
    self.north.backgroundColor = UIColor.greenColor;
    [self.north setTitle:@"North" forState:normal];
    [self.north addTarget:self action:@selector(getToNorthView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.north];

    self.wifiStatus = [[UIButton alloc]initWithFrame:CGRectMake(x, 400, 130, 44)];
    self.wifiStatus.backgroundColor = UIColor.blackColor;
    [self.wifiStatus setTitle:@"Status" forState:normal];
    [self.wifiStatus addTarget:self action:@selector(getIphoneWifiStatus) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.wifiStatus];
}

- (void)getCameraView {
    CameraViewController *cv = [[CameraViewController alloc] init];
    cv.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cv animated:YES completion:^{
        [self removeFromParentViewController];
    }];
}

- (void)getPhotoView {
    PhotoViewController *pv = [[PhotoViewController alloc] init];
    pv.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pv animated:YES completion:^{
        [self removeFromParentViewController];
    }];
}

- (void)getToNorthView {
    ToNorthViewController *toNor = [[ToNorthViewController alloc]init];
    toNor.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:toNor animated:YES completion:^{

    }];
}

- (void)getIphoneWifiStatus {
    ReachAbility *reach = [ReachAbility reachForInternetConnection];
    NSString *tips = @"";
    switch (reach.currentReachabilityStatus) {
        case NotReachable:
            tips = @"无网络连接";
            break;
        case ReachableWIFI:
            tips = @"WIFI";
            break;
        case ReachableWWAN:
            tips = @"WWAN";
            break;
        case Reachable2G:
            tips = @"2G";
            break;
        case Reachable3G:
            tips = @"3G";
            break;
        case Reachable4G:
            tips = @"4G";
            break;
        default:
            break;
    }

    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前网络状态为:%@",tips] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:aa];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
