//
//  UIView+OKTool.h
//  OkdeerUser
//
//  Created by mao wangxin on 2017/1/4.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OkDrawLine_top,
    OkDrawLine_left,
    OkDrawLine_bottom,
    OkDrawLine_right,
} OKDrawLinePosition;

@interface UIView (OKTool)

/**
 给当前视图添加线条

 @param position 添加的位置
 @param lineWidth 天条宽度或高度
 @return 添加的线条
 */
-(instancetype)addLineToPosition:(OKDrawLinePosition)position lineWidth:(CGFloat)lineWidth;

/**
 获取当前视图的父视图控制器
 
 @return 控制器
 */
- (UIViewController *)superViewController;

/**
 * 设置圆角，边框宽度和颜色
 */
- (void)ok_setCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**
 * 设置圆角
 */
- (void)ok_setCornerRadius:(CGFloat)radius;

@end
