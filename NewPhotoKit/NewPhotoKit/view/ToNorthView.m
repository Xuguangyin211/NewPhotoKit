//
//  ToNorthView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/28.
//

#import "ToNorthView.h"

@interface ToNorthView()

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, assign) float lastDegree;
@property (nonatomic, assign) float calibration; //每个刻度相隔的像素点
@property (nonatomic, assign) float degreeInterval; //每个刻度间隔的度数

@end

@implementation ToNorthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self subViews];
    }
    return self;
}

- (void)subViews {
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.userInteractionEnabled = NO;
    [self addSubview:self.myScrollView];

    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 4)/2, 25, 4, 15)];
    view.backgroundColor = UIColor.blackColor;
    [self addSubview:view];
}

#pragma mark - 计算代码
- (void)setDegree:(float)degree {
    _degree = degree;
    float count = 360.f/self.degreeInterval;//一整个圆分成多少分
    float x = self.calibration * degree / self.degreeInterval + self.calibration / 2.f;
    x = MIN(x, self.calibration * (count + 1));
    if ((self.lastDegree > 350 && degree < 10) || (self.lastDegree < 10 && degree > 350)) {
        //临界点0度和360度经过这里的时候会让myScrollView从尾部偷偷滑到头部
        NSLog(@"1: %f,%f", self.lastDegree, self.degree);
        [self.myScrollView setContentOffset:CGPointMake(x, 0)];
    } else {
        NSLog(@"2: %f,%f", self.lastDegree, self.degree);
        [UIView animateWithDuration:0.1 animations:^{
            [self.myScrollView setContentOffset:CGPointMake(x, 0)];
        }];
        self.lastDegree = degree;
    }
}

- (void)scrollToNorthViewAddsubView {
    //从0度到360度，每隔degree度画一个点，然后在0度的左边增加myScrollView一半宽度的刻度 360的右边增加myScrollView一半宽度的刻度，这样可以保证显示的刻度始终在myScrollView的正中间
    float w = self.myScrollView.frame.size.width;
    //360一共显示多少刻度
    float count = 360.f/self.degreeInterval;
    //myScrollView宽度能显示多少个刻度 +1是为了显示全刻度上的文字
    float fullCount = w/self.calibration + 1;

    int degree = -self.degreeInterval * (fullCount + 1)/2.f;
    for (int i = 0; i < count + fullCount; i++) {
        degree = degree + self.degreeInterval;
        UIView *viewBack = [UIView new];
        viewBack.backgroundColor = UIColor.orangeColor;
        UIView *view = [self scrollSub:degree];
        view.backgroundColor = UIColor.orangeColor;
        viewBack.frame = CGRectMake(self.calibration * i, 0, self.calibration, 20);
        [viewBack addSubview:view];
        [self.myScrollView addSubview:viewBack];
    }
}

//角度，每一个刻度的子view
- (UIView *)scrollSub: (int)degree {
    UIColor *tColor = [UIColor blackColor];
    if (degree < 0) {
        degree = 360 + degree;
    } else if (degree > 360) {
        degree = degree - 360;
    }
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, self.calibration, 20);
    UIView *viewline = [UIView new];
    UILabel *label = [UILabel new];
    viewline.clipsToBounds = YES;
    viewline.backgroundColor = tColor;

    label.textColor = tColor;
    label.textAlignment = NSTextAlignmentCenter;
    NSString *str = [NSString stringWithFormat:@"%d", degree];
    NSInteger flag = 0;
    if (degree == 0 || degree == 360) {
        str = @"N";
        flag = 1;
    } else if (degree == 45) {
        str = @"NE";
        flag = 1;
    } else if (degree == 90) {
        str = @"E";
        flag = 1;
    } else if (degree == 135) {
        str = @"SE";
        flag = 1;
    } else if (degree == 180) {
        str = @"S";
        flag = 1;
    } else if (degree == 225) {
        str = @"SW";
        flag = 1;
    } else if (degree == 270) {
        str = @"W";
        flag = 1;
    } else if (degree == 315) {
        str = @"NW";
        flag = 1;
    }
    CGRect lineFrame = CGRectMake((self.calibration - 2)/2, 0, 2, 6);
    CGFloat lineW = 1.f;
    label.font = [UIFont systemFontOfSize:10.f];
    if (flag) {
        lineFrame = CGRectMake((self.calibration - 2)/2, 0, 3, 8);
        lineW = 1.5f;
        label.font = [UIFont systemFontOfSize: 10.f];
    }
    viewline.frame = lineFrame;
    viewline.layer.cornerRadius = lineW;
    label.frame = CGRectMake(0, 10, self.calibration, 10);
    label.text = str;
    [view addSubview: viewline];
    [view addSubview: label];
    return view;
}

- (Calibration)cali {
    __weak typeof(self) weakSelf = self;
    return  ^(float value){
        self.calibration = value;
        return weakSelf;
    };
}

- (DegreeInterval)degr {
    __weak typeof(self) weakSelf = self;
    return ^(float value){
        self.degreeInterval = value;
        return weakSelf;
    };
}

- (Creat)creat {
    __weak typeof(self) weakSelf = self;
    return ^(void){
        [self scrollToNorthViewAddsubView];
        float w = self.frame.size.width;
        float count = 360.f/self.degreeInterval; //360度一共显示多少个刻度
        float fullCount = w/self.calibration + 1; //myScrollView宽度能显示多少个刻度 +1是为了显示全刻度上的文字
        self.myScrollView.contentSize = CGSizeMake((count + fullCount) * self.calibration, 20);//总长度
        return weakSelf;
    };
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
