//
//  SelectionBoxViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/13.
//

#import "SelectionBoxViewController.h"
#import "NSDate+BGPickerView.h"
#import "PickerView.h"
#import "InfoViewCell.h"
#import "StringPickerView.h"
#import "AddressPickerView.h"
#import "InfoModel.h"
#import "UIImage+Color.h"
#import "UIColor+Add.h"

#define kThemeColor BR_RGB_HEX(0x2e70c2, 1.0f)

typedef NS_ENUM(NSInteger, TimeType) {
    TimeTypeBeginTime = 1,
    TimeTypeEndTime
};

@interface SelectionBoxViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *beginTimeText;
@property (nonatomic, strong) UITextField *endTimeText;
@property (nonatomic, strong) UIView *beginTimeView;
@property (nonatomic, strong) UIView *endTimeView;
@property (nonatomic, strong) PickerView *pickerView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) InfoModel *infoModel;
@property (nonatomic, assign) TimeType timeType;

@property (nonatomic, assign) NSInteger genderSelectIndex;
@property (nonatomic, strong) NSDate *birthdaySelectDate;
@property (nonatomic, strong) NSDate *birthtimeSelectDate;
@property (nonatomic, assign) NSInteger educationSelectIndex;
@property (nonatomic, assign) NSArray <NSNumber *> *addressSelectIndexs;
@property (nonatomic, assign) NSArray <NSNumber *> *otherSelectIndexs;
@property (nonatomic, strong) NSDate *beginSelectDate;
@property (nonatomic, strong) NSDate *endSelectDate;

@end

@implementation SelectionBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Demo";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    [self loadData];
    [self initUI];
}

- (void)loadData {
    //初始化
    self.infoModel.nameStr = @"";
    self.infoModel.genderStr = @"";
    self.infoModel.birthdayStr = @"";
    self.infoModel.birthtimeStr = @"";
    self.infoModel.phoneStr = @"";
    self.infoModel.addressStr = @"";
    self.infoModel.educationStr = @"";
    self.infoModel.otherStr = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
    //设置开始时间默认选择的值及状态
    self.beginSelectDate = [NSDate date];
    self.beginTimeText.text = [NSDate br_getDateString:self.beginSelectDate format:@"yyyy-MM-dd HH"];
    self.beginTimeText.textColor = UIColor.blueColor;
    self.beginTimeView.backgroundColor = UIColor.blueColor;
    //设置选择器滚动到指定的日期
    self.pickerView.selectDate = self.beginSelectDate;
}

- (void)clickSaveBtn {
    NSLog(@"-----保存数据------");
    NSLog(@"姓名： %@", self.infoModel.nameStr);
    NSLog(@"性别： %@", self.infoModel.genderStr);
    NSLog(@"出生日期：%@", self.infoModel.birthdayStr);
    NSLog(@"出生时刻：%@", self.infoModel.birthtimeStr);
    NSLog(@"联系方式：%@", self.infoModel.phoneStr);
    NSLog(@"地址： %@", self.infoModel.addressStr);
    NSLog(@"学历： %@", self.infoModel.educationStr);
    NSLog(@"其他： %@", self.infoModel.otherStr);
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        if (@available(iOS 13.0, *)) {
            _tableView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _tableView.backgroundColor = [UIColor whiteColor];
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = self.footerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UitableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"textCell";
    InfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[InfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入";
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.text = self.infoModel.nameStr;
        }
            break;
        case 1:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.genderStr;
        }
            break;
        case 2:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthdayStr;
        }
            break;
        case 3:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.birthtimeStr;
        }
            break;
        case 4:
        {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.phoneStr;
        }
            break;
        case 5:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.addressStr;
        }
            break;
        case 6:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.infoModel.educationStr;
        }
            break;
        case 7:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"清选择";
            cell.textField.text = self.infoModel.otherStr;
        }
            break;
        case 8:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 获取地区数据源
- (NSArray *)getAddressDataSource {
    //加载地区数据源(实际开发中这里可以写网络请求，从服务端请求数据。可以把City.json) 件的数据放到服务端去维护，通过接口获取这个数据源数组）
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"city.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dataSource;
}

#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES;
    } else {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect: textField];
        return NO;
        //当前textfield 不可编辑，可以响应点击事件
    }
}

#pragma mark -处理编辑事件
- (void)handlerTextFieldEndEdit: (UITextField *)textField {
    NSLog(@"结束编辑：%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.infoModel.nameStr = textField.text;
        }
            break;
        case 4:
        {
            self.infoModel.phoneStr = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark -处理点击事件
- (void)handlerTextFieldSelect: (UITextField *)textField {
    switch (textField.tag) {
        case 1:
        {
            StringPickerView *stringPickerView = [[StringPickerView alloc]init];
            stringPickerView.pickerMode = StringPickerModeComponentSingle;
            stringPickerView.title = @"请选择性别";
            stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
            stringPickerView.selectIndex = self.genderSelectIndex;
            stringPickerView.resultModelBlock = ^(ResultModel * resultModel) {
                self.genderSelectIndex = resultModel.index;
                self.infoModel.genderStr = resultModel.value;
                textField.text = resultModel.value;
            };
            [stringPickerView show];
        }
            break;
        case 2:
        {
            //出生年月日
            PickerView *pickerView = [[PickerView alloc]init];
            pickerView.pickerMode = DatePickerModeYMD;
            pickerView.title = @"请选择年月日";
            pickerView.monthNameType = MonthNameTypeShortName;
            pickerView.selectDate = self.birthdaySelectDate;
            pickerView.selectValue = self.infoModel.birthdayStr;
            pickerView.minDate = [NSDate br_setYear:1948 month:10 day:1];
            pickerView.maxDate = [NSDate br_setYear:2023 month:10 day:20];
            pickerView.isAutoSelect = YES;
            pickerView.addCustomString = @"自定义";
            pickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                self.birthdaySelectDate = selectDate;
                self.infoModel.birthdayStr = selectValue;
                textField.text = selectValue;

                NSLog(@"selectValue = %@", selectValue);
                NSLog(@"selectDate = %@", selectDate);
            };
            [pickerView show];
        }
            break;
        case 3:
        {
            PickerView *pickerView = [[PickerView alloc]init];
            pickerView.pickerMode = DatePickerModeHMS;
            pickerView.title = @"出生时刻";
            pickerView.selectDate = self.birthtimeSelectDate;
            pickerView.isAutoSelect = YES;
            pickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                self.birthtimeSelectDate = selectDate;
                self.infoModel.birthtimeStr = selectValue;
                textField.text = selectValue;
            };

            //自定义弹框样式
            PickerStyle *customStyle = [PickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
            pickerView.pickerStyle = customStyle;
            [pickerView show];
        }
            break;
        case 5:
        {
            // 地区
            AddressPickerView *addressPickerView = [[AddressPickerView alloc]init];
            addressPickerView.pickerMode = AddressPickerModeArea;
            addressPickerView.title = @"请选择地区";
            //addressPickerView.selectValues = [self.infoModel.addressStr componentsSeparatedByString:@" "];
            addressPickerView.selectIndexs = self.addressSelectIndexs;
            addressPickerView.isAutoSelect = YES;
            addressPickerView.resultBlock = ^(ProvinceModel *province, CityModel *city, AreaModel *area) {
                self.addressSelectIndexs = @[@(province.index), @(city.index), @(area.index)];
                self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
                textField.text = self.infoModel.addressStr;
            };
            [addressPickerView show];
        }
            break;
        case 6:
        {
            // 学历
            StringPickerView *stringPickerView = [[StringPickerView alloc]init];
            stringPickerView.pickerMode = StringPickerModeComponentSingle;
            stringPickerView.title = @"请选择学历";
            stringPickerView.plistName = @"dataList.plist";
            stringPickerView.selectIndex = self.educationSelectIndex;
            //stringPickerView.selectValue = self.infoModel.educationStr;
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelBlock = ^(ResultModel *resultModel) {
                self.educationSelectIndex = resultModel.index;
                self.infoModel.educationStr = resultModel.value;
                textField.text = self.infoModel.educationStr;
            };

            // 自定义弹框样式
            PickerStyle *customStyle = [[PickerStyle alloc]init];
            if (@available(iOS 13.0, *)) {
                customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
            } else {
                customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
            }
            customStyle.separatorColor = [UIColor clearColor];
            stringPickerView.pickerStyle = customStyle;

            [stringPickerView show];
        }
            break;
        case 7:
        {
            /// 融资情况
            NSArray *infoArr = @[@{@"key": @"1001", @"value": @"无融资", @"remark": @""},
                                 @{@"key": @"2001", @"value": @"天使轮", @"remark": @""},
                                 @{@"key": @"3001", @"value": @"A轮", @"remark": @""},
                                 @{@"key": @"4001", @"value": @"B轮", @"remark": @""},
                                 @{@"key": @"5001", @"value": @"C轮以后", @"remark": @""},
                                 @{@"key": @"6001", @"value": @"已上市", @"remark": @""}];
            NSMutableArray *modelArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in infoArr) {
                ResultModel *model = [[ResultModel alloc]init];
                model.key = dic[@"key"];
                model.value = dic[@"value"];
                model.remark = dic[@"remark"];
                [modelArr addObject:model];
            }

            StringPickerView *stringPickerView = [[StringPickerView alloc]init];
            stringPickerView.pickerMode = StringPickerModeComponentSingle;
            stringPickerView.title = @"融资情况";
            stringPickerView.dataSourceArr = [modelArr copy];
            stringPickerView.selectIndex = 2;
            stringPickerView.resultModelBlock = ^(ResultModel *resultModel) {
                NSLog(@"选择的索引：%@", @(resultModel.index));
                NSLog(@"选择的值：%@", resultModel.value);
                textField.text = resultModel.value;
            };
            [stringPickerView show];
        }
            break;
        case 8:
        {
            /// 多列字符串
            StringPickerView *stringPickerView = [[StringPickerView alloc]init];
            stringPickerView.pickerMode = StringPickerModeComponentMulti;
            stringPickerView.title = @"自定义多列字符串";
            stringPickerView.dataSourceArr = @[@[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"], @[@"优秀", @"良好", @"及格", @"不及格"]];
            stringPickerView.selectIndexs = self.otherSelectIndexs;
            //stringPickerView.selectValues = [self.infoModel.otherStr componentsSeparatedByString:@"，"];
            stringPickerView.isAutoSelect = YES;
            stringPickerView.resultModelArrayBlock = ^(NSArray<ResultModel *> *resultModelArr) {
                self.otherSelectIndexs = @[@(resultModelArr[0].index), @(resultModelArr[1].index)];
                self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", resultModelArr[0].value, resultModelArr[1].value];
                textField.text = self.infoModel.otherStr;
            };
            
            // 设置选择器中间选中行的样式
            PickerStyle *customStyle = [[PickerStyle alloc]init];
            customStyle.selectRowTextFont = [UIFont boldSystemFontOfSize:20.0f];
            customStyle.selectRowTextColor = [UIColor blueColor];
            stringPickerView.pickerStyle = customStyle;
            
            [stringPickerView show];
            
        }
            break;
        case 100:
        {
            NSLog(@"点击了开始时间：%@", self.beginTimeText.text);
            self.timeType = TimeTypeBeginTime;
            self.endTimeText.textColor = [UIColor br_labelColor];
            self.endTimeView.backgroundColor = [UIColor lightGrayColor];
            self.beginTimeText.textColor = kThemeColor;
            self.beginTimeView.backgroundColor = kThemeColor;
            
            NSString *format = @"yyyy-MM-dd";
            if (self.pickerView.pickerMode == DatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.pickerView.pickerMode == DatePickerModeYMDH) {
                format = @"yyyy-MM-dd HH";
            }
            
            if (self.beginTimeText.text.length == 0) {
                self.beginTimeText.text = [NSDate br_getDateString:[NSDate date] format:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.beginTimeTF.text;
            self.pickerView.selectDate = self.beginSelectDate;
        }
            break;
            
        case 101:
        {
            NSLog(@"点击了结束时间:%@", self.endTimeText.text);
            self.timeType = TimeTypeEndTime;
            self.beginTimeText.textColor = [UIColor br_labelColor];
            self.beginTimeView.backgroundColor = [UIColor lightGrayColor];
            self.endTimeText.textColor = kThemeColor;
            self.endTimeView.backgroundColor = kThemeColor;
            
            NSString *format = @"yyyy-MM-dd";
            if (self.pickerView.pickerMode == DatePickerModeYM) {
                format = @"yyyy-MM";
            } else if (self.pickerView.pickerMode == DatePickerModeYMDH) {
                format = @"yyyy-MM-dd HH";
            }
            if (self.endTimeText.text.length == 0) {
                self.endTimeText.text = [NSDate br_getDateString:[NSDate date] format:format];
            }
            // 设置选择器滚动到指定的日期
            //self.datePickerView.selectValue = self.endTimeTF.text;
            self.pickerView.selectDate = self.endSelectDate;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - footerView
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // 1.切换日期选择器的显示模式
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"年月日时", @"年月日", @"年月"]];
        segmentedControl.frame = CGRectMake(40, 50, SCREEN_WIDTH - 80, 36);
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // 设置圆角和边框
        segmentedControl.layer.cornerRadius = 3.0f;
        segmentedControl.layer.masksToBounds = YES;
        segmentedControl.layer.borderWidth = 0.8f;
        segmentedControl.layer.borderColor = kThemeColor.CGColor;
        // 设置背景图片颜色
        [segmentedControl setBackgroundImage:[UIImage br_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setBackgroundImage:[UIImage br_imageWithColor:kThemeColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        // 设置标题颜色
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColor, NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} forState:UIControlStateSelected];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(pickerModeSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        [_footerView addSubview:segmentedControl];
        
        
        // 2.开始时间label
        UITextField *beginTimeTF = [self getTextField:CGRectMake(SCREEN_WIDTH / 2 - 120 - 15, 110, 120, 36) placeholder:@"开始时间"];
        beginTimeTF.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        beginTimeTF.tag = 100;
        beginTimeTF.textColor = [UIColor br_labelColor];
        self.beginTimeText = beginTimeTF;
        [_footerView addSubview:beginTimeTF];

        UIView *beginTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 120 - 15, 146, 120, 0.8f)];
        beginTimeLineView.backgroundColor = [UIColor lightGrayColor];
        beginTimeLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:beginTimeLineView];
        self.beginTimeView = beginTimeLineView;

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 110, 30, 36)];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"至";
        [_footerView addSubview:label];

        // 结束时间label
        UITextField *endTimeTF = [self getTextField:CGRectMake(SCREEN_WIDTH / 2 + 15, 110, 120, 36) placeholder:@"结束时间"];
        endTimeTF.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        endTimeTF.tag = 101;
        endTimeTF.textColor = [UIColor br_labelColor];
        self.endTimeText = endTimeTF;
        [_footerView addSubview:endTimeTF];
        
        UIView *endTimeLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 15, 146, 120, 0.8f)];
        endTimeLineView.backgroundColor = [UIColor lightGrayColor];
        endTimeLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:endTimeLineView];
        self.endTimeView = endTimeLineView;
        
        
        // 3.创建选择器容器视图
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(30, 170, _footerView.frame.size.width - 60, 200)];
        if (@available(iOS 13.0, *)) {
            containerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        } else {
            containerView.backgroundColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
        }
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_footerView addSubview:containerView];
        
    
        // 4.创建日期选择器
        PickerView *datePickerView = [[PickerView alloc]init];
        datePickerView.pickerMode = DatePickerModeYMDH;
        datePickerView.maxDate = [NSDate date];
        datePickerView.isAutoSelect = YES;
        datePickerView.showUnitType = ShowUnitTypeOnlyCenter;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            if (self.timeType == TimeTypeBeginTime) {
                self.beginSelectDate = selectDate;
                self.beginTimeText.text = selectValue;
            } else if (self.timeType == TimeTypeEndTime) {
                self.endSelectDate = selectDate;
                self.endTimeText.text = selectValue;
            }
        };
        
        // 自定义选择器主题样式
        PickerStyle *customStyle = [[PickerStyle alloc]init];
        customStyle.pickerColor = containerView.backgroundColor;
        datePickerView.pickerStyle = customStyle;
        self.pickerView = datePickerView;
        
        // 添加选择器到容器视图
        [datePickerView addPickerToView:containerView];
        
    }
    return _footerView;
}

#pragma mark - 切换日期显示模式
- (void)pickerModeSegmentedControlAction:(UISegmentedControl *)sender {
    NSInteger selecIndex = sender.selectedSegmentIndex;
    if (selecIndex == 0) {
        NSLog(@"年月日时");
        self.pickerView.pickerMode = DatePickerModeYMDH;
    } else if (selecIndex == 1) {
        NSLog(@"年月日");
        self.pickerView.pickerMode = DatePickerModeYMD;
    } else if (selecIndex == 2) {
        NSLog(@"年月");
        self.pickerView.pickerMode = DatePickerModeYM;
    }
    
    // 重置选择的值
    self.pickerView.selectDate = nil;
    self.beginTimeText.text = nil;
    self.endTimeText.text = nil;
    self.beginTimeView.backgroundColor = [UIColor lightGrayColor];
    self.endTimeView.backgroundColor = [UIColor lightGrayColor];
    self.timeType = TimeTypeBeginTime;
}

- (UITextField *)getTextField:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.backgroundColor = [UIColor br_systemBackgroundColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor br_labelColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.placeholder = placeholder;
    textField.delegate = self;

    return textField;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"姓名", @"性别", @"出生年月", @"出生时刻", @"联系方式", @"地址", @"学历", @"融资（传模型数组）", @"多列字符串"];
    }
    return _titleArray;
}

- (InfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[InfoModel alloc]init];
    }
    return _infoModel;
}

- (NSArray<NSNumber *> *)addressSelectIndexs {
    if (!_addressSelectIndexs) {
        _addressSelectIndexs = [NSArray array];
    }
    return _addressSelectIndexs;
}

- (NSArray<NSNumber *> *)otherSelectIndexs {
    if (!_otherSelectIndexs) {
        _otherSelectIndexs = [NSArray array];
    }
    return _otherSelectIndexs;
}
@end
