//
//  UIColor+Add.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/22.
//

#import "UIColor+Add.h"

@implementation UIColor (Add)

+ (UIColor *)br_systemBackgroundColor {
    if (@available(iOS 13.0, *)){
        return [UIColor systemBackgroundColor];
    } else {
        return [UIColor whiteColor];
    }
}

+ (UIColor *)br_labelColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    } else {
        return [UIColor blackColor];
    }
}

@end
