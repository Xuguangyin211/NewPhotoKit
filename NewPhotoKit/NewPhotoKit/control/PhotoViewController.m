//
//  PhotoViewController.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/27.
//

#import "PhotoViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIContainView.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PHImageRequestOptions *options;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;
@property (nonatomic, strong) UIContainView *containView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllPhotosFromA];
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 44, 80, 30);
    backBtn.backgroundColor = UIColor.grayColor;
    [backBtn setTitle:@"Back" forState:normal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    self.containView = [[UIContainView alloc]initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height) delegate:self];
    self.containView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.containView];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)getAllPhotosFromA {
    self.options = [[PHImageRequestOptions alloc]init];
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = NO;
    self.options.networkAccessAllowed = YES;

    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSLog(@"图片数量： %lu", (unsigned long)self.assets.count);
    [self.containView.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCell" forIndexPath:indexPath];
    CGSizeMake(self.assets[indexPath.row].pixelWidth, self.assets[indexPath.row].pixelHeight);
    [[PHImageManager defaultManager]requestImageForAsset:self.assets[indexPath.row] targetSize:CGSizeMake(110, 110) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
        cell.iconView.image = result;
    }];
    return cell;
}

#pragma mark -判断是不是GIF： （资源类型判别可以为UI提供一些图片类型的指示）
- (BOOL)adjustGIFWithAsset: (PHAsset *)asset {
    if ([asset isKindOfClass:[PHAsset class]]) {
        //每个asset都有一个或者多个PHAssetResource, 且被修改后的GIF
        NSArray<PHAssetResource *>* tmpArr = [PHAssetResource assetResourcesForAsset:asset];
        if (tmpArr.count) {
            PHAssetResource *resource = tmpArr.lastObject;
            if (resource.uniformTypeIdentifier.length) {
                return UTTypeConformsTo((__bridge  CFStringRef)resource.uniformTypeIdentifier, kUTTypeGIF);
            }
        }
    }
    return false;
}

//方法2
- (BOOL)adjustGIFWithAssets: (PHAsset *)asset {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [options setSynchronous:true];
    __block NSString *dataUTIStr = nil;
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dataUTIStr = dataUTI;
        }];
    }
    if (dataUTIStr.length) {
        return UTTypeConformsTo((__bridge  CFStringRef)dataUTIStr, kUTTypeGIF);
    }
    return false;
}

@end
