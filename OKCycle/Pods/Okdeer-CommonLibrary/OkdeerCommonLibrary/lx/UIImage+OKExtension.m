//
//  UIImage+OKExtension.m
//  基础框架类
//
//  Created by 雷祥 on 16/12/27.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "UIImage+OKExtension.h"
//#import "qrencode.h"

#define LEN_100 100 * 1000.0
#define LEN_150 150 * 1000.0
#define LEN_300 300 * 1000.0
#define LEN_500 500 * 1000.0

@implementation UIImage (OKExtension)

+ (UIImage *)ok_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

//椭圆图片
+ (UIImage *)ok_imageOfEllipseWithColor:(UIColor *)color inFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, frame);

    CGContextAddEllipseInRect(context, frame);
    [color set];
    CGContextFillPath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage*)ok_image2FromImage3:(UIImage*)image;
{
    if ([UIScreen mainScreen].scale == 3.0)
    {
        return image;
    }

    CGSize newSize = CGSizeMake(image.size.width*2.f/3.f, image.size.height*2.f/3.f);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

+ (UIImage *)ok_resizeImage:(NSString *)imageName viewframe:(CGRect)viewframe resizeframe:(CGRect)sizeframe
{
    UIGraphicsBeginImageContext(viewframe.size);
    [[UIImage imageNamed:imageName] drawInRect:sizeframe];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  图片处理  压缩
 */
+ (NSArray *)ok_disposeImagesWithArray:(NSArray *)imageArray
{
    NSMutableArray *fileDataMArray = [NSMutableArray array];

    for (UIImage *image in imageArray) {
        CGFloat quality = [self ok_compressionQuality:image];
        UIImage *newImage = nil;
        NSMutableDictionary *fileDataMDictionary = [NSMutableDictionary dictionary];

        if (quality < 0.4) {
            CGSize size = CGSizeMake(800, 800 * (image.size.height/image.size.width));
            newImage = [self ok_scaleToSize:image size:size];
        }
        else {
            newImage = image;
        }

        NSData *imageData = [self ok_compressedData:quality image:newImage];
        BOOL isJPG = NO;
        if (imageData) {
//            CCLog(@"is jpg");
            isJPG = YES;
        } else {
            isJPG = NO;
            imageData = UIImagePNGRepresentation(image);
//            CCLog(@"is png");
        }
        if (!imageData) {
//            CCLog(@"error 格式不对，不是jpg或者png");
        }
        [fileDataMDictionary setObject:[NSNumber numberWithBool:isJPG] forKey:kJpgKey];
        if (imageData) {
            [fileDataMDictionary setObject:imageData forKey:kImageDataKey];
        }


        [fileDataMArray addObject:[fileDataMDictionary copy]];
    }
    return [fileDataMArray copy];
}


+ (UIImage *)ok_scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

//压缩图片
+ (NSData *)ok_compressedData:(CGFloat)compressionQuality image:(UIImage *)image
{
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    return UIImageJPEGRepresentation(image, compressionQuality);
}

+ (CGFloat)ok_compressionQuality:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }

    NSUInteger dataLength = [data length];

    if(dataLength > LEN_100) {
        if (dataLength > LEN_500) {
            return 0.3;
        } else if (dataLength > LEN_300) {
            return  0.45;
        } else if (dataLength > LEN_150){
            return  0.65;
        } else {
            return 0.9;
        }
    } else {
        return 1.0;
    }
}



@end
