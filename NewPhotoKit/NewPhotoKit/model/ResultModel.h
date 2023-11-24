//
//  ResultModel.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import <Foundation/Foundation.h>
#import "PickerViewMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultModel : NSObject
//索引
@property (nonatomic, assign) NSInteger index;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSString *parentkey;
@property (nullable, nonatomic, copy) NSString *parentValue;
//其他扩展字段
@property (nullable, nonatomic, copy) NSString *remark;
@property (nonatomic, assign) BOOL boolField;
@property (nullable, nonatomic, strong) id idField;

@property (nullable, nonatomic, copy) NSString *ID BRPickerViewDeprecated("请使用key");
@property (nullable, nonatomic, copy) NSString *name BRPickerViewDeprecated("请使用value");

@end

NS_ASSUME_NONNULL_END
