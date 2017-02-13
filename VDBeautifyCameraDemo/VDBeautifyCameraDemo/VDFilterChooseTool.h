//
//  FilterChooseTool.h
//  VDBeautifyCameraDemo
//
//  Created by niepengpeng on 17/2/13.
//  Copyright © 2017年 VD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^ClickCompletion)(UIImage *outImage);

@interface VDFilterChooseTool : NSObject

/**
 *  单例
 *
 *  @return VDCameraAndPhotoTool对象
 */
+ (instancetype)shareInstance;

- (void)showFilterListWithInputImage:(UIImage *)inputImage andClickCompletion:(ClickCompletion)clickCompletion;

@end
