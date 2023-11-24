//
//  NSBundle+PickerView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (PickerView)

//获取Picker View。bundle
+ (instancetype)br_pickerBundle;
//获取城市JSON数据
+ (NSArray *)br_addressJsonArray;
//获取国际化后的文本
+ (NSString *)br_localizedStringForKey: (NSString *)key language:(NSString *)language;
@end

NS_ASSUME_NONNULL_END
