//
//  AddressPickerView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/21.
//

#import "AddressPickerView.h"
#import "NSBundle+PickerView.h"

@interface AddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

//地址选择器
@property (nonatomic, strong) UIPickerView *pickerView;
//省模型数组
@property (nonatomic, copy) NSArray *provinceModelArr;
//市模型数组
@property (nonatomic, copy) NSArray *cityModelArr;
//区模型数组
@property (nonatomic, copy) NSArray *areaModelArr;
//选中的省
@property (nonatomic, strong) ProvinceModel *selectProvinceModel;
//选中的市
@property (nonatomic, strong) CityModel *selectCityModel;
//选中的区
@property (nonatomic, strong) AreaModel *selectAreaModel;
//记录省选中的位置
@property (nonatomic, assign) NSInteger provinceIndex;
//记录市选中的位置
@property (nonatomic, assign) NSInteger cityIndex;
//记录区选中的位置
@property (nonatomic, assign) NSInteger areaIndex;

@property (nonatomic, copy) NSArray <NSString *>* mSelectValues;

@end

@implementation AddressPickerView

#pragma mark -1.显示地址选择器
+ (void)showAddressPickerWithSelectIndexs:(NSArray<NSNumber *> *)selectIndexs resultBlock:(AddResultBlock)resultBlock {
    [self showAddressPickerWithMode:AddressPickerModeArea dataSource:nil selectIndexs:selectIndexs isAutoSelect:NO resultBlock:resultBlock];
}

+ (void)showAddressPickerWithMode:(AddressPickerMode)mode selectIndexs:(NSArray<NSNumber *> *)selectIndexs isAutoSelect:(BOOL)isAutoSelect resultBlock:(AddResultBlock)resultBlock {
    [self showAddressPickerWithMode:mode dataSource:nil selectIndexs:selectIndexs isAutoSelect:isAutoSelect resultBlock:resultBlock];
}

+ (void)showAddressPickerWithMode:(AddressPickerMode)mode dataSource:(NSArray *)dataSource selectIndexs:(NSArray<NSNumber *> *)selectIndexs isAutoSelect:(BOOL)isAutoSelect resultBlock:(AddResultBlock)resultBlock {
    AddressPickerView *addressPicker = [[AddressPickerView alloc]initWithPickerMode:mode];
    addressPicker.dataSourceArr = dataSource;
    addressPicker.selectIndexs = selectIndexs;
    addressPicker.isAutoSelect = isAutoSelect;
    addressPicker.resultBlock = resultBlock;
    //显示
    [addressPicker show];
}

#pragma mark -初始化地址选择器
- (instancetype)initWithPickerMode:(AddressPickerMode)pickerMode {
    if (self = [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark -处理选择器数据
- (void)handlerPickerData {
    if (self.dataSourceArr && self.dataSourceArr.count > 0) {
        id element = [self.dataSourceArr firstObject];
        //如果传的值是解析好的模型数据
        if ([element isKindOfClass:[ProvinceModel class]]) {
            self.provinceModelArr = self.dataSourceArr;
        } else {
            self.provinceModelArr = [self getProvinceModelArr: self.dataSourceArr];
        }
    } else {
        //如果外部没有传入地区数据源，就用本地的数据源
        NSArray *dataSource = [NSBundle br_addressJsonArray];
        if (!dataSource || dataSource.count == 0) {
            return;
        }
        self.dataSourceArr = dataSource;
        self.provinceModelArr = [self getProvinceModelArr:self.dataSourceArr];
    }
    [self handlerDefaultSelectValue];
}

#pragma mark -获取模型数据
- (NSArray <ProvinceModel *>*)getProvinceModelArr: (NSArray *)dataSourceArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *proviceDic in dataSourceArr) {
        ProvinceModel *proViceModel = [[ProvinceModel alloc]init];
        proViceModel.code = [proviceDic objectForKey:@"code"];
        proViceModel.name = [proviceDic objectForKey:@"name"];
        proViceModel.index = [dataSourceArr indexOfObject: proviceDic];
        NSArray *cityList = [proviceDic.allKeys containsObject:@"cityList"] ? [proviceDic objectForKey:@"cityList"] : [proviceDic objectForKey:@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in cityList) {
            CityModel *cityModel = [[CityModel alloc]init];
            cityModel.code = [cityDic objectForKey:@"code"];
            cityModel.name = [cityDic objectForKey:@"name"];
            cityModel.index = [cityList indexOfObject:cityDic];
            NSArray *areaList = [cityDic.allKeys containsObject:@"areaList"] ? [cityDic objectForKey:@"areaList"] : [cityDic objectForKey:@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in areaList) {
                AreaModel *areaModel = [[AreaModel alloc]init];
                areaModel.code = [areaDic objectForKey:@"code"];
                areaModel.name = [areaDic objectForKey:@"name"];
                areaModel.index = [areaList indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proViceModel.citylist = [tempArr2 copy];
        [tempArr addObject:proViceModel];
    }
    return [tempArr copy];
}

#pragma mark -设置默认选择的值
- (void)handlerDefaultSelectValue {
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;

    if (self.mSelectValues.count > 0) {
        selectProvinceName = self.mSelectValues.count > 0 ? self.mSelectValues[0] : nil;
        selectCityName = self.mSelectValues.count > 1 ? self.mSelectValues[1] : nil;
        selectAreaName = self.mSelectValues.count > 2 ? self.mSelectValues[2] : nil;
    }

    if (self.pickerMode == AddressPickerModeProvince || self.pickerMode == AddressPickerModeCity || self.pickerMode == AddressPickerModeArea) {
        if (self.selectIndexs.count > 0) {
            NSInteger provinceIndex = [self.selectIndexs[0] integerValue];
            self.provinceIndex = (provinceIndex > 0 && provinceIndex < self.provinceModelArr.count) ? provinceIndex : 0;
            self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
        } else {
            self.provinceIndex = 0;
            self.selectProvinceModel = self.provinceModelArr.count > 0 ? self.provinceModelArr[0] : nil;
            @weakify(self)
            [self.provinceModelArr enumerateObjectsUsingBlock:^(ProvinceModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self)
                if (selectProvinceName && [model.name isEqualToString:selectProvinceName]) {
                    self.provinceIndex = idx;
                    self.selectProvinceModel = model;
                    *stop = YES;
                }
            }];
        }
    }

    if (self.pickerMode == AddressPickerModeCity || self.pickerMode == AddressPickerModeArea) {
        self.cityModelArr = [self getCityModelArray:self.provinceIndex];
        if (self.selectIndexs.count > 0) {
            NSInteger cityIndex = self.selectIndexs.count > 1 ? [self.selectIndexs[1] integerValue] : 0;
            self.cityIndex = (cityIndex > 0 && cityIndex < self.cityModelArr.count) ? cityIndex : 0;
            self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
        } else {
            self.cityIndex = 0;
            self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
            @weakify(self)
            [self.cityModelArr enumerateObjectsUsingBlock:^(CityModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self)
                if (selectCityName && [model.name isEqualToString:selectCityName]) {
                    self.cityIndex = idx;
                    self.selectCityModel = model;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (self.pickerMode == AddressPickerModeArea) {
        self.areaModelArr = [self getAreaModelArray: self.provinceIndex cityIndex: self.cityIndex];
        if (self.selectIndexs.count > 0) {
            NSInteger areaIndex = self.selectIndexs.count > 2 ? [self.selectIndexs[2] integerValue] : 0;
            self.areaIndex = (areaIndex > 0 && areaIndex < self.areaModelArr.count) ? areaIndex : 0;
            self.selectAreaModel = self.areaModelArr.count > self.areaIndex ? self.areaModelArr[self.areaIndex] : nil;
        } else {
            self.areaIndex = 0;
            self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            @weakify(self)
            [self.areaModelArr enumerateObjectsUsingBlock:^(AreaModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self)
                if (selectAreaName && [model.name isEqualToString:selectAreaName]) {
                    self.areaIndex = idx;
                    self.selectAreaModel = model;
                    *stop = YES;
                }
            }];
        }
    }
}

// 根据 省索引 获取 城市模型数组
- (NSArray *)getCityModelArray:(NSInteger)provinceIndex {
    ProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    // 返回城市模型数组
    return provinceModel.citylist;
}

// 根据 省索引和城市索引 获取 区域模型数组
- (NSArray *)getAreaModelArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    ProvinceModel *provinceModel = self.provinceModelArr[provinceIndex];
    if (provinceModel.citylist && provinceModel.citylist.count > 0) {
        CityModel *cityModel = provinceModel.citylist[cityIndex];
        // 返回地区模型数组
        return cityModel.arealist;
    } else {
        return nil;
    }
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.pickerStyle.titleBarHeight + pickerHeaderViewHeight, SCREEN_WIDTH, self.pickerStyle.pickerHeight)];
        _pickerView.backgroundColor = self.pickerStyle.pickerColor;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.设置 pickerView 的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.pickerMode) {
        case AddressPickerModeProvince:
            return 1;
            break;
        case AddressPickerModeCity:
            return 2;
            break;
        case AddressPickerModeArea:
            return 3;
            break;
        default:
            break;
    }
}

// 2.设置 pickerView 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        // 返回省个数
        return self.provinceModelArr.count;
    }
    if (component == 1) {
        // 返回市个数
        return self.cityModelArr.count;
    }
    if (component == 2) {
        // 返回区个数
        return self.areaModelArr.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 1.自定义 row 的内容视图
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.pickerStyle.pickerTextFont;
        label.textColor = self.pickerStyle.pickerTextColor;
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    if (component == 0) {
        ProvinceModel *model = self.provinceModelArr[row];
        label.text = model.name;
    } else if (component == 1) {
        CityModel *model = self.cityModelArr[row];
        label.text = model.name;
    } else if (component == 2) {
        AreaModel *model = self.areaModelArr[row];
        label.text = model.name;
    }
    
    // 2.设置选择器中间选中行的样式
    [self setPickerSelectRowStyle:pickerView titleForRow:row forComponent:component];
    
    return label;
}

#pragma mark - 设置选择器中间选中行的样式
- (void)setPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 1.设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }

    // 2.设置选择器中间选中行的背景颜色
    if (self.pickerStyle.selectRowColor) {
        UIView *contentView = nil;
        NSArray *subviews = pickerView.subviews;
        if (subviews.count > 0) {
            id obj = subviews.firstObject;
            if (obj && [obj isKindOfClass:[UIView class]]) {
                contentView = (UIView *)obj;
            }
        }
        UIView *columnView = nil;
        if (contentView) {
            id obj = [contentView valueForKey:@"subviewCache"];
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                NSArray *columnViews = (NSArray *)obj;
                if (columnViews.count > 0) {
                    id columnObj = columnViews.firstObject;
                    if (columnObj && [columnObj isKindOfClass:[UIView class]]) {
                        columnView = (UIView *)columnObj;
                    }
                }
            }
        }
        if (columnView) {
            id obj = [columnView valueForKey:@"middleContainerView"];
            if (obj && [obj isKindOfClass:[UIView class]]) {
                UIView *selectRowView = (UIView *)obj;
                selectRowView.backgroundColor = self.pickerStyle.selectRowColor;
            }
        }
    }

    // 3.设置选择器中间选中行的字体颜色/字体大小
    if (self.pickerStyle.selectRowTextColor || self.pickerStyle.selectRowTextFont) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 当前选中的 label
            UILabel *selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
            if (selectLabel) {
                if (self.pickerStyle.selectRowTextColor) {
                    selectLabel.textColor = self.pickerStyle.selectRowTextColor;
                }
                if (self.pickerStyle.selectRowTextFont) {
                    selectLabel.font = self.pickerStyle.selectRowTextFont;
                }
                // 上一个选中的 label
                UILabel *lastLabel = (UILabel *)[pickerView viewForRow:row - 1 forComponent:component];
                if (lastLabel) {
                    lastLabel.textColor = self.pickerStyle.pickerTextColor;
                    lastLabel.font = self.pickerStyle.pickerTextFont;
                }
                // 下一个选中的 label
                UILabel *nextLabel = (UILabel*)[pickerView viewForRow:row + 1 forComponent:component];
                if (nextLabel) {
                    nextLabel.textColor = self.pickerStyle.pickerTextColor;
                    nextLabel.font = self.pickerStyle.pickerTextFont;
                }
            }
        });
    }
}

// 4.滚动 pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        // 保存选择的省份的索引
        self.provinceIndex = row;
        switch (self.pickerMode) {
            case AddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
            }
                break;
            case AddressPickerModeCity:
            {
                self.cityModelArr = [self getCityModelArray:self.provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
                self.selectAreaModel = nil;
            }
                break;
            case AddressPickerModeArea:
            {
                self.cityModelArr = [self getCityModelArray:self.provinceIndex];
                self.areaModelArr = [self getAreaModelArray:self.provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceModelArr.count > self.provinceIndex ? self.provinceModelArr[self.provinceIndex] : nil;
                self.selectCityModel = self.cityModelArr.count > 0 ? self.cityModelArr[0] : nil;
                self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        self.cityIndex = row;
        switch (self.pickerMode) {
            case AddressPickerModeCity:
            {
                self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
                self.selectAreaModel = nil;
            }
                break;
            case AddressPickerModeArea:
            {
                self.areaModelArr = [self getAreaModelArray:self.provinceIndex cityIndex:self.cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityModelArr.count > self.cityIndex ? self.cityModelArr[self.cityIndex] : nil;
                self.selectAreaModel = self.areaModelArr.count > 0 ? self.areaModelArr[0] : nil;
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        self.areaIndex = row;
        if (self.pickerMode == AddressPickerModeArea) {
            self.selectAreaModel = self.areaModelArr.count > self.areaIndex ? self.areaModelArr[self.areaIndex] : nil;
        }
    }
    
    // 滚动选择时执行 changeBlock
    if (self.changeBlock) {
        self.changeBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
    }
    
    // 设置自动选择时，滚动选择时就执行 resultBlock
    if (self.isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

#pragma mark - 重写父类方法
- (void)reloadData {
    // 1.处理数据源
    [self handlerPickerData];
    // 2.刷新选择器
    [self.pickerView reloadAllComponents];
    // 3.滚动到选择的地区
    if (self.pickerMode == AddressPickerModeProvince) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
    } else if (self.pickerMode == AddressPickerModeCity) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
    } else if (self.pickerMode == AddressPickerModeArea) {
        [self.pickerView selectRow:self.provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:self.areaIndex inComponent:2 animated:YES];
    }
}

- (void)addPickerToView:(UIView *)view {
    // 1.添加地址选择器
    if (view) {
        // 立即刷新容器视图 view 的布局（防止 view 使用自动布局时，选择器视图无法正常显示）
        [view setNeedsLayout];
        [view layoutIfNeeded];
        
        self.frame = view.bounds;
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        CGFloat pickerFooterViewHeight = self.pickerFooterView ? self.pickerFooterView.bounds.size.height : 0;
        self.pickerView.frame = CGRectMake(0, pickerHeaderViewHeight, view.bounds.size.width, view.bounds.size.height - pickerHeaderViewHeight - pickerFooterViewHeight);
        [self addSubview:self.pickerView];
    } else {
        [self.alertView addSubview:self.pickerView];
    }
    
    // 2.绑定数据
    [self reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.doneBlock = ^{
        // 点击确定按钮后，执行block回调
        [weakSelf removePickerFromView:view];
        
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(weakSelf.selectProvinceModel, weakSelf.selectCityModel, weakSelf.selectAreaModel);
        }
    };
    
    [super addPickerToView:view];
}

#pragma mark - 重写父类方法
- (void)addSubViewToPicker:(UIView *)customView {
    [self.pickerView addSubview:customView];
}

#pragma mark - 弹出选择器视图
- (void)show {
    [self addPickerToView:nil];
}

#pragma mark - 关闭选择器视图
- (void)dismiss {
    [self removePickerFromView:nil];
}

#pragma mark - setter方法
- (void)setSelectValues:(NSArray<NSString *> *)selectValues {
    self.mSelectValues = selectValues;
}

#pragma mark - getter方法
- (NSArray *)provinceModelArr {
    if (!_provinceModelArr) {
        _provinceModelArr = [NSArray array];
    }
    return _provinceModelArr;
}

- (NSArray *)cityModelArr {
    if (!_cityModelArr) {
        _cityModelArr = [NSArray array];
    }
    return _cityModelArr;
}

- (NSArray *)areaModelArr {
    if (!_areaModelArr) {
        _areaModelArr = [NSArray array];
    }
    return _areaModelArr;
}

- (ProvinceModel *)selectProvinceModel {
    if (!_selectProvinceModel) {
        _selectProvinceModel = [[ProvinceModel alloc]init];
    }
    return _selectProvinceModel;
}

- (CityModel *)selectCityModel {
    if (!_selectCityModel) {
        _selectCityModel = [[CityModel alloc]init];
        _selectCityModel.code = @"";
        _selectCityModel.name = @"";
    }
    return _selectCityModel;
}

- (AreaModel *)selectAreaModel {
    if (!_selectAreaModel) {
        _selectAreaModel = [[AreaModel alloc]init];
        _selectAreaModel.code = @"";
        _selectAreaModel.name = @"";
    }
    return _selectAreaModel;
}

- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSArray<NSString *> *)mSelectValues {
    if (!_mSelectValues) {
        _mSelectValues = [NSArray array];
    }
    return _mSelectValues;
}

- (NSArray<NSNumber *> *)selectIndexs {
    if (!_selectIndexs) {
        _selectIndexs = [NSArray array];
    }
    return _selectIndexs;
}
@end
