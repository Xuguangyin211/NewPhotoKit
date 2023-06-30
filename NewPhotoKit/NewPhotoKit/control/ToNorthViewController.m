//
//  ToNorthViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/28.
//

#import "ToNorthViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ToNorthView.h"

@interface ToNorthViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationM;
@property (nonatomic, strong) ToNorthView *firstView;

@end

@implementation ToNorthViewController

- (ToNorthView *)firstView {
    if (!_firstView) {
        float w = 224;
        _firstView = [[ToNorthView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - w)/2, (self.view.bounds.size.height - 50)/2, w, 50)];
        _firstView.degr(20).cali(w/10).creat();
    }
    return _firstView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self locationMap];
}

- (void)setUpView {
    self.view.backgroundColor = UIColor.whiteColor;

    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 44, 80, 30);
    backBtn.backgroundColor = UIColor.grayColor;
    [backBtn setTitle:@"Back" forState:normal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];

    [self.view addSubview:self.firstView];
}

- (void)locationMap {
    self.locationM = [[CLLocationManager alloc]init];
    self.locationM.delegate = self;
    self.locationM.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationM.distanceFilter = 0.1;
    [self.locationM startUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    float degrees = newHeading.magneticHeading;
    self.firstView.degree = degrees;
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
