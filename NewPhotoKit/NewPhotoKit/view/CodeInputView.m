//
//  CodeInputView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/7/10.
//

#import "CodeInputView.h"
#import "CodeView.h"

@interface CodeInputView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) NSString *lastString;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic,strong) NSMutableArray <CodeView *> *arrayTextFidld;
@property (nonatomic, strong) UILabel *lab;

@end

@implementation CodeInputView

- (instancetype)init {
    if (self = [super init]) {
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
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = UIColor.blackColor.CGColor;

    _lab = [[UILabel alloc]init];
    _lab.text = @"Enter 4 Digit Code";
    _lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lab];

    //初始化数组
    _arrayTextFidld = [NSMutableArray array];
    _lastString = @"";

    _textfield = [[UITextField alloc] init];
    _textfield.backgroundColor = [UIColor purpleColor];
    _textfield.keyboardType = UIKeyboardTypeDecimalPad;
    _textfield.delegate = self;
    [self addSubview:_textfield];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:_textfield];

    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = UIColor.whiteColor;
    _contentView.userInteractionEnabled = NO;
    [self addSubview:_contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubViews];
}

- (void)updateSubViews {
    self.lab.frame = CGRectMake(0, 40, self.bounds.size.width, 30);
    self.textfield.frame = CGRectMake(0, 110, self.bounds.size.width, 40);
    self.contentView.frame = CGRectMake(0, 110, self.bounds.size.width, 50);

    if (_arrayTextFidld.count < 4) { //已经存在的子控件比新来的数要小, 那么就创建
        NSUInteger c = 4 - _arrayTextFidld.count;
        for (NSInteger i = 0; i < c; i ++) {
            CodeView *v = [[CodeView alloc] init];
            [_arrayTextFidld addObject:v];
        }
    } else if (_arrayTextFidld.count == 4) { //个数相等
        return; //如果return,那么就是什么都不做, 如果不return, 那么后续可以更新颜色之类, 或者在转屏的时候重新布局
    } else if (_arrayTextFidld.count > 4) { //个数有多余, 那么不用创建新的, 为了尽可能释放内存, 把不用的移除掉,
        NSUInteger c = _arrayTextFidld.count - 4;
        for (NSInteger i = 0; i < c; i ++) {
            [_arrayTextFidld.lastObject removeFromSuperview];
            [_arrayTextFidld removeLastObject];
        }
    }
    
    //可用宽度 / 格子总数
    CGFloat w = 50;
    CGFloat pad = 10;
    CGFloat margin = (self.bounds.size.width - 2 * pad - 4 * w)/3;
    //重新布局小格子
    for (NSInteger i = 0; i < 4; i ++) {
        CodeView *t = _arrayTextFidld[i];
        [self.contentView addSubview:t];
        t.frame = CGRectMake(pad + i * (w + margin), 0, w, w);
    }
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *sender = (UITextField *)[notification object];

    BOOL a = sender.text.length >= self.lastString.length;
    BOOL b = sender.text.length - self.lastString.length >= 4;
    if (a && b) { //判断为一连串验证码输入, 那么,最后N个,就是来自键盘上的短信验证码,取最后N个
        NSLog(@"一连串的输入");
        sender.text = [sender.text substringFromIndex:sender.text.length - 4];
    }

    if (sender.text.length >= 4 + 1) { //对于持续输入,只要前面N个就行
        NSLog(@"持续输入");
        sender.text = [sender.text substringToIndex:4];
        NSLog(@"aaa: %@", sender.text);
    }

    //字符串转数组
    NSMutableArray <NSString *> *stringArray = [NSMutableArray array];
    NSString *temp = nil;
    for(int i = 0; i < [sender.text length]; i++) {
        temp = [sender.text substringWithRange:NSMakeRange(i,1)];
        [stringArray addObject:temp];
    }

    //设置文字
    for(int i = 0; i < self.arrayTextFidld.count; i++) {
        CodeView *codeView = self.arrayTextFidld[i];
        if (i < stringArray.count) {
            codeView.text = stringArray[i];
        } else {
            codeView.text = @"";
        }
    }

    //设置光标
    if (stringArray.count == 0) {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            BOOL hide = (i == 0 ? YES : NO);
            CodeView *codeView = self.arrayTextFidld[i];
            codeView.showCursor = hide;
        }
    } else if (stringArray.count == self.arrayTextFidld.count) {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            CodeView *codeView = self.arrayTextFidld[i];
            codeView.showCursor = NO;
        }
    } else {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            CodeView *codeView = self.arrayTextFidld[i];
            if (i == stringArray.count - 1) {
                codeView.showCursor = YES;
            } else {
                codeView.showCursor = NO;
            }
        }
    }

    if (stringArray.count == self.arrayTextFidld.count) {
        NSString *str = _textfield.text;
        if ([str isEqual: @"1234"]) {
            [self.textfield resignFirstResponder];
            [self removeFromSuperview];
        } else {
            [UIView animateWithDuration:0.1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{

            } completion:^(BOOL finished) {
                [stringArray removeAllObjects];
                for(int i = 0; i < self.arrayTextFidld.count; i++) {
                    CodeView *codeView = self.arrayTextFidld[i];
                    if (i < stringArray.count) {
                        codeView.text = stringArray[i];
                    } else {
                        codeView.text = @"";
                    }
                }
                self.textfield.text = @"";
            }];

        }
    }
    self.lastString = sender.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.lastString.length == 0 || self.lastString.length == 1) {
        self.arrayTextFidld.firstObject.showCursor = YES;
    } else if (self.lastString.length == self.arrayTextFidld.count) {
        self.arrayTextFidld.lastObject.showCursor = YES;
    } else {
        self.arrayTextFidld[self.lastString.length - 1].showCursor = YES;
    }
}

- (NSString *)codeText {
    return self.textfield.text;
}

- (BOOL)resignFirstResponder {
    for(int i = 0; i < self.arrayTextFidld.count;i++) {
        CodeView *codeView = self.arrayTextFidld[i];
        codeView.showCursor = NO;
    }
    [self.textfield resignFirstResponder];
    return YES;
}

- (BOOL)becomeFirstResponder {
    [self.textfield becomeFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self];
    if (!result) {
        NSLog(@"ccc");
        [self removeFromSuperview];
    } else {
        NSLog(@"bbbb");
    }
}

@end
