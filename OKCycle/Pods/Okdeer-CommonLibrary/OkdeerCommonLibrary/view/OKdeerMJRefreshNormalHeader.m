//
//  OKdeerMJRefreshNormalHeader.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/14.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKdeerMJRefreshNormalHeader.h"
#import "OkdeerCommDefine.h"

@interface OKdeerMJRefreshNormalHeader ()

@property (nonatomic, strong) CALayer *oneCircleLayer;      //第一个球
@property (nonatomic, strong) CALayer *twoCircleLayer;      //第二个球
@property (nonatomic, strong) CABasicAnimation *oneBasicAnimation;  //第一个球动画
@property (nonatomic, strong) CABasicAnimation *twoBasicAnimation;  //第二个球动画

@end

@implementation OKdeerMJRefreshNormalHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    self.arrowView.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    //[self.arrowView removeFromSuperview];
    //[self.lastUpdatedTimeLabel removeFromSuperview];
    
    self.stateLabel.hidden = YES;
    
    // 初始化文字
    [self setTitle:@"下拉实现刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"更新数据中" forState:MJRefreshStateRefreshing];
    
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
    
    self.oneCircleLayer.frame = CGRectMake((self.mj_w - 50.0) * 0.5, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
    self.twoCircleLayer.frame = CGRectMake(CGRectGetMaxX(self.oneCircleLayer.frame)+10.0, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);
    
    self.stateLabel.frame = self.bounds;
    CGFloat arrowCenterX = kFullScreenWidth * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    self.stateLabel.center = arrowCenter;
    
    //if (self.stateLabel.hidden) return;
    
    self.stateLabel.mj_x = 0;
    self.stateLabel.mj_y = self.mj_h * 0.7/2;
    self.stateLabel.mj_w = kFullScreenWidth;
    self.stateLabel.mj_h = self.mj_h * 0.5;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.arrowView.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
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
    
    // 箭头的中心点
    self.stateLabel.frame = self.bounds;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    self.stateLabel.center = arrowCenter;

    CCLog(@"--- W %lf H %lf", self.mj_w, self.mj_h);
    self.oneCircleLayer.frame = CGRectMake((self.mj_w - 50.0) * 0.5, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);

    self.twoCircleLayer.frame = CGRectMake(CGRectGetMaxX(self.oneCircleLayer.frame)+10.0, (self.mj_h - 20.f)*0.5 , 20.f, 20.f);

    if (self.stateLabel.hidden) return;
    
    self.stateLabel.mj_x = 0;
    self.stateLabel.mj_y = self.mj_h * 0.7/2;
    self.stateLabel.mj_w = self.mj_w;
    self.stateLabel.mj_h = self.mj_h * 0.5;


}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            [self stopAnimation];
            self.stateLabel.hidden = NO;
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.stateLabel.text = @"刷新完成";
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                //延迟hidden
                [self performSelector:@selector(stateLabelHidden) withObject:nil afterDelay:0.6];
                if (self.state != MJRefreshStateIdle) return;
            }];
        } else {
            self.stateLabel.hidden = YES;
            [self stopAnimation];
        }
    } else if (state == MJRefreshStatePulling) {
        
        self.stateLabel.hidden = YES;
        [self stopAnimation];
    } else if (state == MJRefreshStateRefreshing) {
        
        self.stateLabel.hidden = YES;
        [self addAnimation];
    }
}

- (void)stateLabelHidden
{
    self.stateLabel.hidden = YES;
}

#pragma mark - /*** 动画相关 ***/
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
        _oneBasicAnimation.toValue = [NSNumber numberWithFloat:1.3];
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
        _twoBasicAnimation.fromValue = [NSNumber numberWithFloat:1.3];
        _twoBasicAnimation.toValue = [NSNumber numberWithFloat:1.0];
        _twoBasicAnimation.autoreverses = YES;
        _twoBasicAnimation.fillMode = kCAFillModeForwards;
        _twoBasicAnimation.repeatCount = MAXFLOAT;
    }
    return _twoBasicAnimation;
}

@end
