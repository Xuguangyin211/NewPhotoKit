//
//  InfoViewCell.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/11/13.
//

#import "InfoViewCell.h"

#define kLeftMargin 14
#define kRowHeight 50

@interface InfoViewCell()
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation InfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.nextImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //调整cell分割线的边距： top, left, bottom, right
    self.titleLabel.frame = CGRectMake(kLeftMargin, 0, 200, kRowHeight);
    self.nextImageView.frame = CGRectMake(self.contentView.bounds.size.width - kLeftMargin - 14, (kRowHeight - 14)/2, 14, 14);
    self.textField.frame = CGRectMake(self.nextImageView.frame.origin.x - 200, 0, 200, kRowHeight);
    if (self.canEdit) {
        self.nextImageView.hidden = YES;
    } else {
        self.nextImageView.hidden = NO;
    }
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            _titleLabel.textColor = [UIColor labelColor];
        } else {
            _titleLabel.textColor = [UIColor blackColor];
        }
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:16.0];
        _textField.textAlignment = NSTextAlignmentRight;
        if (@available(iOS 13.0, *)) {
            _textField.textColor = [UIColor labelColor];
        } else {
            _textField.textColor = [UIColor blackColor];
        }
    }
    return _textField;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.backgroundColor = [UIColor clearColor];
        _nextImageView.image = [UIImage imageNamed:@"icon_next"];
    }
    return  _nextImageView;
}

@end
