//
//  PickerView+BR.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import "PickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PickerView (BR)

/** 最小日期 */
- (NSDate *)handlerMinDate:(nullable NSDate *)minDate;

/** 最大日期 */
- (NSDate *)handlerMaxDate:(nullable NSDate *)maxDate;

/** 默认选中的日期 */
- (NSDate *)handlerSelectDate:(nullable NSDate *)selectDate dateFormat:(NSString *)dateFormat;

/** NSDate 转 NSString */
- (NSString *)br_stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/** NSString 转 NSDate */
- (NSDate *)br_dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

/** 比较两个时间大小（可以指定比较级数，即按指定格式进行比较） */
- (NSComparisonResult)br_compareDate:(NSDate *)date targetDate:(NSDate *)targetDate dateFormat:(NSString *)dateFormat;

/** 获取 yearArr 数组 */
- (NSArray *)getYearArr;

/** 获取 monthArr 数组 */
- (NSArray *)getMonthArr:(NSInteger)year;

/** 获取 dayArr 数组 */
- (NSArray *)getDayArr:(NSInteger)year month:(NSInteger)month;

/** 获取 hourArr 数组 */
- (NSArray *)getHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/** 获取 minuteArr 数组 */
- (NSArray *)getMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;

/** 获取 secondArr 数组 */
- (NSArray *)getSecondArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;

/** 添加 pickerView */
- (void)setupPickerView:(UIView *)pickerView toView:(UIView *)view;

/** 设置时间单位 */
- (NSArray *)setupPickerUnitLabel:(UIPickerView *)pickerView unitArr:(NSArray *)unitArr;

/** 设置选择器中间选中行的样式 */
- (void)setupPickerSelectRowStyle:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (NSString *)getYearNumber:(NSInteger)year;

- (NSString *)getMDHMSNumber:(NSInteger)number;

- (NSString *)getYearText:(NSString *)yearString;

- (NSString *)getMonthText:(NSString *)monthString monthNames:(NSArray *)monthNames;

- (NSString *)getDayText:(NSString *)dayString mSelectDate:(NSDate *)mSelectDate;

- (NSString *)getHourText:(NSString *)hourString;

- (NSString *)getMinuteText:(NSString *)minuteString;

- (NSString *)getSecondText:(NSString *)secondString;

- (NSString *)getAMText;

- (NSString *)getPMText;

- (NSString *)getYearUnit;

- (NSString *)getMonthUnit;

- (NSString *)getDayUnit;

- (NSString *)getHourUnit;

- (NSString *)getMinuteUnit;

- (NSString *)getSecondUnit;

@end

NS_ASSUME_NONNULL_END
