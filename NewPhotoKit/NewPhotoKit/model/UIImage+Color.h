//
//  UIImage+Color.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

//用颜色返回一张图片
+ (nullable UIImage *)br_imageWithColor: (UIColor *)color;

@end

NS_ASSUME_NONNULL_END
