//
//  OKdeerMJRefreshBackNormalFooter.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/14.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKdeerMJRefreshBackNormalFooter.h"
#import "OkdeerCommDefine.h"

@interface OKdeerMJRefreshBackNormalFooter ()

@property (nonatomic, strong) UILabel *showTipsLabel;       //展示信息label
@property (nonatomic, strong) CALayer *oneCircleLayer;      //第一个球
@property (nonatomic, strong) CALayer *twoCircleLayer;      //第二个球
@property (nonatomic, strong) CABasicAnimation *oneBasicAnimation;  //第一个球动画
@property (nonatomic, strong) CABasicAnimation *twoBasicAnimation;  //第二个球动画

@end

@implementation OKdeerMJRefreshBackNormalFooter

- (void)prepare
{
    [super prepare];
    
    self.stateLabel.hidden = YES;
    self.arrowView.hidden = YES;
    
    // 把转动的圈 隐藏掉
    UIActivityIndicatorView *view = [super valueForKey:@"loadingView"];
    if (view != nil ) {
        view.hidden = YES;
        [view removeFromSuperview];
        view.center = CGPointMake(-2 * self.mj_w, 0);
    }
    else  {
        NSLog(@" view is nil");
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.stateLabel.hidden = YES;
    self.arrowView.hidden = YES;
    
    // 把转动的圈 隐藏掉
    UIActivityIndicatorView *view = [super valueForKey:@"loadingView"];
    if (view != nil ) {
        view.hidden = YES;
        [view removeFromSuperview];
        view.center = CGPointMake(-2 * self.mj_w, 0);
    }
    else  {
        NSLog(@" view is nil");
    }
    
    self.oneCircleLayer.frame = CGRectMake((CGRectGetWidth(self.frame) - 50.0) * 0.5, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
    self.twoCircleLayer.frame = CGRectMake(CGRectGetMaxX(self.oneCircleLayer.frame)+10.0, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
    
    [self addSubview:self.showTipsLabel];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            [self stopAnimation];
            self.showTipsLabel.hidden = NO;
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                //self.showTipsLabel.text = @"刷新完成";
            } completion:^(BOOL finished) {
                //延迟hidden
                [self performSelector:@selector(showTipsLabelHidden) withObject:nil afterDelay:0.6];
                if (self.state != MJRefreshStateIdle) return;
            }];
        } else {
            [self stopAnimation];
        }
    } else if (state == MJRefreshStatePulling) {
        
        self.showTipsLabel.hidden = YES;
        [self stopAnimation];
    } else if (state == MJRefreshStateRefreshing) {
        
        self.showTipsLabel.hidden = YES;
        [self addAnimation];
    } else if (state == MJRefreshStateNoMoreData) {
        
        self.showTipsLabel.hidden = YES;
        [self stopAnimation];
    }
}

#pragma mark - /*** 动画相关 ***/
//第一个圆
- (CALayer *)oneCircleLayer
{
    if (!_oneCircleLayer) {
        _oneCircleLayer = [CALayer layer];
        _oneCircleLayer.frame = CGRectMake((kFullScreenWidth - 50.0) * 0.5, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
        _oneCircleLayer.backgroundColor = UIColorFromHex(0xDF5356).CGColor;
        _oneCircleLayer.cornerRadius = 10.f;
        _oneCircleLayer.hidden = YES;
        [self.layer addSublayer:_oneCircleLayer];
    }
    return _oneCircleLayer;
}
//第二个圆
- (CALayer *)twoCircleLayer
{
    if (!_twoCircleLayer) {
        _twoCircleLayer = [CALayer layer];
        _twoCircleLayer.frame = CGRectMake(CGRectGetMaxX(self.oneCircleLayer.frame)+10.0, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
        _twoCircleLayer.backgroundColor = UIColorFromHex(0xECAB41).CGColor;
        _twoCircleLayer.cornerRadius = 10.f;
        _twoCircleLayer.hidden = YES;
        [self.layer addSublayer:_twoCircleLayer];
    }
    return _twoCircleLayer;
}
//第一个圆动画
- (CABasicAnimation *)oneBasicAnimation
{
    if (!_oneBasicAnimation) {
        _oneBasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _oneBasicAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        _oneBasicAnimation.toValue = [NSNumber numberWithFloat:1.5];
        _oneBasicAnimation.autoreverses = YES;
        _oneBasicAnimation.fillMode = kCAFillModeForwards;
        _oneBasicAnimation.repeatCount = MAXFLOAT;
    }
    return _oneBasicAnimation;
}
//第二个圆动画
- (CABasicAnimation *)twoBasicAnimation
{
    if (!_twoBasicAnimation) {
        _twoBasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _twoBasicAnimation.fromValue = [NSNumber numberWithFloat:1.5];
        _twoBasicAnimation.toValue = [NSNumber numberWithFloat:1.0];
        _twoBasicAnimation.autoreverses = YES;
        _twoBasicAnimation.fillMode = kCAFillModeForwards;
        _twoBasicAnimation.repeatCount = MAXFLOAT;
    }
    return _twoBasicAnimation;
}
//显示文字label
- (UILabel *)showTipsLabel
{
    if (!_showTipsLabel) {
        _showTipsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _showTipsLabel.textAlignment = NSTextAlignmentCenter;
        _showTipsLabel.textColor = UIColorFromHex(0x333333);
        _showTipsLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.showTipsLabel];
    }
    return _showTipsLabel;
}

#pragma mark - /*** 私用方法 ***/
- (void)showTipsLabelHidden
{
    self.showTipsLabel.hidden = YES;
}

/**
 *  加动画
 */
- (void)addAnimation
{
    self.oneCircleLayer.hidden = NO;
    self.twoCircleLayer.hidden = NO;
    [self.oneCircleLayer addAnimation:self.oneBasicAnimation forKey:@"ONEscaleAnimation"];
    [self.twoCircleLayer addAnimation:self.twoBasicAnimation forKey:@"TWOscaleAnimation"];
}

/**
 *  移除动画
 */
- (void)stopAnimation
{
    self.oneCircleLayer.hidden = YES;
    self.twoCircleLayer.hidden = YES;
    [self.oneCircleLayer removeAllAnimations];
    [self.twoCircleLayer removeAllAnimations];
}

@end
