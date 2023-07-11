//
//  ScrollSliderViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/30.
//

#import "ScrollSliderViewController.h"
#import "ScrollSliderView.h"

@interface ScrollSliderViewController ()

@end

@implementation ScrollSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (void)setUpView {

    ScrollSliderView *view = [[ScrollSliderView alloc]initWithFrame: CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:view];
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
