//
//  UIButton+ImageAndTitleDisplay.h
//  基本控件
//
//  Created by 雷祥 on 17/2/10.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OKButtonImageAndTitleDisplayType) {
    OKButtonImageAndTitleDisplayTypeImageLeft   = 0,
    OKButtonImageAndTitleDisplayTypeImageUp     = 1,
    OKButtonImageAndTitleDisplayTypeImageDown   = 2,
    OKButtonImageAndTitleDisplayTypeImageRight  = 3
};


@interface UIButton (ImageAndTitleDisplay)
@property (nonatomic, assign, readonly) BOOL hasAddObserver;
@property (nonatomic, assign, readonly) OKButtonImageAndTitleDisplayType displayType;         /**< 图片和titleLabel位置布局类型 */
@property (nonatomic, assign, readonly) NSInteger spacing;                                    /**< 图片和titleLabel的间距，在只有图片或者只有文字时，此值无效（因为设置为CGFloat会崩溃暂时用NSInteger） */


- (void)setDisplayType:(OKButtonImageAndTitleDisplayType)displayType withSpace:(CGFloat)spacing;

@end
