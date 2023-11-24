//
//  InfoViewCell.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL canEdit;
@end

NS_ASSUME_NONNULL_END
