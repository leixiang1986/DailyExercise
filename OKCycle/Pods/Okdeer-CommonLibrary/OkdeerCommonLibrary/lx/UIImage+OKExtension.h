//
//  UIImage+OKExtension.h
//  基础框架类
//
//  Created by 雷祥 on 16/12/27.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImageDataKey @"imageData"
#define kJpgKey @"JPG"

@interface UIImage (OKExtension)
//小方块图片
+ (UIImage *)ok_imageWithColor:(UIColor *)color;

//椭圆图片
+ (UIImage *)ok_imageOfEllipseWithColor:(UIColor *)color inFrame:(CGRect)frame;

//3倍图转2倍图
+ (UIImage *)ok_image2FromImage3:(UIImage*)image;

//重新设置图片大小
+ (UIImage *)ok_resizeImage:(NSString *)imageName viewframe:(CGRect)viewframe resizeframe:(CGRect)sizeframe;

//图片处理  压缩
+ (NSArray *)ok_disposeImagesWithArray:(NSArray *)imageArray;

// 按比例缩放图片
+ (UIImage *)ok_scaleToSize:(UIImage *)img size:(CGSize)size;

//压缩图片
+ (NSData *)ok_compressedData:(CGFloat)compressionQuality image:(UIImage *)image;

//压缩图片
+ (CGFloat)ok_compressionQuality:(UIImage *)image;
@end
