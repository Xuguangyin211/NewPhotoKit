//
//  InfoModel.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoModel : NSObject

/** 姓名 */
@property (nonatomic, copy) NSString *nameStr;
/** 性别 */
@property (nonatomic, copy) NSString *genderStr;
/** 出生年月 */
@property (nonatomic, copy) NSString *birthdayStr;
/** 出生时刻 */
@property (nonatomic, copy) NSString *birthtimeStr;
/** 联系方式 */
@property (nonatomic, copy) NSString *phoneStr;
/** 地区 */
@property (nonatomic, copy) NSString *addressStr;
/** 学历 */
@property (nonatomic, copy) NSString *educationStr;
/** 其它 */
@property (nonatomic, copy) NSString *otherStr;

@end

NS_ASSUME_NONNULL_END
