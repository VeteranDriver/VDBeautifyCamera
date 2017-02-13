//
//  VDBeautifyPhotoViewController.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/13.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "VDBeautifyPhotoViewController.h"
#import "Masonry.h"
#import "VDFilterChooseTool.h"


#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define kFooterHeight 100

@interface VDBeautifyPhotoViewController ()

@property(nonatomic, strong) UIImageView *imgView;

@end

@implementation VDBeautifyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imgView];
    
    self.imgView.frame = CGRectMake(0, 64,kMainScreenWidth,kMainScreenHeight - 64 - kFooterHeight);
    
    self.imgView.image = self.photo;
    
    [[VDFilterChooseTool shareInstance] showFilterListWithInputImage:self.photo andClickCompletion:^(UIImage *outImage) {
        
        self.imgView.image = outImage;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setPhoto:(UIImage *)photo {
//    
//    
//    self.photo = photo;
////    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
////        
////        make.centerX.mas_equalTo(self.view.mas_centerX);
////        make.centerY.mas_equalTo(self.view.mas_centerY);
////        make.width.mas_equalTo(photo.size.width);
////        make.height.mas_equalTo(photo.size.height);
////    }];
//}

- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
