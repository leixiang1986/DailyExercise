//
//  OkdeerAnimation.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkdeerAnimation.h"
#import "OkdeerCommonLibrary.h"
#import "UIViewController+Okdeer.h"

#define kLayerW     30     // layer 的宽度
#define kLayerH     30     // layer 的高度
#define kLayerSpace 5      // 间距
#define kTitleSpace 15     // 提示语 距左 距右的间距
#define kTitleTopSpace  10  // 提示语 距 上控件的间距
#define kTitleFont   16     // 提示语的字体大小
#define kMaxLine    1000000

@interface OkdeerAnimation ()

@property (nonatomic, strong) UIView *animationContentView;     /**< 动画的遮盖层view*/
@property (nonatomic, strong) OkdeerAnimationView *animationView;    /**< 动画的view */

@end

@implementation OkdeerAnimation

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static OkdeerAnimation *animation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animation = [super allocWithZone:zone];
    });
    return animation;
}

/**
 *  获取对象
 */
+ (instancetype)instanceAnimation
{
    return [[self alloc] init];
}

- (UIView *)animationContentView
{
    if (!_animationContentView) {
        _animationContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _animationContentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _animationContentView;
}

- (OkdeerAnimationView *)animationView
{
    if (!_animationView) {
        _animationView = [[OkdeerAnimationView alloc] initWithFrame:CGRectMake(0, 0, 118, 86) minValue:(CGFloat)(2.00f/3.00f) maxValue:(CGFloat)(4.00f/3.00f) duration:0.65 repeatCount:HUGE_VALF];
        //[_animationView setupCorneradius:5];
        _animationView.layer.cornerRadius = 5.f;
        _animationView.layer.masksToBounds = YES;
    }
    return _animationView;
}


/**
 *  创建动画的view
 */
- (void)setupView:(UIView *)view fullScreen:(BOOL)fullScreen
{
    CGFloat sy = 0.0f;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGFloat tabbarHeigth = 0.0f;
    CGFloat viewHeight = 0.0f;
    if (fullScreen) {
        sy = 0.0f;
        view = window;
        viewHeight = kFullScreenHeight;
    }else{
        if (view && ![view isKindOfClass:[UIWindow class]]) {
            sy = 0.0f;
            viewHeight = CGRectGetHeight(view.frame);
        }else{
            view = window;
            viewHeight = CGRectGetHeight(view.frame);
            UIViewController *lastViewController  = [UIViewController ok_obtainTopViewController];
            
            if ([lastViewController.navigationController respondsToSelector:@selector(pushViewController:animated:)] || [lastViewController isKindOfClass:[UINavigationController class]]) {
                // 当前控制器为导航栏控制器
                if ([lastViewController isKindOfClass:[UINavigationController class]]) {
                    if ([(UINavigationController *)lastViewController navigationBar].isHidden) {
                        // 导航栏 隐藏
                        sy = kStatusBarHeight;
                    }else{
                        // 导航栏  不隐藏
                        sy = kStatusBarAndNavigationBarHeight;
                    }
                }else{
                    if (lastViewController.navigationController.navigationBar.isHidden) {
                        // 导航栏 隐藏
                        sy = kStatusBarHeight;
                    }else{
                        // 导航栏  不隐藏
                        sy = kStatusBarAndNavigationBarHeight;
                    }
                }
                
            }else{
                sy = kStatusBarHeight;
            }
            if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController  *tabBarController = (UITabBarController *)window.rootViewController;
                if (tabBarController.tabBar.isHidden) {
                    tabbarHeigth = 0;
                }else{
                    tabbarHeigth = kTabbarHeight;
                }
            }
        }
    }
    
    [self.animationContentView removeFromSuperview];
    [self.animationView removeFromSuperview];
    
    [view addSubview:self.animationContentView];
    self.animationContentView.frame = CGRectMake(0, sy, CGRectGetWidth(view.frame), viewHeight - sy - tabbarHeigth);
    
    [self.animationContentView addSubview:self.animationView];
    
    [self addConstraintInAnimationContentView:sy bottom:tabbarHeigth view:view];
    [self addConstraintInAnimationView];
    
    [self.animationView addAnimation];
    [self.animationContentView.superview bringSubviewToFront:self.animationContentView];
}
/**
 * 添加约束到animationContentView
 */
- (void)addConstraintInAnimationContentView:(CGFloat)y  bottom:(CGFloat)bottom view:(UIView *)view{
    self.animationContentView.translatesAutoresizingMaskIntoConstraints = false;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.animationContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.animationContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.animationContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:y]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.animationContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom]];
}
/**
 * 添加约束到 animationView
 */
- (void)addConstraintInAnimationView{
    self.animationView.translatesAutoresizingMaskIntoConstraints = false;
    [self.animationContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.animationContentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.animationContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.animationContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.animationContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:118]];
    [self.animationContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:86]];
}

/**
 *  开启动画
 *
 *  @param view       动画加到哪个view  view为nil只加到window
 *  @param fullScreen 是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationToView:(UIView *)view fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime
{
    [self startAnimationToView:view message:@"" fullScreen:fullScreen stopAnimationTime:stopAnimationTime];
}

/**
 *  开启动画 有提示语的  适用于列表 详情
 *  @param view       动画加到哪个view  view为nil加到window
 *  @param message    提示语
 *  @param fullScreen 是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationToView:(UIView *)view message:(NSString *)message fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime
{
    [self setupView:view fullScreen:fullScreen];
    self.animationView.text = message;
    self.animationContentView.backgroundColor = [UIColor whiteColor];
    self.animationView.backgroundColor = [UIColor clearColor];
    if (stopAnimationTime > 0 ) {
        [self performSelector:@selector(stopAnimation:) withObject:nil afterDelay:stopAnimationTime];
    }
    
}

/**
 *  开启动画  有提示语  适用于提交的
 *
 *  @param view              动画加到哪个view  view为nil加到window
 *  @param message           提示语
 *  @param fullScreen        是否全屏  若为yes全屏的 动画直接加到window上 为no 不全屏  view不为nil  则加到这个view 并以这个view 的宽高为主  view为nil 加到window 但是动画区域会减掉导航栏上的高度 和若有tabbar 也会一起减掉的
 *  @param stopAnimationTime 停止动画的时间   0 为不自动停止动画
 */
- (void)startAnimationSubmitToView:(UIView *)view message:(NSString *)message fullScreen:(BOOL)fullScreen stopAnimationTime:(NSTimeInterval)stopAnimationTime
{
    [self startAnimationToView:view message:message fullScreen:fullScreen stopAnimationTime:stopAnimationTime];
    self.animationContentView.backgroundColor = [UIColor clearColor];
    self.animationView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
}

/**
 *   停止动画
 *
 *  @param duration  需要停止动画的时间
 *  @param stopBlock 停止后的回调
 */
- (void)stopAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))stopBlock
{
    if (duration == 0 || duration < 0.1) {
        [self stopAnimation:stopBlock];
    }else{
        __block NSTimeInterval dueationTime = duration;
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            if (dueationTime <= 0 ) {
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopAnimation:stopBlock];
                });
            }else{
                dueationTime = dueationTime - 0.1;
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        });
        dispatch_resume(timer);
    }
}
/**
 *  停止动画
 */
- (void)stopAnimation:(void(^)(void))complete
{
    
    [self.animationView stopAnimation];
    [self.animationContentView removeFromSuperview];
    [self.animationView removeFromSuperview];
    self.animationContentView.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complete) {
            complete();
        }
    });
}

/**
 *  动画中
 */
- (void)animationLoading{
    if (self.animationContentView.superview) {
        [self.animationView addAnimation];
        [self.animationContentView.superview bringSubviewToFront:self.animationContentView];
    }
}

@end



@interface OkdeerAnimationView ()

@property (nonatomic, strong) CALayer *firstRoundLayer;    /**< 第一圆 */
@property (nonatomic, strong) CALayer *secondRoundLayer;   /**< 第二个圆 */
@property (nonatomic, assign) CGFloat minValuel;           /**< 最小的比例 */
@property (nonatomic, assign) CGFloat maxValue;            /**< 最大的比例 */
@property (nonatomic, assign) NSTimeInterval duration;     /**< 动画时间 */
@property (nonatomic, assign) float repeatCount;           /**< 重复次数 */
@property (nonatomic, strong) UILabel *titleLabel;         /**< 提示语 */
@property (nonatomic,strong) CAKeyframeAnimation *firstAnimation;   /**< 第一个动画*/
@property (nonatomic,strong) CAKeyframeAnimation *secondAnimation;   /**< 第二个动画*/

@end


@implementation OkdeerAnimationView

/**
 *  初始化动画控件  minValue 最小的比例   maxValue 最大的比例  duration 动画时间  repeatCount 重复次数
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue duration:(NSTimeInterval)duration repeatCount:(float)repeatCount
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValuel = minValue;
        _maxValue = maxValue;
        _duration = duration;
        _repeatCount = repeatCount;
        [self setupLayer];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _titleLabel.text = _text;
    [self layoutSubviews];
}

/**
 *  设置layer
 */
- (void)setupLayer
{
    if (!_firstRoundLayer) {
        _firstRoundLayer = [CALayer layer];
        _firstRoundLayer.frame = CGRectMake(kLayerSpace, (CGRectGetHeight(self.frame) - kLayerH ) / 2.0f, kLayerW, kLayerH);
        _firstRoundLayer.backgroundColor = UIColorFromHex(COLOR_DF5356).CGColor;
        _firstRoundLayer.cornerRadius = kLayerH / 2;
        [self.layer addSublayer:_firstRoundLayer];
    }
    
    if (!_secondRoundLayer) {
        _secondRoundLayer = [CALayer layer];
        _secondRoundLayer.frame = CGRectMake(CGRectGetMaxX(_firstRoundLayer.frame) + kLayerSpace, (CGRectGetHeight(self.frame) - kLayerH ) / 2.0f, kLayerW, kLayerH);
        _secondRoundLayer.backgroundColor = UIColorFromHex(COLOR_ECAB41).CGColor;
        _secondRoundLayer.cornerRadius = kLayerH / 2 ;
        [self.layer addSublayer:_secondRoundLayer];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), kTitleFont)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
}

//第一个动画
- (CAKeyframeAnimation *)firstAnimation {
    if (!_firstAnimation) {
        _firstAnimation = [self obtainAnimationToMinValue:_minValuel maxValue:_maxValue currentValue:_maxValue spaceVaule:(_maxValue - _minValuel) duration:_duration repeatCount:_repeatCount];
    }
    return _firstAnimation;
}
//第二个动画
- (CAKeyframeAnimation *)secondAnimation
{
    if (!_secondAnimation) {
        _secondAnimation = [self obtainAnimationToMinValue:_minValuel maxValue:_maxValue currentValue:_minValuel spaceVaule:(_maxValue - _minValuel) duration:_duration repeatCount:_repeatCount];
    }
    return _secondAnimation;
}
/**
 *  加动画
 */
- (void)addAnimation
{
    [_firstRoundLayer addAnimation:self.firstAnimation forKey:@"firstAnimation"];
    [_secondRoundLayer addAnimation:self.secondAnimation forKey:@"secondAnimation"];
}
/**
 *   停止动画
 */
- (void)stopAnimation
{
    [_firstRoundLayer removeAllAnimations];
    [_secondRoundLayer removeAllAnimations];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _firstRoundLayer.frame = CGRectMake((CGRectGetWidth(self.frame) - 2 * kLayerW - kLayerSpace) / 2.0f, (CGRectGetHeight(self.frame) - kLayerH - (_text.length > 0 ? kTitleFont + kTitleTopSpace : 0)) / 2.0f, kLayerW, kLayerH);
    _secondRoundLayer.frame = CGRectMake(CGRectGetMaxX(_firstRoundLayer.frame) + kLayerSpace,CGRectGetMinY(_firstRoundLayer.frame), kLayerW, kLayerH);
    _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_firstRoundLayer.frame) + kTitleTopSpace, CGRectGetWidth(self.frame), kTitleFont);
}

/**
 *  控件  放大  缩小    动画变回默认的状态   minValue 缩小最小的值  maxValue 放大到最大的值  currentValue  当前的值  spaceValue  变回的间距  duration 动画时间  repeatCount 重复的次数  （注  minValue maxValue currentValue 这里是控件的比例  例如 0.5 就是控件原来的一半）
 */
- (CAKeyframeAnimation *)obtainAnimationToMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue currentValue:(CGFloat)currentValue spaceVaule:(CGFloat)spaceValue duration:(NSTimeInterval)duration repeatCount:(float)repeatCount
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
    
    BOOL canRun = YES;                // 是否循环  yes 为循环  no 跳出循环
    
    BOOL isAdd = YES;   // 是否加 还是减  yes 为加 no 为减
    [valuesArray  addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(currentValue,currentValue,1.0) ]];
    if (currentValue >= maxValue) {
        // 当前的值等于最大值  为减
        currentValue = maxValue;
        isAdd = NO;
    }else if (currentValue <= minValue){
        currentValue = minValue;
        isAdd = YES;
    }
    CGFloat nowValue = currentValue;   // 当前的值赋给临时的值
    if (isAdd) {
        nowValue = nowValue + spaceValue;
    }else{
        nowValue = nowValue - spaceValue;
    }
    while (canRun) {
        [valuesArray addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(nowValue, nowValue, 1.0)]];
        // 判断nowValue 等于最大的值  是 加  否则是否等于最小的值  为减
        if (nowValue >= maxValue) {
            nowValue = maxValue;
            isAdd = NO;
        }else if (nowValue <= minValue){
            nowValue = minValue;
            isAdd = YES;
        }
        
        if (isAdd) {
            nowValue = nowValue + spaceValue;
        }else{
            nowValue = nowValue - spaceValue;
        }
        // 判断 nowValue 是否等于当前的值 并且是加   跳出循环
        if (nowValue == currentValue  && isAdd) {
            canRun = NO;
        }else if ((nowValue == minValue || nowValue == maxValue) && nowValue == currentValue){
            // 判断 nowValue 是否等于 当前的值  并且  nowValue 等于最小值或等于最大值   跳出循环
            canRun = NO;
        }
        
    }
    [valuesArray addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(currentValue, currentValue, 1.0)]];
    animation.values = valuesArray;
    return animation;
}

@end
