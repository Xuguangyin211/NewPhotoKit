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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (ToNorthView *)firstView {
    if (!_firstView) {
        float w = 224;
        _firstView = [[ToNorthView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - w)/2, 100, w, 50)];
        _firstView.backgroundColor = UIColor.yellowColor;
        _firstView.degr(20).cali(w/10).creat();
        [self.view addSubview:_firstView];
    }
    return _firstView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
