//
//  NSDate+BGPickerView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BGPickerView)
//年
@property (readonly) NSInteger br_year;
//月
@property (readonly) NSInteger br_month;
//日
@property (readonly) NSInteger br_day;
//时
@property (readonly) NSInteger br_hour;
//分
@property (readonly) NSInteger br_minute;
//秒
@property (readonly) NSInteger br_second;
//星期
@property (readonly) NSInteger br_weekday;
//获取中文字符
@property (readonly) NSString* br_weekdayString;

/*创建data
 yyyy
 */
+ (nullable NSDate *)br_setYear: (NSInteger)year;

/*yyyy-MM*/
+ (nullable NSDate *)br_setYear:(NSInteger)year month: (NSInteger)month;

/*yyyy-MM-dd*/
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/*yyy-MM-dd HH*/
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;

/*yyyy-MM-dd HH:mm*/
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;

/*yyyy-MM-dd HH:mm:ss*/
+ (nullable NSDate *)br_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/** MM-dd HH:mm */
+ (nullable NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd */
+ (nullable NSDate *)br_setMonth:(NSInteger)month day:(NSInteger)day;
/** HH:mm:ss */
+ (nullable NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
/** HH:mm */
+ (nullable NSDate *)br_setHour:(NSInteger)hour minute:(NSInteger)minute;
/** mm:ss */
+ (nullable NSDate *)br_setMinute:(NSInteger)minute second:(NSInteger)second;

/** NSDate -> NSString */
+ (nullable NSString *)br_getDateString:(NSDate *)date format:(NSString *)format;
/** NSDate -> NSString */
- (nullable NSString *)br_convertDateWithFormat:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone language:(nullable NSString *)language;
/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)br_getDaysInYear:(NSInteger)year month:(NSInteger)month;

/**  获取 日期加上/减去某天数后的新日期 */
- (nullable NSDate *)br_getNewDate:(NSDate *)date addDays:(NSTimeInterval)days;

@end
NS_ASSUME_NONNULL_END
