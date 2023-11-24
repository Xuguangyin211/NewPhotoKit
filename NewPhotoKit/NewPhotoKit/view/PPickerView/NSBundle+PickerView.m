//
//  NSBundle+PickerView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/16.
//

#import "NSBundle+PickerView.h"
#import "BaseView.h"

@implementation NSBundle (PickerView)

#pragma mark -获取PickerView.bundle
+ (instancetype)br_pickerBundle {
    static NSBundle *pickerBundle = nil;
    if (pickerBundle == nil) {
        /*先拿到最外面的bundle，
         对framework链接方式来说就是framework的bundle根目录，
         对静态库链接方式来说就是target client的main bundle.
         然后再去找下面名为PickerView的bundle对象
         */
        NSBundle *bundle = [NSBundle bundleForClass:[BaseView class]];
        NSURL *url = [bundle URLForResource:@"PickerView" withExtension:@"bundle"];
        pickerBundle = [NSBundle bundleWithURL:url];
    }
    return pickerBundle;
}

+ (NSArray *)br_addressJsonArray {
    static NSArray *cityArray = nil;
    if (cityArray == nil) {
        //获取本地json文件
        NSString *filePath = [[self br_pickerBundle] pathForResource:@"City" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        cityArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return cityArray;
}

#pragma mark -获取国际化后的文本
+ (NSString *)br_localizedStringForKey:(NSString *)key language:(NSString *)language {
    return [self br_localizedStringForKey:key value: nil language:language];
}

+ (NSString *)br_localizedStringForKey:(NSString *)key value:(NSString *)value language:(NSString *)language {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        //如果没有手动设置语言，将随系统的语言自动改变
        if (!language) {
            //系统首选语言
            language = [NSLocale preferredLanguages].firstObject;
        }
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans";
            } else {
                language = @"zh-Hant";
            }
        } else {
            language = @"en";
        }
        //从PickerView.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[self br_pickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];

    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
