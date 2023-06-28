//
//  UIContainView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIContainView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>)delegate;
@end

NS_ASSUME_NONNULL_END
