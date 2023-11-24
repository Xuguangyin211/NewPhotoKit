//
//  StringPickerView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import "StringPickerView.h"

@interface StringPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    BOOL _invalidDataSource;
    //数据源格式是否有误
}

//字符串选择器
@property (nonatomic, strong) UIPickerView *pickerView;
//单列选择的值
@property (nonatomic, copy) NSString *mSelectValue;
//多列选择的值
@property (nonatomic, copy) NSArray <NSString *>* mSelectValues;

@end

@implementation StringPickerView

+ (void)showPickerWithTitle:(NSString *)title dataSourceArr:(NSArray *)dataSourceArr selectIndex:(NSInteger)selectIndex resultBlock:(StringResultModeBlock)resultBlock {
    [self showPickerWithTitle:title dataSourceArr:dataSourceArr selectIndex:selectIndex isAutoSelect:NO resultBlock:resultBlock];
}

+ (void)showPickerWithTitle:(NSString *)title dataSourceArr:(NSArray *)dataSourceArr selectIndex:(NSInteger)selectIndex isAutoSelect:(BOOL)isAutoSelect resultBlock:(StringResultModeBlock)resultBlock {
    StringPickerView *strPickerView = [[StringPickerView alloc]init];
    strPickerView.pickerMode = StringPickerModeComponentSingle;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndex = selectIndex;
    strPickerView.isAutoSelect = isAutoSelect;

    [strPickerView show];
}

+ (void)showMultiPickerWithTitle:(NSString *)title dataSourceArr:(NSArray *)dataSourceArr selectIndex:(NSArray<NSNumber *> *)selectIndexs resultBlock:(StringResultModelArrayBlock)resultBlock {
    [self showMultiPickerWithTitle:title dataSourceArr:dataSourceArr selectIndex:selectIndexs isAutoSelect:NO resultBlock:resultBlock];
}

+ (void)showMultiPickerWithTitle:(NSString *)title dataSourceArr:(NSArray *)dataSourceArr selectIndex:(NSArray<NSNumber *> *)selectIndexs isAutoSelect:(BOOL)isAutoSelect resultBlock:(StringResultModelArrayBlock)resultBlock {
    StringPickerView *strPickerView = [[StringPickerView alloc]init];
    strPickerView.pickerMode = StringPickerModeComponentMulti;
    strPickerView.title = title;
    strPickerView.dataSourceArr = dataSourceArr;
    strPickerView.selectIndexs = selectIndexs;
    strPickerView.isAutoSelect = isAutoSelect;
    strPickerView.resultModelArrayBlock = resultBlock;

    [strPickerView show];
}

#pragma mark -初始化自定义字符串选择器
- (instancetype)initwithPickerMode:(StringPickerMode)pickerMode {
    if (self == [super init]) {
        self.pickerMode = pickerMode;
    }
    return self;
}

#pragma mark -处理选择器数据
- (void)handlerPickerData {
    if (self.dataSourceArr.count == 0) {
        _invalidDataSource = YES;
    }
    if (self.pickerMode == StringPickerModeComponentSingle) {
        id element = [self.dataSourceArr firstObject];
        if ([element isKindOfClass:[NSArray class]]) {
            _invalidDataSource = YES;
        }
    } else if (self.pickerMode == StringPickerModeComponentMulti) {
        id element = [self.dataSourceArr firstObject];
        if ([element isKindOfClass:[NSString class]]) {
            _invalidDataSource = YES;
        }
    }

    if (_invalidDataSource) {
        NSAssert(!_invalidDataSource, @"无效数据源！请检查字符串选择器数据源的格式");
        return;
    }

    //处理选择器当前选择的值
    if (self.pickerMode == StringPickerModeComponentSingle) {
        if (self.selectIndex > 0) {
            self.selectIndex = (self.selectIndex < self.dataSourceArr.count ? self.selectIndex : 0);
        } else {
            if (self.mSelectValue && [self.dataSourceArr containsObject: self.mSelectValue]) {
                self.selectIndex = [self.dataSourceArr indexOfObject:self.mSelectValue];
            } else {
                self.selectIndex = 0;
            }
        }
    } else if (self.pickerMode == StringPickerModeComponentMulti) {
        NSMutableArray *mSelectIndexs = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
            NSInteger row = 0;
            if (self.selectIndexs.count > 0) {
                if (i < self.selectIndexs.count) {
                    NSInteger index = [self.selectIndexs[i] integerValue];
                    row = ((index > 0 && index < [self.dataSourceArr[i] count]) ? index : 0);
                }
            } else {
                if (self.mSelectValues.count > 0 && i < self.mSelectValues.count) {
                    NSString *value = self.mSelectValues[i];
                    if ([self.dataSourceArr[i] containsObject:value]) {
                        row = [self.dataSourceArr[i] indexOfObject: value];
                    }
                }
            }
            [mSelectIndexs addObject:@(row)];
        }
        self.selectIndexs = [mSelectIndexs copy];
    }
}

#pragma mark -字符串选择器
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.pickerMode) {
        case StringPickerModeComponentSingle:
            return 1;
            break;
        case StringPickerModeComponentMulti:
            return self.dataSourceArr.count;
            break;
        default:
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case StringPickerModeComponentSingle:
            return self.dataSourceArr.count;
            break;
        case StringPickerModeComponentMulti:
            return [self.dataSourceArr[component] count];
        default:
            break;
    }
}

#pragma mark - UIPickerViewwDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //自定义row的内容视图
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.pickerStyle.pickerTextColor;
        label.font = self.pickerStyle.pickerTextFont;
        //字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        //自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    if (self.pickerMode == StringPickerModeComponentSingle) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerStyle.rowHeight);
        id element = self.dataSourceArr[row];
        if ([element isKindOfClass:[ResultModel  class]]) {
            ResultModel *model = (ResultModel *)element;
            label.text = model.value;
        } else {
            label.text = element;
        }
    } else if (self.pickerMode == StringPickerModeComponentMulti) {
        label.frame = CGRectMake(0, 0, self.pickerView.frame.size.width / pickerView.numberOfComponents, self.pickerStyle.rowHeight);
        id element = self.dataSourceArr[component][row];
        if ([element isKindOfClass: [ResultModel class]]) {
            ResultModel *model = (ResultModel *)element;
            label.text = model.value;
        } else {
            label.text = element;
        }
    }

    [self setPickerSelectRowStyle: pickerView titleForRow: row forComponent: component];
    return label;
}

#pragma mark -设置选择器中间选中行的样式
- (void)setPickerSelectRowStyle: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component {
    //1.设置分割线的颜色
    for (UIView *subView in pickerView.subviews) {
        if (subView && [subView isKindOfClass:[UIView class]] && subView.frame.size.height <= 1) {
            subView.backgroundColor = self.pickerStyle.separatorColor;
        }
    }

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

    //3.设置选择器中间选中行的字体颜色/字体大小
    if (self.pickerStyle.selectRowTextColor || self.pickerStyle.selectRowTextFont) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //当前选中的label
            UILabel *selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
            if (selectLabel) {
                if (self.pickerStyle.selectRowTextColor) {
                    selectLabel.textColor = self.pickerStyle.selectRowTextColor;
                }
                if (self.pickerStyle.selectRowTextFont) {
                    selectLabel.font = self.pickerStyle.selectRowTextFont;
                }
                //上一个选中的label
                UILabel *lastLabel = (UILabel *)[pickerView viewForRow:row - 1 forComponent:component];
                if (lastLabel) {
                    lastLabel.textColor = self.pickerStyle.pickerTextColor;
                    lastLabel.font = self.pickerStyle.pickerTextFont;
                }
                //下一个选中的label
                UILabel *nextLabel = (UILabel *)[pickerView viewForRow:row + 1 forComponent:component];
                if (nextLabel) {
                    nextLabel.textColor = self.pickerStyle.pickerTextColor;
                    nextLabel.font = self.pickerStyle.pickerTextFont;
                }
            }
        });
    }
}

//滚动pickerView 执行的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.pickerMode) {
        case StringPickerModeComponentSingle:
        {
            self.selectIndex = row;
            //滚动选择时执行changeModelBlock
            if (self.changeModelBlock) {
                self.changeModelBlock([self getResultModel]);
            }

            //设置自动选择时，滚动选择时就执行
            if (self.isAutoSelect) {
                if (self.resultModelBlock) {
                    self.resultModelBlock([self getResultModel]);
                }
            }
        }
            break;
        case StringPickerModeComponentMulti:
        {
            if (component < self.selectIndexs.count) {
                NSMutableArray *mutableArr = [self.selectIndexs mutableCopy];
                [mutableArr replaceObjectAtIndex:component withObject:@(row)];
                self.selectIndexs = [mutableArr copy];
            }
            //滚动选择时执行changeModelArraylock
            if (self.changeModelArrayBlock) {
                self.changeModelArrayBlock([self getResultModelArr]);
            }
            // 设置自动选择时，滚动选择时就执行 resultModelArrayBlock
            if (self.isAutoSelect) {
                if (self.resultModelArrayBlock) {
                    self.resultModelArrayBlock([self getResultModelArr]);
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取【单列】选择器选择的值
- (ResultModel *)getResultModel {
    id element = self.selectIndex < self.dataSourceArr.count ? self.dataSourceArr[self.selectIndex] : nil;
    if ([element isKindOfClass:[ResultModel class]]) {
        ResultModel *model = (ResultModel *)element;
        model.index = self.selectIndex;
        return model;
    } else {
        ResultModel *model = [[ResultModel alloc]init];
        model.index = self.selectIndex;
        model.value = element;
        return model;
    }
}

#pragma mark - 获取【多列】选择器选择的值
- (NSArray *)getResultModelArr {
    NSMutableArray *resultModelArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
        NSInteger index = [self.selectIndexs[i] integerValue];
        NSArray *dataArr = self.dataSourceArr[i];
        
        id element = index < dataArr.count ? dataArr[index] : nil;
        if ([element isKindOfClass:[ResultModel class]]) {
            ResultModel *model = (ResultModel *)element;
            model.index = index;
            [resultModelArr addObject:model];
        } else {
            ResultModel *model = [[ResultModel alloc]init];
            model.index = index;
            model.value = element;
            [resultModelArr addObject:model];
        }
    }
    return [resultModelArr copy];
}

//设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.pickerStyle.rowHeight;
}

#pragma mark - 重写父类方法
- (void)reloadData {
    [self handlerPickerData];
    //刷新选择器
    [self.pickerView reloadAllComponents];
    //滚动到选择的值
    if (self.pickerMode == StringPickerModeComponentSingle) {
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:NO];
    } else if (self.pickerMode == StringPickerModeComponentMulti) {
        for (NSInteger i = 0; i < self.selectIndexs.count; i++) {
            NSNumber *index = [self.selectIndexs objectAtIndex:i];
            [self.pickerView selectRow:[index integerValue] inComponent:i animated:NO];
        }
    }
}

- (void)addPickerToView:(UIView *)view {
    //添加字符串选择器
    if (view) {
        //立即刷新容器视图view的布局
        [view setNeedsLayout];
        [view layoutIfNeeded];

        self.frame = view.bounds;
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        CGFloat pickerFooterViewHeight = self.pickerFooterView ? self.pickerFooterView.bounds.size.height : 0;
        self.pickerView.frame = CGRectMake(0, pickerFooterViewHeight, view.bounds.size.width, view.bounds.size.height - pickerHeaderViewHeight - pickerFooterViewHeight);
        [self addSubview:self.pickerView];
    } else {
        [self.alertView addSubview:self.pickerView];
    }

    //绑定数据
    [self reloadData];

    @weakify(self)
    self.doneBlock = ^{
        @strongify(self)
        //点击确定按钮后，执行block回调
        [self removePickerFromView:view];

        if (self.pickerMode == StringPickerModeComponentSingle) {
            if (self.resultModelBlock) {
                self.resultModelBlock([self getResultModel]);
            }
        } else if (self.pickerMode == StringPickerModeComponentMulti) {
            if (self.resultModelArrayBlock) {
                self.resultModelArrayBlock([self getResultModelArr]);
            }
        }
    };
    [super addPickerToView:view];
}

#pragma mark -重写父类方法
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
- (void)setPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle]pathForResource:plistName ofType:nil];
    if (path && path.length > 0) {
        self.dataSourceArr = [[NSArray alloc]initWithContentsOfFile:path];
    }
}

- (void)setSelectValue:(NSString *)selectValue {
    self.mSelectValue = selectValue;
}

- (void)setSelectValues:(NSArray<NSString *> *)selectValues {
    self.mSelectValues = selectValues;
}

#pragma mark - getter方法
- (NSArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSArray array];
    }
    return _dataSourceArr;
}

- (NSArray<NSNumber *> *)selectIndexs {
    if (!_selectIndexs) {
        _selectIndexs = [NSArray array];
    }
    return _selectIndexs;
}

- (NSArray<NSString *> *)mSelectValues {
    if (!_mSelectValues) {
        _mSelectValues = [NSArray array];
    }
    return _mSelectValues;
}

@end
