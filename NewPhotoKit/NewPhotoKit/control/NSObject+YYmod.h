//
//  NSObject+YYmod.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YYmod)

- (NSString *)setEncode:(NSString *)str isPlus:(BOOL )a num: (int)b;
- (NSString *)getDecode:(NSString *)str isPlus:(BOOL )a num: (int)b;
@end

NS_ASSUME_NONNULL_END
