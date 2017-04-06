//
//  UIColor+OKHexValue.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 16/12/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OKHexValue)

/**
 @param rgbValue such as 0x66ccff.
 */
+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue;

/**
 @param rgbValue  The rgb value such as 0x66CCFF.
 @param alpha from 0.0 to 1.0.
 */
+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
    Example: @"66ccff"
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

/**
    Example: @"66ccff"
    @param alpha from 0.0 to 1.0.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
