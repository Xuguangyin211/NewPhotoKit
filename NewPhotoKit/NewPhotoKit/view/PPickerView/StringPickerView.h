//
//  StringPickerView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import "BaseView.h"
#import "ResultModel.h"

NS_ASSUME_NONNULL_BEGIN

///字符串选择器类型
typedef NS_ENUM(NSInteger, StringPickerMode){
    //单列字符串选择
    StringPickerModeComponentSingle,
    //多列字符串选择（两列及两列以上）
    StringPickerModeComponentMulti
};

typedef void(^StringResultModeBlock)(ResultModel *_Nullable resultModel);
typedef void(^StringResultModelArrayBlock)(NSArray <ResultModel *> * _Nullable resultModelArr);

@interface StringPickerView : BaseView

@property (nonatomic, assign) StringPickerMode pickerMode;

@property (nullable, nonatomic, copy) NSArray *dataSourceArr;

@property (nullable, nonatomic, copy) NSString *plistName;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nullable, nonatomic, copy) NSString *selectValue;

//设置默认选中的位置[多列]
@property (nullable, nonatomic, copy) NSArray <NSNumber *> *selectIndexs;
//推荐使用selectIndexs, 更加严谨，可以避免使用 selectvalues
@property (nullable, nonatomic, copy) NSArray <NSString *> *selectValues;

//选择结果的回调【单列】
@property (nullable, nonatomic, copy) StringResultModeBlock resultModelBlock;
//选择结果的回调【多列】
@property (nullable, nonatomic, copy) StringResultModelArrayBlock resultModelArrayBlock;

//滚动选择时触发的回调【单列】
@property (nullable, nonatomic, copy) StringResultModeBlock changeModelBlock;
//滚动选择时触发的回调【多列】
@property (nullable, nonatomic, copy) StringResultModelArrayBlock changeModelArrayBlock;

//初始化字符串选择器
//@param pickerMode字符串选择器显示类型
- (instancetype)initwithPickerMode: (StringPickerMode)pickerMode;

//弹出选择器视图
- (void)show;

//关闭选择器视图
- (void)dismiss;

+ (void)showPickerWithTitle: (nullable NSString *)title dataSourceArr: (nullable NSArray *)dataSourceArr selectIndex: (NSInteger)selectIndex resultBlock: (nullable StringResultModeBlock)resultBlock;

+ (void)showPickerWithTitle:(nullable NSString *)title dataSourceArr:(nullable NSArray *)dataSourceArr selectIndex:(NSInteger)selectIndex isAutoSelect:(BOOL)isAutoSelect resultBlock:(nullable StringResultModeBlock)resultBlock;

+ (void)showMultiPickerWithTitle:(nullable NSString *)title dataSourceArr:(nullable NSArray *)dataSourceArr selectIndex:(nullable NSArray <NSNumber *> *)selectIndexs resultBlock:(nullable StringResultModelArrayBlock)resultBlock;

+ (void)showMultiPickerWithTitle:(nullable NSString *)title dataSourceArr:(nullable NSArray *)dataSourceArr selectIndex:(nullable NSArray<NSNumber *> *)selectIndexs isAutoSelect: (BOOL)isAutoSelect resultBlock:( nullable StringResultModelArrayBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
