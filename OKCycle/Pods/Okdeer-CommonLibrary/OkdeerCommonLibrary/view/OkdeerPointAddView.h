//
//  OkdeerPointAddView.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

/**
 *
 *  添加积分页面,以及动效
 *
 **/

#import <UIKit/UIKit.h>

@interface OkdeerPointAddView : UIView

/**
 *  显示积分增加动效
 *
 *  @param point 积分
 */
- (void)showCustomPointAddView:(NSString *)point;
/**
 *  隐藏积分增加动效
 */
- (void)hideCustomPointAddView;


/**
 *  设置积分值
 */
@property (copy, nonatomic) NSString *pointVal;     /**< 积分值 */

@end
