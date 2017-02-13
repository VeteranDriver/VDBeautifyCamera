//
//  VDBeautifyCameraFooter.h
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/8.
//  Copyright © 2017年 VD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VDBeautifyCameraFooterDelegate <NSObject>

/**
 点击拍照按钮
 */
- (void)VDBeautifyCameraFooterTakePhoto;

/**
 点击小图片
 */
- (void)VDBeautifyCameraFooterClickPicker;

@end

@interface VDBeautifyCameraFooter : UIView

@property(nonatomic, strong) UIButton *imgView;

@property(nonatomic, weak) id<VDBeautifyCameraFooterDelegate> delegate;

- (void)updateImgView;

@end
