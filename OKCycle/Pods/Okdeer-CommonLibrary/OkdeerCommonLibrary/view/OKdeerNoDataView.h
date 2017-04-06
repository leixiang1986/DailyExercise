//
//  OKdeerNoDataView.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/16.
//  Copyright © 2017年 OKDeer. All rights reserved.
//


/**
 *  暂无数据, 来自用户版
 */

#import <UIKit/UIKit.h>

@interface OKdeerNoDataView : UIView

/**
 *  加载错误的页面上的数据
 *
 *  @param text  文字
 *  @param image 图片
 */
- (void)loadText:(NSString *)text image:(UIImage *)image;

/**
 * 获取最底部的UIView
 */
- (UIView *)obtainBottomView;


+ (instancetype)initWithText:(NSString *)text image:(UIImage *)image inSuperView:(UIView *)superView show:(BOOL)show;

/**
 *  加载默认文字和图片
 *
 *  @param superView 父view
 */
+ (instancetype)showWithDefaultInSuperView:(UIView *)superView show:(BOOL)show;

/**
 *  隐藏
 */
- (void)hide;

@end
