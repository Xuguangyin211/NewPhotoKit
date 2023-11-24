//
//  AddressModel.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/21.
//

#import <Foundation/Foundation.h>
#import "PickerViewMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceModel : NSObject

/** 省对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nullable, nonatomic, copy) NSArray *citylist;

@end

/// 市
@interface CityModel : NSObject
/** 市对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 地区数组 */
@property (nullable, nonatomic, copy) NSArray *arealist;

@end

/// 区
@interface AreaModel : NSObject
/** 区对应的code或id */
@property (nullable, nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nullable, nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
