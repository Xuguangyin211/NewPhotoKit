//
//  PickerView+BR.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import "PickerView+BR.h"
#import "NSBundle+PickerView.h"

//SYNC_DUMMY_CLASS(DatePickerView_BR)

@implementation PickerView (BR)

#pragma mark - 最小日期
- (NSDate *)handlerMinDate:(nullable NSDate *)minDate {
    if (!minDate) {
        if (self.pickerMode == DatePickerModeMDHM) {
            minDate = [NSDate br_setMonth:1 day:1 hour:0 minute:0];
        } else if (self.pickerMode == DatePickerModeMD) {
            minDate = [NSDate br_setMonth:1 day:1];
        } else if (self.pickerMode == DatePickerModeTime || self.pickerMode == DatePickerModeCountDownTimer|| self.pickerMode == DatePickerModeHM) {
            minDate = [NSDate br_setHour:0 minute:0];
        } else if (self.pickerMode == DatePickerModeHMS) {
            minDate = [NSDate br_setHour:0 minute:0 second:0];
        } else if (self.pickerMode == DatePickerModeMS) {
            minDate = [NSDate br_setMinute:0 second:0];
        } else {
            minDate = [NSDate distantPast];
        }
    }
    return minDate;
}

#pragma mark - 最大日期
- (NSDate *)handlerMaxDate:(NSDate *)maxDate {
    if (!maxDate) {
        if (self.pickerMode == DatePickerModeMDHM) {
            maxDate = [NSDate br_setMonth:12 day:31 hour:23 minute:59];
        } else if (self.pickerMode == DatePickerModeMD) {
            maxDate = [NSDate br_setMonth:12 day:31];
        } else if (self.pickerMode == DatePickerModeTime || self.pickerMode == DatePickerModeCountDownTimer || self.pickerMode == DatePickerModeHM) {
            maxDate = [NSDate br_setHour:23 minute:59];
        } else if (self.pickerMode == DatePickerModeHMS) {
            maxDate = [NSDate br_setHour:23 minute:59 second:59];
        } else if (self.pickerMode == DatePickerModeMS) {
            maxDate = [NSDate br_setMinute:59 second:59];
        } else {
            maxDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
        }
    }
    return maxDate;
}

#pragma mark - 默认选中的日期
- (NSDate *)handlerSelectDate:(NSDate *)selectDate dateFormat:(NSString *)dateFormat {
    // selectDate 优先级高于 selectValue（推荐使用 selectDate 设置默认选中的时间）
    if (!selectDate) {
        if (self.selectValue && self.selectValue.length > 0) {
            if (self.pickerMode == DatePickerModeYMDH && self.isShowAMAndPM) {
                NSString *firstString = [[self.selectValue componentsSeparatedByString:@" "] firstObject];
                NSString *lastString = [[self.selectValue componentsSeparatedByString:@" "] lastObject];
                if ([lastString isEqualToString:[self getAMText]]) {
                    self.selectValue = [NSString stringWithFormat:@"%@ 00", firstString];
                }
                if ([lastString isEqualToString:[self getPMText]]) {
                    self.selectValue = [NSString stringWithFormat:@"%@ 12", firstString];
                }
            }

            NSDate *date = ![self.selectValue isEqualToString:self.addCustomString] ? [self br_dateFromString:self.selectValue dateFormat:dateFormat] : [NSDate date];
            if (!date) {
                BRErrorLog(@"参数异常！字符串 selectValue 的正确格式是：%@", dateFormat);
                NSAssert(date, @"参数异常！请检查字符串 selectValue 的格式");
                date = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }

            if (self.pickerMode == DatePickerModeMDHM) {
                selectDate = [NSDate br_setMonth:date.br_month day:date.br_day hour:date.br_hour minute:date.br_minute];
            } else if (self.pickerMode == DatePickerModeMD) {
                selectDate = [NSDate br_setMonth:date.br_month day:date.br_day];
            } else if (self.pickerMode == DatePickerModeTime || self.pickerMode == DatePickerModeCountDownTimer || self.pickerMode == DatePickerModeHM) {
                selectDate = [NSDate br_setHour:date.br_hour minute:date.br_minute];
            } else if (self.pickerMode == DatePickerModeHMS) {
                selectDate = [NSDate br_setHour:date.br_hour minute:date.br_minute second:date.br_second];
            } else if (self.pickerMode == DatePickerModeMS) {
                selectDate = [NSDate br_setMinute:date.br_minute second:date.br_second];
            } else {
                selectDate = date;
            }
        } else {
            // 不设置默认日期，就默认选中今天的日期
            selectDate = [NSDate date];
        }
    }
    
    // 判断日期是否超过边界限制
    BOOL selectLessThanMin = [self br_compareDate:selectDate targetDate:self.minDate dateFormat:dateFormat] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self br_compareDate:selectDate targetDate:self.maxDate dateFormat:dateFormat] == NSOrderedDescending;
    if (selectLessThanMin) {
        BRErrorLog(@"默认选择的日期不能小于最小日期！");
        selectDate = self.minDate;
    }
    if (selectMoreThanMax) {
        BRErrorLog(@"默认选择的日期不能大于最大日期！");
        selectDate = self.maxDate;
    }
    return selectDate;
}

#pragma mark - NSDate 转 NSString
- (NSString *)br_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    return [date br_convertDateWithFormat:dateFormat timeZone:[self currentTimeZone] language:self.pickerStyle.language];
}

#pragma mark - NSString 转 NSDate
- (NSDate *)br_dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    dateFormatter.dateFormat = dateFormat;
    // 设置时区(默认不使用夏时制)
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:self.pickerStyle.language];
    // 如果当前时间不存在，就获取距离最近的整点时间
    dateFormatter.lenient = YES;

    return [dateFormatter dateFromString:dateString];
}

- (NSTimeZone *)currentTimeZone {
    if (!self.timeZone) {
        // 当前时区
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        // 当前时区相对于GMT(零时区)的偏移秒数
        NSInteger interval = [localTimeZone secondsFromGMTForDate:[NSDate date]];
        // 当前时区(不使用夏时制)：由偏移量获得对应的NSTimeZone对象
        // 注意：一些夏令时时间 NSString 转 NSDate 时，默认会导致 NSDateFormatter 格式化失败，返回 null
        return [NSTimeZone timeZoneForSecondsFromGMT:interval];
    }
    return self.timeZone;
}

#pragma mark - 比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
- (NSComparisonResult)br_compareDate:(NSDate *)date targetDate:(NSDate *)targetDate dateFormat:(NSString *)dateFormat {
    NSString *dateString1 = [self br_stringFromDate:date dateFormat:dateFormat];
    NSString *dateString2 = [self br_stringFromDate:targetDate dateFormat:dateFormat];
    NSDate *date1 = [self br_dateFromString:dateString1 dateFormat:dateFormat];
    NSDate *date2 = [self br_dateFromString:dateString2 dateFormat:dateFormat];
    if ([date1 compare:date2] == NSOrderedDescending) {
        return 1;
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        return -1;
    } else {
        return 0;
    }
}

#pragma mark - 获取 yearArr 数组
- (NSArray *)getYearArr {
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = self.minDate.br_year; i <= self.maxDate.br_year; i++) {
        [tempArr addObject:[self getYearNumber:i]];
    }
    // 判断是否需要添加【自定义字符串】
    if (self.addCustomString) {
        switch (self.pickerMode) {
            case DatePickerModeYMDHMS:
            case DatePickerModeYMDHM:
            case DatePickerModeYMDH:
            case DatePickerModeYMD:
            case DatePickerModeYM:
            case DatePickerModeY:
            {
                [tempArr addObject:self.addCustomString];
            }
                break;
            default:
                break;
        }
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    return [tempArr copy];
}

#pragma mark - 获取 monthArr 数组
- (NSArray *)getMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minDate.br_year) {
        startMonth = self.minDate.br_month;
    }
    if (year == self.maxDate.br_year) {
        endMonth = self.maxDate.br_month;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【自定义字符串】
    if (self.addCustomString) {
        switch (self.pickerMode) {
            case DatePickerModeMDHM:
            case DatePickerModeMD:
            {
                [tempArr addObject:self.addCustomString];
            }
                break;
            default:
                break;
        }
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    return [tempArr copy];
}

#pragma mark - 获取 dayArr 数组
- (NSArray *)getDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate br_getDaysInYear:year month:month];
    if (year == self.minDate.br_year && month == self.minDate.br_month) {
        startDay = self.minDate.br_day;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month) {
        endDay = self.maxDate.br_day;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    return [tempArr copy];
}

#pragma mark - 获取 hourArr 数组
- (NSArray *)getHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (self.pickerMode == DatePickerModeYMDH && self.isShowAMAndPM) {
        return @[[self getAMText], [self getPMText]];
    }
    
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day) {
        startHour = self.minDate.br_hour;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day) {
        endHour = self.maxDate.br_hour;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【自定义字符串】
    if (self.addCustomString) {
        switch (self.pickerMode) {
            case DatePickerModeHMS:
            case DatePickerModeHM:
            {
                [tempArr addObject:self.addCustomString];
            }
                break;
                
            default:
                break;
        }
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    
    return [tempArr copy];
}

#pragma mark - 获取 minuteArr 数组
- (NSArray *)getMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger startMinute = 0;
    NSInteger endMinute = 59;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day && hour == self.minDate.br_hour) {
        startMinute = self.minDate.br_minute;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day && hour == self.maxDate.br_hour) {
        endMinute = self.maxDate.br_minute;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startMinute; i <= endMinute; i += self.minuteInterval) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    // 判断是否需要添加【自定义字符串】
    if (self.addCustomString) {
        switch (self.pickerMode) {
            case DatePickerModeMS:
            {
                [tempArr addObject:self.addCustomString];
            }
                break;
                
            default:
                break;
        }
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    
    return [tempArr copy];
}

#pragma mark - 获取 secondArr 数组
- (NSArray *)getSecondArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSInteger startSecond = 0;
    NSInteger endSecond = 59;
    if (year == self.minDate.br_year && month == self.minDate.br_month && day == self.minDate.br_day && hour == self.minDate.br_hour && minute == self.minDate.br_minute) {
        startSecond = self.minDate.br_second;
    }
    if (year == self.maxDate.br_year && month == self.maxDate.br_month && day == self.maxDate.br_day && hour == self.maxDate.br_hour && minute == self.maxDate.br_minute) {
        endSecond = self.maxDate.br_second;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = startSecond; i <= endSecond; i += self.secondInterval) {
        [tempArr addObject:[self getMDHMSNumber:i]];
    }
    if (self.isDescending) {
        return [[[tempArr copy] reverseObjectEnumerator] allObjects];
    }
    
    return [tempArr copy];
}

#pragma mark - 添加 pickerView
- (void)setupPickerView:(UIView *)pickerView toView:(UIView *)view {
    if (view) {
        // 立即刷新容器视图 view 的布局（防止 view 使用自动布局时，选择器视图无法正常显示）
        [view setNeedsLayout];
        [view layoutIfNeeded];
        
        self.frame = view.bounds;
        CGFloat pickerHeaderViewHeight = self.pickerHeaderView ? self.pickerHeaderView.bounds.size.height : 0;
        CGFloat pickerFooterViewHeight = self.pickerFooterView ? self.pickerFooterView.bounds.size.height : 0;
        pickerView.frame = CGRectMake(0, pickerHeaderViewHeight, view.bounds.size.width, view.bounds.size.height - pickerHeaderViewHeight - pickerFooterViewHeight);
        pickerView.backgroundColor = UIColor.redColor;
        [self addSubview:pickerView];
    } else {
        [self.alertView addSubview:pickerView];
    }
}

#pragma mark - 获取时间单位
- (NSArray *)setupPickerUnitLabel:(UIPickerView *)pickerView unitArr:(NSArray *)unitArr {
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < pickerView.numberOfComponents; i++) {
        // label宽度
        CGFloat labelWidth = pickerView.bounds.size.width / pickerView.numberOfComponents;
        // 根据占位文本长度去计算宽度
        NSString *tempText = @"00";
        if (i == 0) {
            switch (self.pickerMode) {
                case DatePickerModeYMDHMS:
                case DatePickerModeYMDHM:
                case DatePickerModeYMDH:
                case DatePickerModeYMD:
                case DatePickerModeYM:
                case DatePickerModeY:
                {
                    tempText = @"0123";
                }
                    break;
                    
                default:
                    break;
            }
        }
        // 文本宽度
        CGFloat labelTextWidth = [tempText boundingRectWithSize:CGSizeMake(MAXFLOAT, self.pickerStyle.rowHeight)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName: self.pickerStyle.pickerTextFont}
                                                        context:nil].size.width;
        // 单位label
        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.font = self.pickerStyle.dateUnitTextFont;
        unitLabel.textColor = self.pickerStyle.dateUnitTextColor;
        // 字体自适应属性
        unitLabel.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        unitLabel.minimumScaleFactor = 0.5f;
        unitLabel.text = (unitArr.count > 0 && i < unitArr.count) ? unitArr[i] : nil;
        
        CGFloat originX = i * labelWidth + labelWidth / 2.0 + labelTextWidth / 2.0 + self.pickerStyle.dateUnitOffsetX;
        CGFloat originY = (pickerView.frame.size.height - self.pickerStyle.rowHeight) / 2 + self.pickerStyle.dateUnitOffsetY;
        unitLabel.frame = CGRectMake(originX, originY, self.pickerStyle.rowHeight, self.pickerStyle.rowHeight);
        
        [tempArr addObject:unitLabel];
        
        [pickerView addSubview:unitLabel];
    }
    
    return [tempArr copy];
}

#pragma mark - 设置选择器中间选中行的样式
- (void)setupPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
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

- (NSString *)getYearNumber:(NSInteger)year {
    NSString *yearString = [NSString stringWithFormat:@"%@", @(year)];
    if (self.isNumberFullName) {
        yearString = [NSString stringWithFormat:@"%04d", [yearString intValue]];
    }
    return yearString;
}

- (NSString *)getMDHMSNumber:(NSInteger)number {
    NSString *string = [NSString stringWithFormat:@"%@", @(number)];
    if (self.isNumberFullName) {
        string = [NSString stringWithFormat:@"%02d", [string intValue]];
    }
    return string;
}

- (NSString *)getYearText:(NSString *)yearString {
    if (self.addCustomString && [yearString isEqualToString:self.addCustomString]) {
        return yearString;
    }
    NSString *yearUnit = self.showUnitType == ShowUnitTypeAll ? [self getYearUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", yearString, yearUnit];
}

- (NSString *)getMonthText:(NSString *)monthString monthNames:(NSArray *)monthNames {
    if ([self.pickerStyle.language hasPrefix:@"zh"]) {
        self.monthNameType = MonthNameTypeNumber;
    }
    if (self.monthNameType != MonthNameTypeNumber && (self.pickerMode == DatePickerModeYMD || self.pickerMode == DatePickerModeYM)) {
        NSInteger index = [monthString integerValue] - 1;
        monthString = (index >= 0 && index < monthNames.count) ? monthNames[index] : @"";
        self.monthNameType = MonthNameTypeShortName;
    }
    if (self.addCustomString && [monthString isEqualToString:self.addCustomString]) {
        return monthString;
    }
    NSString *monthUnit = self.showUnitType == ShowUnitTypeAll ? [self getMonthUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", monthString, monthUnit];
}

- (NSString *)getDayText:(NSString *)dayString mSelectDate:(NSDate *)mSelectDate {
    if (self.isShowToday && mSelectDate.br_year == [NSDate date].br_year && mSelectDate.br_month == [NSDate date].br_month && [dayString integerValue] == [NSDate date].br_day) {
        return [NSBundle br_localizedStringForKey:@"今天" language:self.pickerStyle.language];
    }
    NSString *dayUnit = self.showUnitType == ShowUnitTypeAll ? [self getDayUnit] : @"";
    dayString = [NSString stringWithFormat:@"%@%@", dayString, dayUnit];
    if (self.isShowWeek) {
        NSDate *date = [NSDate br_setYear:mSelectDate.br_year month:mSelectDate.br_month day:[dayString integerValue]];
        NSString *weekdayString = [NSBundle br_localizedStringForKey:[date br_weekdayString] language:self.pickerStyle.language];
        dayString = [NSString stringWithFormat:@"%@%@", dayString, weekdayString];
    }
    return dayString;
}

- (NSString *)getHourText:(NSString *)hourString {
    if (self.addCustomString && [hourString isEqualToString:self.addCustomString]) {
        return hourString;
    }
    NSString *hourUnit = self.showUnitType == ShowUnitTypeAll ? [self getHourUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", hourString, hourUnit];
}

- (NSString *)getMinuteText:(NSString *)minuteString {
    NSString *minuteUnit = self.showUnitType == ShowUnitTypeAll ? [self getMinuteUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", minuteString, minuteUnit];
}

- (NSString *)getSecondText:(NSString *)secondString {
    NSString *secondUnit = self.showUnitType == ShowUnitTypeAll ? [self getSecondUnit] : @"";
    return [NSString stringWithFormat:@"%@%@", secondString, secondUnit];
}

- (NSString *)getAMText {
    return [NSBundle br_localizedStringForKey:@"上午" language:self.pickerStyle.language];
}

- (NSString *)getPMText {
    return [NSBundle br_localizedStringForKey:@"下午" language:self.pickerStyle.language];
}

- (NSString *)getYearUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"年" language:self.pickerStyle.language];
}

- (NSString *)getMonthUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"月" language:self.pickerStyle.language];
}

- (NSString *)getDayUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"日" language:self.pickerStyle.language];
}

- (NSString *)getHourUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    if (self.pickerMode == DatePickerModeYMDH && self.isShowAMAndPM) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"时" language:self.pickerStyle.language];
}

- (NSString *)getMinuteUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"分" language:self.pickerStyle.language];
}

- (NSString *)getSecondUnit {
    if (![self.pickerStyle.language hasPrefix:@"zh"]) {
        return @"";
    }
    return [NSBundle br_localizedStringForKey:@"秒" language:self.pickerStyle.language];
}

@end
