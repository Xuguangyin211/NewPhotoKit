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

@interface ViewController ()
@property (nonatomic, strong) UIButton *camera;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *north;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat x = (self.view.bounds.size.width - 120)/2;

    self.camera = [[UIButton alloc]initWithFrame:CGRectMake(x, 100, 120, 60)];
    self.camera.backgroundColor = UIColor.redColor;
    [self.camera setTitle:@"camera" forState:normal];
    [self.camera addTarget:self action:@selector(getCameraView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.camera];

    self.photos = [[UIButton alloc] initWithFrame:CGRectMake(x, 200, 120, 60)];
    self.photos.backgroundColor = UIColor.blueColor;
    [self.photos setTitle:@"Photo" forState:normal];
    [self.photos addTarget:self action:@selector(getPhotoView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.photos];

    self.north = [[UIButton alloc]initWithFrame:CGRectMake(x, 300, 120, 60)];
    self.north.backgroundColor = UIColor.greenColor;
    [self.north setTitle:@"North" forState:normal];
    [self.north addTarget:self action:@selector(getToNorthView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.north];
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

@end
