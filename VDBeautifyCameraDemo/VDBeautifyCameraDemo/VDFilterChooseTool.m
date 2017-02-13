//
//  FilterChooseTool.m
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/13.
//  Copyright © 2017年 VD. All rights reserved.
//

#import "VDFilterChooseTool.h"

#import "Masonry.h"

#import <CoreImage/CoreImage.h>

#define kFilterListItemSize CGSizeMake(80, 80)

static VDFilterChooseTool *tool;

@interface VDFilterChooseTool ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *filterList;

@property(nonatomic, copy) ClickCompletion clickCompletion;

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) CIFilter *myFilter;

@property(nonatomic, strong) UIImage *inputImage;

@end

@implementation VDFilterChooseTool

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[VDFilterChooseTool alloc] init];
        
        
    });
    
    return tool;
}

- (void)showFilterListWithInputImage:(UIImage *)inputImage andClickCompletion:(ClickCompletion)clickCompletion {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.filterList];
    
    [self.filterList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    self.inputImage = inputImage;
    self.clickCompletion = clickCompletion;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.dataSource = (NSArray *)[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    //查看所有滤镜集合
    NSLog(@"%@",self.dataSource);
    
    return self.dataSource.count;
}

//这是正确的方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.myFilter = [CIFilter filterWithName:self.dataSource[indexPath.item]];
    
//    UIImage *image = [UIImage imageNamed:@"戒指"];
    
    CIImage *inputImage = [CIImage imageWithCGImage:self.inputImage.CGImage];
    
    [self.myFilter setValue:inputImage forKey:@"inputImage"];
    
    CIImage *outputImage = self.myFilter.outputImage;
    
    //    CIContext *context = [CIContext contextWithOptions:nil];
    //
    //    CGImageRef cgimage = [context createCGImage:outputImage fromRect:inputImage.extent];
    
    EAGLContext *eaContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    CIContext *ciContext = [CIContext contextWithEAGLContext:eaContext];
    
    CGImageRef cgImage = [ciContext createCGImage:outputImage fromRect:inputImage.extent];
    
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    
    self.clickCompletion(uiImage);
}


- (UICollectionView *)filterList {
    
    if (_filterList == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = kFilterListItemSize;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _filterList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _filterList.delegate = self;
        _filterList.dataSource = self;
        
        [_filterList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    }
    return _filterList;
}

@end
