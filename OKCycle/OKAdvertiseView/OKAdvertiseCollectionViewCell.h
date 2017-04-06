//
//  OKAdvertiseCollectionViewCell.h
//  OKAdvertiseView
//
//  Created by 雷祥 on 2017/4/6.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface OKAdvertiseCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, copy, readonly) NSString *imageName;

@property (nonatomic, assign) UIViewContentMode fillMode;       //设置填充模式

- (void)setImage:(UIImage *)image withDefaultImage:(UIImage *)defaultImage;
- (void)setImageName:(NSString *)imageName withDefaultImage:(UIImage *)defaultImage;

@end
