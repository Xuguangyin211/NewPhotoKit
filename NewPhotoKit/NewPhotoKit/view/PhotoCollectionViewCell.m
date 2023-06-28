//
//  PhotoCollectionViewCell.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/26.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell
@synthesize iconView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    [self.contentView addSubview:iconView];
}

@end
