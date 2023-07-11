//
//  ScrollSliderView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/30.
//

#import "ScrollSliderView.h"

@interface ScrollSliderView()<UIScrollViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIScrollView *thumbScrollView;
@property (nonatomic, assign) CGFloat sourceContentOffsetUpdatesCount;
@property (nonatomic, assign) CGFloat thumbContentOffsetUpdatesCount;
@property (nonatomic, assign) CGFloat thumHeight;

@end

@implementation ScrollSliderView

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 30, 10, 30, self.bounds.size.height- 20)];
        _backView.backgroundColor = UIColor.orangeColor;
        _backView.layer.cornerRadius = 3.0;
        _backView.layer.borderWidth = 1.0;
    }
    return _backView;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ScrollSliderCustom.png"]];
        _thumbImageView.frame = CGRectMake(2, 0, 26, 60);
        _thumbImageView.contentMode = UIViewContentModeCenter;
        _thumbImageView.backgroundColor = UIColor.yellowColor;
    }
    return _thumbImageView;
}

//- (UIScrollView *)thumbScrollView {
//    if (!_thumbScrollView) {
//        _thumbScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 30, self.bounds.size.height)];
//        _thumbScrollView.delegate = self;
//        _thumbScrollView.bounces = NO;
//        _thumbScrollView.decelerationRate = 0;
//        _thumbScrollView.showsVerticalScrollIndicator = NO;
//        _thumbScrollView.scrollEnabled = YES;
//
//    }
//    return _thumbScrollView;
//}

- (void)setTextView:(UITextView *)textView {
    if (_textView != textView) {
        [self scrollViewContentDidChange];
    }
}

- (void)setThumbScrollView:(UIScrollView *)thumbScrollView {
    if (_textView != thumbScrollView) {
        [self scrollViewContentDidChange];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void) setupView{
    self.backgroundColor = UIColor.redColor;

    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width - 30, self.bounds.size.height)];
        _textView.selectable = NO;
        _textView.editable = NO;
        _textView.delegate = self;
        _textView.backgroundColor = UIColor.blueColor;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. \n Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";

        [self addSubview:self.textView];
    }
    
    if (!_thumbScrollView) {
        _thumbScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 30, self.bounds.size.height)];
        _thumbScrollView.delegate = self;
        _thumbScrollView.bounces = NO;
        _thumbScrollView.decelerationRate = 0;
        _thumbScrollView.showsVerticalScrollIndicator = NO;
        _thumbScrollView.scrollEnabled = YES;
    }

    [self addSubview:self.backView];

    [self.backView addSubview:self.thumbImageView];
    [self.backView addSubview:self.thumbScrollView];
    CGRect m = _thumbScrollView.bounds;
    [self updateContentSize];
}

- (void)scrollViewContentDidChange {
    _sourceContentOffsetUpdatesCount = 0;
    _thumbContentOffsetUpdatesCount = 0;

    [self updateContentSize];
    [self updateContentOffset];
    [self updateThumbImagePosition];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _thumbScrollView.frame = _backView.frame;

    [self updateContentSize];
    [self updateContentOffset];

    _thumbImageView.frame = CGRectMake(2, 0, 26, 60);
    [self updateThumbImagePosition];
}

- (void)updateContentSize {
    CGFloat contentHeight = 0;
    if (self.textView != nil) {
        contentHeight = _backView.frame.size.height + _backView.frame.size.height - 60;
    } else {
        contentHeight = _backView.frame.size.height;
    }
    _thumbScrollView.contentSize = CGSizeMake(30, roundf(contentHeight));
}

- (void)updateContentOffset {
    CGFloat targetHeight = _thumbScrollView.contentSize.height - _thumbScrollView.bounds.size.height;
    if (targetHeight < 0) {
        targetHeight = 0;
    }
    CGFloat sourceHeight = self.textView.contentSize.height - self.textView.bounds.size.height;
    if (sourceHeight < 0) {
        sourceHeight = 0;
    }
    CGFloat contentY = 0;
    if (targetHeight > 0 && sourceHeight > 0) {
        CGFloat ry = self.textView.contentOffset.y / sourceHeight;
        if (ry < 0) {
            ry = 0;
        } else if (ry > 1) {
            ry = 1;
        }
        contentY = (1 - ry) * targetHeight;
    }

    if (contentY != _thumbScrollView.contentOffset.y) {
        _thumbContentOffsetUpdatesCount += 1;
        _thumbScrollView.contentOffset = CGPointMake(0, contentY);
    }
}

- (void)updateSourceContentOffset {
    CGFloat targetHeight = _thumbScrollView.contentSize.height - _thumbScrollView.bounds.size.height;
    if (targetHeight < 0) {
        targetHeight = 0;
    }
    CGFloat sourceHeight = self.textView.contentSize.height - self.textView.bounds.size.height;
    if (sourceHeight < 0) {
        sourceHeight = 0;
    }
    CGFloat contentY = 0;
    if (targetHeight > 0 && sourceHeight > 0) {
        CGFloat ry = _thumbScrollView.contentOffset.y / targetHeight;
        contentY = (1 - ry) * sourceHeight;
    }
    if (contentY != self.textView.contentOffset.y) {
        _sourceContentOffsetUpdatesCount += 1;
        self.textView.contentOffset = CGPointMake(0, contentY);
    }
}

- (void)updateThumbImagePosition {
    CGFloat targetHeight = _thumbScrollView.bounds.size.height - 60;
    if (targetHeight < 0) {
        targetHeight = 0;
    }
    CGFloat sourceHeight = self.textView.contentSize.height - self.textView.bounds.size.height;
    if (sourceHeight < 0) {
        sourceHeight = 0;
    }
    CGFloat thumbY = 0;
    if (targetHeight > 0 && sourceHeight > 0) {
        CGFloat ry = self.textView.contentOffset.y / sourceHeight;
        if (ry < 0) {
            ry = 0;
        } else if (ry > 1) {
            ry = 1;
        }
        thumbY = ry * targetHeight;
    }
    CGFloat r = roundf(thumbY);
    _thumbImageView.frame = CGRectMake(2, r, 26, 60);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (self.textView == scrollView) {
        if (_sourceContentOffsetUpdatesCount > 0) {
            _sourceContentOffsetUpdatesCount -= 1;
            return;
        }
        [self updateContentOffset];
        [self updateThumbImagePosition];
    } else if (self.thumbScrollView == scrollView) {
        if (_thumbContentOffsetUpdatesCount > 0) {
            _thumbContentOffsetUpdatesCount -= 1;
            return;
        }
        [self updateSourceContentOffset];
        [self updateThumbImagePosition];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject]locationInView:self];
    point = [_backView.layer convertPoint:point fromLayer:self.layer];
    if ([_backView.layer containsPoint:point]) {
        if ([_thumbScrollView.layer containsPoint:point]) {
            NSLog(@"sssss");
        }
    }
}

@end
