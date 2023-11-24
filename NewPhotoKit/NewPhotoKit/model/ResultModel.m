//
//  ResultModel.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/20.
//

#import "ResultModel.h"

@implementation ResultModel

//判断两个对象是否相等
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[ResultModel class]]) {
        return  NO;
    }
    
    ResultModel *model = (ResultModel *)object;
    if (!model) {
        return NO;
    }
    //对象的类型相同，且对象的各个属性相等
    BOOL isSameKey = (!self.key && !model.key) || [self.key isEqualToString:model.key];
    BOOL isSameValue = (!self.value && !model.value) || [self.value isEqualToString:model.value];
    return isSameKey && isSameValue;
}

- (NSUInteger)hash {
    return [self.key hash] ^ [self.value hash];
}

- (NSString *)ID {
    return  _key;
}

- (NSString *)name {
    return _value;
}

@end
