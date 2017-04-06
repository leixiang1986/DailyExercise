//
//  MBProgressHUD+OKHUD.h
//  Pods
//
//  Created by 雷祥 on 2017/3/11.
//
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (OKHUD)
#pragma mark - 显示提示信息
/**
 *  显示成功信息(显示在上面)
 *
 *  @param success 文字
 *  @param delay   时间
 */
+ (void)ok_showSuccess:(NSString *)success showTime:(NSTimeInterval)delay;
/**
 *  显示失败信息(显示在上面)
 *
 *  @param error 文字
 *  @param delay   时间
 */
+ (void)ok_showError:(NSString *)error showTime:(NSTimeInterval)delay;
/**
 *  显示成功信息
 *
 *  @param success 文字
 *  @param view    哪一个视图
 *  @param delay   时间
 */
+ (void)ok_showSuccess:(NSString *)success toView:(UIView *)view showTime:(NSTimeInterval)delay;
/**
 *  显示失败信息
 *
 *  @param error 文字
 *  @param view    哪一个视图
 *  @param delay   时间
 */
+ (void)ok_showError:(NSString *)error toView:(UIView *)view showTime:(NSTimeInterval)delay;

#pragma mark - 加载动画
/**
 *  显示HUD
 *
 *  @param message 文字
 *  @param view    哪一个view
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message toView:(UIView *)view;
/**
 *  显示HUD(显示在上面)
 *
 *  @param message 文字
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message;

/**
 *  显示HUD(显示在上面)  是否需要
 *
 *  @param message 文字
 */
+ (MBProgressHUD *)ok_animationWithMessage:(NSString *)message dimBackground :(BOOL)dimBackground;

/**
 *  隐藏HUD
 *
 *  @param view 哪一个view
 */
+ (void)ok_hideHUDForView:(UIView *)view;
/**
 *  隐藏HUD
 *
 *  @param delay 延迟时间
 */
+ (void)ok_hideHUDForView:(UIView *)view timeOut:(NSTimeInterval)delay ;
/**
 *  隐藏HUD
 */
+ (void)ok_hideHUD;
@end
