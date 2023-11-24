//
//  UIImage+Color.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/22.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

#pragma mark - 用颜色返回一张图片
+ (UIImage *)br_imageWithColor:(UIColor *)color {
    return [self br_imageWithColor:color size: CGSizeMake(1, 1)];
}

#pragma mark -颜色返回图片
+ (UIImage *)br_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
