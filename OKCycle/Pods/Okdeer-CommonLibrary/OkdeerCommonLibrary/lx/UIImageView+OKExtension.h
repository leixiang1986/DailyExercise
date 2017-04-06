//
//  UIImageView+OKExtension.h
//  基础框架类
//
//  Created by 雷祥 on 16/12/27.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (OKExtension)
@property (nonatomic, strong) UIColor *renderColor;     /**< 渲染颜色替换了图片渲染颜色也在 */
/**
 * 设置图片，网络图片或本地图片名
 */
- (void)ok_setImageWithString:(NSString *)image withDefaultImage:(UIImage *)defaultImage;
@end
