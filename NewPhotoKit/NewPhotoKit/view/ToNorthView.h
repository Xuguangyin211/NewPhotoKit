//
//  ToNorthView.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ToNorthView;

typedef ToNorthView *_Nonnull(^Calibration)(float value);
typedef ToNorthView *_Nonnull(^DegreeInterval)(float value);
typedef ToNorthView *_Nonnull(^Creat)(void);

@interface ToNorthView : UIView
//手机朝向
@property (nonatomic, assign) float degree;
//每个刻度之间间隔的屏幕像素
@property (nonatomic, copy) Calibration cali;
//每个刻度之间间隔的角度
@property (nonatomic, copy) DegreeInterval degr;
//初始化，放在最后
@property (nonatomic, copy) Creat creat;
@end

NS_ASSUME_NONNULL_END
