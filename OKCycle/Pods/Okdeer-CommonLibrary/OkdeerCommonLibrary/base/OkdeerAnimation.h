//
//  OkdeerAnimation.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OkdeerAnimation : NSObject

/**
 *  获取对象
 */
+ (instancetype)instanceAnimation;

/**
 *  开启动画
 *
 *  @param view       动画加到哪个view  view为nil加到window
 *  @param fullScreen 是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationToView:(UIView *)view fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime;
/**
 *  开启动画 有提示语的  适用于列表 详情
 *  @param view       动画加到哪个view  view为nil加到window
 *  @param message    提示语
 *  @param fullScreen 是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationToView:(UIView *)view message:(NSString *)message fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime;
/**
 *  开启动画  有提示语  适用于提交的
 *
 *  @param view              动画加到哪个view  view为nil加到window
 *  @param message           提示语
 *  @param fullScreen        是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationSubmitToView:(UIView *)view message:(NSString *)message fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime;

/**
 *   停止动画
 *
 *  @param duration  需要停止动画的时间
 *  @param stopBlock 停止后的回调
 */
- (void)stopAnimationWithDuration:(NSTimeInterval)duration completion:(void(^)(void))stopBlock;
/**
 *  动画中
 */
- (void)animationLoading;

@end


@interface OkdeerAnimationView : UIView

@property (nonatomic,copy) NSString *text;
/**
 *  初始化动画控件  minValue 最小的比例   maxValue 最大的比例  duration 动画时间  repeatCount 重复次数
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue duration:(NSTimeInterval)duration repeatCount:(float)repeatCount;
/**
 *  加动画
 */
- (void)addAnimation;
/**
 *  停止动画
 */
- (void)stopAnimation;

@end
