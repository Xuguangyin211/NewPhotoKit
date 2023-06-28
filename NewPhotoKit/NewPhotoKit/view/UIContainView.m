//
//  UIContainView.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/26.
//

#import "UIContainView.h"
#import "PhotoCollectionViewCell.h"

@interface UIContainView()

@property (nonatomic, weak) id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> delegate;

@end
@implementation UIContainView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        [self setupView];

    }
    return self;
}

- (void)setupView {
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(80, 80);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = _delegate;
        _collectionView.delegate = _delegate;
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
