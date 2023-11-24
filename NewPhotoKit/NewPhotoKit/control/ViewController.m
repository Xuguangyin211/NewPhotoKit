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
#import "CodeInputView.h"
#import "ScrollSliderViewController.h"
#import "NSObject+YYmod.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIButton *camera;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *north;
@property (nonatomic, strong) UIButton *wifiStatus;
@property (nonatomic, strong) UIButton *scrollView;
@property (nonatomic, strong) CodeInputView *codeInput;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.array = @[
        @{@"CameraViewController": @"Camera"},
        @{@"PhotoViewController": @"Photo"},
        @{@"ToNorthViewController": @"North"},
        @{@"ScrollSliderViewController": @"Scroll"},
        @{@"ViewC": @"Status"},
        @{@"ViewC": @"VerityCode"},
        @{@"SelectionBoxViewController": @"Picker"},
    ];
    [self setupViews];
    [self randoms];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ccca"];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccca" forIndexPath:indexPath];

    NSDictionary *dic = self.array[indexPath.row];
    NSString *descption = [dic allValues][0];
    cell.textLabel.text = descption;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.array[indexPath.row];
    NSString *vcName = [dic allKeys][0];
    if (![vcName isEqual: @"ViewC"]) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:^{
            [self removeFromParentViewController];
        }];
    } else {
        if (indexPath.row == 4) {
            [self getIphoneWifiStatus];
        } else if (indexPath.row == 5) {
            [self addMEE];
        }
    }
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

- (void)addMEE {
    _codeInput = [[CodeInputView alloc] initWithFrame:CGRectMake(20, ([UIScreen mainScreen].bounds.size.height - 200)/2, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    [self.view addSubview:_codeInput];
    _codeInput.center = self.view.center;
    [self.codeInput becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.codeInput];
    if (!result) {
        NSLog(@"ccc");
        [self.codeInput removeFromSuperview];
    }
}

- (void)randoms {
    
//    NSString *str = @"";
//    NSString *a = [NSObject setEncode:str isPlus:NO num:6];
//    NSString *b = [NSObject getDecode:a isPlus:NO num:6];

    //    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //    for (NSInteger i = 32; i < 129; i++) {
    //        NSString *m = [NSString stringWithFormat:@"%ld",(long)i];
    //        [arr addObject:m];
    //    }
    //
    //    NSMutableArray *rest = [[NSMutableArray alloc]initWithCapacity:arr.count];
    //    NSInteger m = arr.count;
    //    for (NSInteger i = 0; i < m; i++) {
    //        NSInteger index = arc4random_uniform((unsigned int)arr.count);
    //        [rest addObject:[arr objectAtIndex:index]];
    //        [arr removeObjectAtIndex:index];
    //    }
    //    for (NSInteger i = 0; i < rest.count; i++) {
    //        NSLog(@"%@", rest[i]);
    //    }
    //    [rest addObject:@" "];
    //    [rest addObject:@" "];
    //    NSLog(@"%lu", (unsigned long)rest.count);
    //
    
    //
    //    for (NSInteger i = 1 ; i <= 9; i++) {
    //        NSString *m;
    //        for (NSInteger j = 0; j < 11; j++) {
    //            NSInteger index = 11 * i + j;
    //            NSString *s = [NSString stringWithFormat:@"%@", rest[index]];
    //            NSLog(@"%@", s);
    //        }
    //        NSLog(@"%@", m);
    //    }
}

@end
