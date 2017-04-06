//
//  UIColor+OKHexValue.m
//  OkdeerCommonLibrary
//
//  Created by Mac on 16/12/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIColor+OKHexValue.h"

@implementation UIColor (OKHexValue)

/**
 @param rgbValue such as 0x66ccff.
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue
{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

/**
 @param rgbValue  The rgb value such as 0x66CCFF.
 @param alpha from 0.0 to 1.0.
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b) {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newStr = [str stringByTrimmingCharactersInSet:set];
    str = [newStr uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
    }
    return YES;
}

/**
 Example: @"66ccff"
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr
{
    CGFloat r, g, b;
    if (hexStrToRGBA(hexStr, &r, &g, &b)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:1];
    }
    return nil;
}

/**
 Example: @"66ccff"
 @param alpha from 0.0 to 1.0.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    CGFloat r, g, b;
    if (hexStrToRGBA(hexStr, &r, &g, &b)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    }
    return nil;
}

@end
