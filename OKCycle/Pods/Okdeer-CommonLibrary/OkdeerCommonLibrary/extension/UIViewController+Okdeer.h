//
//  UIViewController+Okdeer.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Okdeer)

/**
 * 通过控制器获取其导航控制器中的顶层控制器
 */
- (UIViewController *)ok_obtainNavigationVCTopViewController;

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)ok_obtainTopViewController;




@end
