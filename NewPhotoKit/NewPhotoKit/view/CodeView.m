//
//  CodeView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/7/10.
//

#import "CodeView.h"

@interface CodeView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *cursor;

@end

@implementation CodeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.userInteractionEnabled = false;
    self.layer.borderColor = UIColor.blackColor.CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 10;

    _label = [[UILabel alloc]init];
    _label.textColor = UIColor.blackColor;
    [self addSubview:_label];
    
    _showCursor = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat x = (self.frame.size.width - self.label.frame.size.width) / 2.0;
    CGFloat y = (self.frame.size.height - self.label.frame.size.height) / 2.0;
    self.label.frame = CGRectMake(x, y, self.label.frame.size.width, self.label.frame.size.height);
    [self updateCursorFrame];
}

- (void)updateCursorFrame  {
    CGFloat x = 0;
    if (self.label.frame.size.width <= 0) {
        x = (self.frame.size.width - 1.6) / 2.0;
    } else {
        x = CGRectGetMaxX(self.label.frame);
    }
    _cursor.frame = CGRectMake(x, 10, 1.6, self.frame.size.height - 20);
}

- (void)setText:(NSString *)text {
    _label.text = text;
    [self.label sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setShowCursor:(BOOL)showCursor {
    if (_showCursor == YES && showCursor == YES) { //重复开始, 那么,什么也不做
    } else if (_showCursor == YES && showCursor == NO) { //原来是开始的, 现在要求关闭, 那么,就关闭
        [_cursor removeFromSuperview];
    } else if (_showCursor == NO && showCursor == YES) { //原来是关闭, 现在要求开始, 那么, 开始
        _cursor = [[UIView alloc] init];
        _cursor.userInteractionEnabled = NO;
        _cursor.backgroundColor = UIColor.orangeColor;
        [self addSubview:_cursor];
        [self updateCursorFrame];
        _cursor.alpha = 0;
        [self animationOne:_cursor];
    } else if (_showCursor == NO && showCursor == NO) { //重复关闭
        [_cursor removeFromSuperview];
    }
    _showCursor = showCursor;
}

// 光标效果
- (void)animationOne:(UIView *)aView {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        aView.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.showCursor) {
            [self performSelector:@selector(animationTwo:) withObject:aView afterDelay:0.5];
        }
    }];
}

- (void)animationTwo:(UIView *)aView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        aView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.showCursor) {
            [self performSelector:@selector(animationOne:) withObject:aView afterDelay:0.1];
        }
    }];
}

@end
