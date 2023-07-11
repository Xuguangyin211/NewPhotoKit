//
//  CodeView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodeView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic) BOOL showCursor;

@end

NS_ASSUME_NONNULL_END
