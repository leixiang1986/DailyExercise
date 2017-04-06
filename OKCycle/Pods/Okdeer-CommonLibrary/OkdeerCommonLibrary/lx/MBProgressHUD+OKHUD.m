//
//  MBProgressHUD+OKHUD.m
//  Pods
//
//  Created by 雷祥 on 2017/3/11.
//
//

#import "MBProgressHUD+OKHUD.h"


@implementation MBProgressHUD (OKHUD)
#pragma mark - 显示提示信息

#define keyWindow ([[UIApplication sharedApplication] keyWindow])

+ (void)ok_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view showTime:(NSTimeInterval)delay
{


    if (view == nil) view = keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:delay];
}

/**
 *  显示成功信息
 *
 *  @param success 文字
 *  @param delay   时间
 */
+ (void)ok_showSuccess:(NSString *)success showTime:(NSTimeInterval)delay
{
    [self ok_showSuccess:success toView:nil showTime:delay];
}
/**
 *  显示失败信息
 *
 *  @param error 文字
 *  @param delay   时间
 */
+ (void)ok_showError:(NSString *)error showTime:(NSTimeInterval)delay
{
    [self ok_showError:error toView:nil showTime:delay];
}
/**
 *  显示成功信息
 *
 *  @param success 文字
 *  @param view    哪一个视图
 *  @param delay   时间
 */
+ (void)ok_showSuccess:(NSString *)success toView:(UIView *)view showTime:(NSTimeInterval)delay
{
    [self ok_show:success icon:@"success.png" view:view showTime:delay];
}
/**
 *  显示失败信息
 *
 *  @param error 文字
 *  @param view    哪一个视图
 *  @param delay   时间
 */
+ (void)ok_showError:(NSString *)error toView:(UIView *)view showTime:(NSTimeInterval)delay
{
    [self ok_show:error icon:@"error.png" view:view showTime:delay];
}

#pragma mark - 加载动画

/**
 *  显示HUD
 *
 *  @param message 文字
 *  @param view    哪一个view
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message toView:(UIView *)view
{


    if (view == nil) view = keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;


    return hud;
}

/**
 *  显示HUD   是否需要蒙版效果
 *
 *  @param message 文字
 *  @param view    哪一个view
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message toView:(UIView *)view dimBackground :(BOOL)dimBackground
{


    if (view == nil) view = keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = dimBackground;

    return hud;
}

/**
 *  显示HUD
 *
 *  @param message 文字
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message
{
    return [self ok_animationWithMessage:message toView:nil];
}

/**
 *  显示HUD(显示在上面)  是否需要
 *
 *  @param message 文字
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message dimBackground :(BOOL)dimBackground
{
    return [self ok_animationWithMessage:message toView:nil dimBackground:dimBackground];
}

/**
 *  隐藏HUD
 *
 *  @param view 哪一个view
 */
+ (void)ok_hideHUDForView:(UIView *)view
{


    if (view == nil) view = keyWindow;

    [self hideHUDForView:view animated:YES];
}
/**
 *  隐藏HUD
 *
 *  @param delay 延迟时间
 */
+ (void)ok_hideHUDForView:(UIView *)view timeOut:(NSTimeInterval)delay
{


    if (view == nil) view = keyWindow;

    MBProgressHUD *hud = [self HUDForView:view];

    [hud hideAnimated:YES afterDelay:delay];
}
/**
 *  隐藏HUD
 */
+ (void)ok_hideHUD
{
    [self ok_hideHUDForView:nil];
}
@end
