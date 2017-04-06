//
//  UIBarButtonItem+OKExtension.h
//  Pods
//
//  Created by 雷祥 on 2017/3/8.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,OKNavigationBarType){
    OKNavigationBarTypeLeft     = 0,
    OKNavigationBarTypeRight    = 1
};

@interface UIBarButtonItem (OKExtension)

/**
 * 添加点击的按钮:items到左边还是右边:type,在控制器vc的导航控制器,distance是调整位置的距离为负数是更靠边，为正数就往中间移动
 */
+ (void)ok_addBarButtonItems:(NSArray <UIBarButtonItem *>*)items toNavigation:(OKNavigationBarType)type inVC:(UIViewController *)vc adjustDistance:(CGFloat)distance;

/**
 * 给items添加调整距离,往中间移动为正，靠边为负
 */
+ (NSArray *)ok_barButtonItemsWithItemFixedSpace:(NSArray <UIBarButtonItem *>*)items adjustDistance:(CGFloat)distance;

/**
 *  创建一个BarButtonItem 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (instancetype)ok_barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
