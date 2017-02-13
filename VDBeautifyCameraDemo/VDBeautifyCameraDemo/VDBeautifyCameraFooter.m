//
//  VDBeautifyCameraFooter.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/8.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "VDBeautifyCameraFooter.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kPhotoButtonWidth 70

@interface VDBeautifyCameraFooter ()

/**
 拍照按钮
 */
@property(nonatomic, strong) UIButton *photoButton;

@end

@implementation VDBeautifyCameraFooter


- (instancetype)init {
    
    if (self = [super init]) {

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:self.photoButton];
        [self addSubview:self.imgView];
        
        [self updateImgView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(kPhotoButtonWidth);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.width.mas_equalTo(kPhotoButtonWidth - 15);
    }];
    
    [super layoutSubviews];
}

- (void)updateImgView {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        
    }else {
        
        ALAssetsLibrary *libary = [[ALAssetsLibrary alloc] init];
        
        [libary enumerateGroupsWithTypes: ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            //但是这个group有可能为空，所以判断一下
            if(group != Nil)
            {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                //2.再通告文件夹遍历其中的资源文件
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if (result) {
                        
                        CGImageRef ratioThum = [result aspectRatioThumbnail];
                        
                        [self.imgView setImage:[UIImage imageWithCGImage:ratioThum] forState:UIControlStateNormal];
                        
                        *stop = YES;
                    }
                }];
            }
        } failureBlock:^(NSError *error) {
        }];
    }

}

- (void)photoButtonDidClick {
    
    if ([self.delegate respondsToSelector:@selector(VDBeautifyCameraFooterTakePhoto)]) {
        
        [self.delegate VDBeautifyCameraFooterTakePhoto];
    }
}

- (void)imgViewDidClick {
    
    if ([self.delegate respondsToSelector:@selector(VDBeautifyCameraFooterClickPicker)]) {
        
        [self.delegate VDBeautifyCameraFooterClickPicker];
    }
}

- (UIButton *)photoButton {
    
    if (_photoButton == nil) {
        
        _photoButton = [[UIButton alloc] init];
        [_photoButton setBackgroundColor:[UIColor whiteColor]];
        
//        [_photoButton setTitle:@"拍照" forState:UIControlStateNormal];
//        [_photoButton setTitle:@"拍照" forState:UIControlStateHighlighted];
//        [_photoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        _photoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        _photoButton.layer.cornerRadius = kPhotoButtonWidth / 2.0;
        
        [_photoButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_photoButton.layer setBorderWidth:8];
        
        _photoButton.layer.masksToBounds = YES;
        
        [_photoButton addTarget:self action:@selector(photoButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UIButton *)imgView {
    
    if (_imgView == nil) {
        
        _imgView = [[UIButton alloc] init];
        
        _imgView.layer.cornerRadius = 5;
        _imgView.layer.masksToBounds = YES;

        [_imgView addTarget:self action:@selector(imgViewDidClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _imgView;
}
@end
