//
//  VDBeautifyPhotoView.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/13.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "VDBeautifyPhotoView.h"

@interface VDBeautifyPhotoView ()

@property(nonatomic, strong) UIImageView *imgView;

@end

@implementation VDBeautifyPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
     
        [self addSubview:self.imgView];
        self.imgView.frame = self.bounds;
    }
    return self;
}


- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
