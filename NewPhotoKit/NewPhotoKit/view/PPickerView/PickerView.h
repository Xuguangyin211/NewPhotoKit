//
//  PickerView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/16.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "NSDate+BGPickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DatePickerMode) {
    //以下4种是系统样式（兼容国际化日期格式）
    DatePickerModeDate,
    DatePickerModeDateAndTime,
    DatePickerModeTime,
    DatePickerModeCountDownTimer,
    
    DatePickerModeYMDHMS,
    DatePickerModeYMDHM,
    DatePickerModeYMDH,
    DatePickerModeMDHM,
    DatePickerModeYMD,
    DatePickerModeYM,
    DatePickerModeY,
    DatePickerModeMD,
    DatePickerModeHMS,
    DatePickerModeHM,
    DatePickerModeMS
};

typedef NS_ENUM(NSInteger, ShowUnitType) {
    ShowUnitTypeAll,
    ShowUnitTypeOnlyCenter,
    ShowUnitTypeNone
};

typedef NS_ENUM(NSInteger, MonthNameType) {
    //月份英文全称
    MonthNameTypeFullName,
    //月份英文简称
    MonthNameTypeShortName,
    //月份数字
    MonthNameTypeNumber
};

typedef void (^DateResultBlock)(NSDate * _Nullable selectDate, NSString * _Nullable selectValue);

@interface PickerView : BaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 日期选择器显示类型 */
@property (nonatomic, assign) DatePickerMode pickerMode;

/** 设置选中的时间（推荐使用 selectDate） */
@property (nullable, nonatomic, strong) NSDate *selectDate;
@property (nullable, nonatomic, copy) NSString *selectValue;

/** 最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nullable, nonatomic, strong) NSDate *minDate;
/** 最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nullable, nonatomic, strong) NSDate *maxDate;

/** 选择结果的回调 */
@property (nullable, nonatomic, copy) DateResultBlock resultBlock;

/** 滚动选择时触发的回调 */
@property (nullable, nonatomic, copy) DateResultBlock changeBlock;

/** 日期单位显示类型 */
@property (nonatomic, assign) ShowUnitType showUnitType;

/** 是否显示【星期】，默认为 NO */
@property (nonatomic, assign, getter=isShowWeek) BOOL showWeek;

/** 是否显示【今天】，默认为 NO */
@property (nonatomic, assign, getter=isShowToday) BOOL showToday;

/** 是否添加【至今】，默认为 NO */
@property (nonatomic, assign, getter=isAddToNow) BOOL addToNow;

/** 最后一行，添加【自定义字符串】；配合 selectValue 可设置默认选中 */
@property (nullable, nonatomic, copy) NSString *addCustomString;

/** 时间列表排序是否降序，默认为 NO（升序）*/
@property (nonatomic, assign, getter=isDescending) BOOL descending;

/** 选择器上数字是否显示全称（即显示带前导零的数字，如：2020-01-01），默认为 NO（如：2020-1-1） */
@property (nonatomic, assign, getter=isNumberFullName) BOOL numberFullName;

/** 设置分的时间间隔，默认为1（范围：1 ~ 30）*/
@property (nonatomic, assign) NSInteger minuteInterval;

/** 设置秒的时间间隔，默认为1（范围：1 ~ 30）*/
@property (nonatomic, assign) NSInteger secondInterval;

/** 设置倒计时的时长，默认为0（范围：0 ~ 24*60*60-1，单位为秒） for `BRDatePickerModeCountDownTimer`, ignored otherwise. */
@property (nonatomic, assign) NSTimeInterval countDownDuration;

/** for `BRDatePickerModeYMD` or `BRDatePickerModeYM`, ignored otherwise. */
@property (nonatomic, assign) MonthNameType monthNameType;

/** 显示上午和下午，默认为 NO. for `BRDatePickerModeYMDH`, ignored otherwise. */
@property (nonatomic, assign, getter=isShowAMAndPM) BOOL showAMAndPM;

/** 设置时区，默认为当前时区 */
@property (nullable, nonatomic, copy) NSTimeZone *timeZone;

/// 初始化时间选择器
/// @param pickerMode  日期选择器显示类型
- (instancetype)initWithPickerMode:(DatePickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;


//================================================= 华丽的分割线 =================================================

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法二】：快捷使用，直接选择下面其中的一个方法进行使用
 ///    特点：快捷，方便
 ///
 ////////////////////////////////////////////////////////////////////////*/

/**
 *  1.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(DatePickerMode)mode
                         title:(nullable NSString *)title
                   selectValue:(nullable NSString *)selectValue
                   resultBlock:(nullable DateResultBlock)resultBlock;

/**
 *  2.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(DatePickerMode)mode
                         title:(nullable NSString *)title
                   selectValue:(nullable NSString *)selectValue
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(nullable DateResultBlock)resultBlock;

/**
 *  3.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param minDate          最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param maxDate          最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(DatePickerMode)mode
                         title:(nullable NSString *)title
                   selectValue:(nullable NSString *)selectValue
                       minDate:(nullable NSDate *)minDate
                       maxDate:(nullable NSDate *)maxDate
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(nullable DateResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
