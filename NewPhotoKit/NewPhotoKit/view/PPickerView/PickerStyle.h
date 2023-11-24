//
//  PickerStyle.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PickerViewMacro.h"

NS_ASSUME_NONNULL_BEGIN

//边框样式(左边取消按钮/右边确认按钮)
typedef NS_ENUM(NSInteger, BorderStyle) {
    //无边框（默认）
    BorderStyleNone = 0,
    //有圆角和边框
    BorderStyleSolid,
    //仅有圆角
    BorderStyleFill
};

@interface PickerStyle : NSObject

//设置背景颜色
@property (nullable, nonatomic, strong) UIColor *maskColor;
//隐藏maskView,默认为NO
@property (nonatomic, assign) BOOL hiddenMaskView;
//设置alertView弹框视图的背景颜色
@property (nonatomic, strong, nullable) UIColor *alertViewColor;
//设置alertView弹框视图顶部边框线颜色
@property (nonatomic, assign) BOOL hiddenShadowLine;

//标题栏视图
/** 设置 alertView 弹框视图左上和右上的圆角半径  */
@property (nonatomic, assign) NSInteger topCornerRadius;

/** 设置 alertView 弹框视图顶部边框线颜色  */
@property (nullable, nonatomic, strong) UIColor *shadowLineColor;

/** 设置 alertView 弹框视图顶部边框线高度  */
@property (nonatomic, assign) CGFloat shadowLineHeight;

//标题栏背景颜色
@property (nonatomic, strong, nullable) UIColor *titleBarColor;
//标题栏的高度
@property (nonatomic, assign) CGFloat titleBarHeight;
//标题栏底部分割线颜色
@property (nonatomic, strong, nullable) UIColor *titleLineColor;
//标题栏底部分割线，默认为NO
@property (nonatomic, assign) BOOL hiddenTitleLine;
//隐藏titleBarView, 默认为NO
@property (nonatomic, assign) BOOL hiddenTitleBarView;

/** 设置 titleLabel 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *titleLabelColor;

/** 设置 titleLabel 文本颜色 */
@property (nullable, nonatomic, strong) UIColor *titleTextColor;
/** 设置 titleLabel 字体大小 */
@property (nullable, nonatomic, strong) UIFont *titleTextFont;
/** 设置 titleLabel 的 frame */
@property (nonatomic, assign) CGRect titleLabelFrame;
/** 隐藏 titleLabel，默认为 NO */
@property (nonatomic, assign) BOOL hiddenTitleLabel;


/** 设置 cancelBtn 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *cancelColor;
/** 设置 cancelBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *cancelTextColor;
/** 设置 cancelBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *cancelTextFont;
/** 设置 cancelBtn 的 frame */
@property (nonatomic, assign) CGRect cancelBtnFrame;
/** 设置 cancelBtn 的边框样式 */
@property (nonatomic, assign) BorderStyle cancelBorderStyle;
/** 设置 cancelBtn 的圆角大小 */
@property (nonatomic, assign) CGFloat cancelCornerRadius;
/** 设置 cancelBtn 的边框宽度 */
@property (nonatomic, assign) CGFloat cancelBorderWidth;
/** 设置 cancelBtn 的 image */
@property (nullable, nonatomic, strong) UIImage *cancelBtnImage;
/** 设置 cancelBtn 的 title */
@property (nullable, nonatomic, copy) NSString *cancelBtnTitle;
/** 隐藏 cancelBtn，默认为 NO */
@property (nonatomic, assign) BOOL hiddenCancelBtn;

/** 设置 doneBtn 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *doneColor;
/** 设置 doneBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *doneTextColor;
/** 设置 doneBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *doneTextFont;
/** 设置 doneBtn 的 frame */
@property (nonatomic, assign) CGRect doneBtnFrame;
/** 设置 doneBtn 的边框样式 */
@property (nonatomic, assign) BorderStyle doneBorderStyle;
/** 设置 doneBtn 的圆角大小 */
@property (nonatomic, assign) CGFloat doneCornerRadius;
/** 设置 doneBtn 的边框宽度 */
@property (nonatomic, assign) CGFloat doneBorderWidth;
/** 设置 doneBtn 的 image */
@property (nullable, nonatomic, strong) UIImage *doneBtnImage;
/** 设置 doneBtn 的 title */
@property (nullable, nonatomic, copy) NSString *doneBtnTitle;
/** 隐藏 doneBtn，默认为 NO */
@property (nonatomic, assign) BOOL hiddenDoneBtn;
/** 设置 picker 的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *pickerColor;

/** 设置 picker 中间两条分割线的背景颜色 */
@property (nullable, nonatomic, strong) UIColor *separatorColor;

/** 设置 picker 文本的颜色 */
@property (nullable, nonatomic, strong) UIColor *pickerTextColor;

/** 设置 picker 文本的字体 */
@property (nullable, nonatomic, strong) UIFont *pickerTextFont;

/** 设置 picker 中间选中行的背景颜色，默认为nil */
@property (nullable, nonatomic, strong) UIColor *selectRowColor;

/** 设置 picker 中间选中行文本的颜色，默认为nil */
@property (nullable, nonatomic, strong) UIColor *selectRowTextColor;

/** 设置 picker 中间选中行文本的字体，默认为nil */
@property (nullable, nonatomic, strong) UIFont *selectRowTextFont;

/** 设置 picker 的高度，系统默认高度为 216 */
@property (nonatomic, assign) CGFloat pickerHeight;

/** 设置 picker 的行高 */
@property (nonatomic, assign) CGFloat rowHeight;


/**
 *  设置语言（不设置或为nil时，将随系统的语言自动改变）
 *  language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
 */
@property (nonatomic, copy, nullable) NSString *language;

/** 设置日期选择器单位文本的颜色 */
@property (nullable, nonatomic, strong) UIColor *dateUnitTextColor;

/** 设置日期选择器单位文本的字体 */
@property (nullable, nonatomic, strong) UIFont *dateUnitTextFont;

/** 设置日期选择器单位 label 的水平方向偏移量 */
@property (nonatomic, assign) CGFloat dateUnitOffsetX;

/** 设置日期选择器单位 label 的竖直方向偏移量 */
@property (nonatomic, assign) CGFloat dateUnitOffsetY;

/// 弹框模板样式1 - 取消/确定按钮圆角样式
/// @param themeColor 主题颜色
+ (instancetype)pickerStyleWithThemeColor:(nullable UIColor *)themeColor;

/// 弹框模板样式2 - 顶部圆角样式 + 完成按钮
/// @param doneTextColor 完成按钮标题的颜色
+ (instancetype)pickerStyleWithDoneTextColor:(nullable UIColor *)doneTextColor;

/// 弹框模板样式3 - 顶部圆角样式 + 图标按钮
/// @param doneBtnImage 完成按钮的 image
+ (instancetype)pickerStyleWithDoneBtnImage:(nullable UIImage *)doneBtnImage;


@end

NS_ASSUME_NONNULL_END
