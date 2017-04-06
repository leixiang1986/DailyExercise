//
//  OkdeerPointAddView.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkdeerPointAddView.h"
#import "OkdeerCommonLibrary.h"
#import "OkdeerBundleHelp.h"

@interface OkdeerPointAddView ()

@property (strong, nonatomic) UIImageView *pointAddImageView;       /**< 积分增加图片 */
@property (strong, nonatomic) UILabel *pointAddLbl;     /**< 积分增加 */
@property (strong, nonatomic) UIWindow *window;     /**<  */

@end

@implementation OkdeerPointAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _window = [[UIApplication sharedApplication].delegate window];
        [self initViews];
    }
    return self;
}

#pragma mark - /*** 设置积分值 ***/
- (void)setPointVal:(NSString *)pointVal
{
    if ([pointVal intValue]) {
        [self showCustomPointAddView:pointVal];
    }
}

#pragma mark - /*** 功能事件 ***/
/**
 *  显示积分增加动效
 *
 *  @param point 积分
 */
- (void)showCustomPointAddView:(NSString *)point
{
    [_window addSubview:self];
    //---
    [self addSubview:self.pointAddImageView];
    self.hidden = NO;
    self.pointAddLbl.text = [NSString stringWithFormat:@"+%@积分",point];
    self.pointAddImageView.hidden = YES;
    
    //参数调试.
    [UIView animateWithDuration:0.7
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.pointAddImageView.hidden = NO;
                     } completion:^(BOOL finished){
                         [self performSelector:@selector(hideCustomPointAddView) withObject:nil afterDelay:1.8];
                     }];
}
/**
 *  隐藏积分增加动效
 */
- (void)hideCustomPointAddView
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.pointAddImageView removeFromSuperview];
                         self.hidden = YES;
                     } completion:^(BOOL finished){
                         
                     }];
    //----
    [self removeFromSuperview];
}

#pragma mark - /*** 初始化UI ***/
- (void)initViews
{
    //增加背景 黑色 0.7透明度背景View
    UIView *backGroudView = [[UIView alloc] initWithFrame:self.frame];
    backGroudView.backgroundColor = [UIColor whiteColor];
    backGroudView.alpha = 0.1;
    [self addSubview:backGroudView];
    
    [self addSubview:self.pointAddImageView];
    [self.pointAddImageView addSubview:self.pointAddLbl];
    self.hidden = YES;
}

#pragma mark - /*** 懒加载数据 ***/
//积分展示背景
- (UIImageView *)pointAddImageView
{
    if (!_pointAddImageView) {
        _pointAddImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kFullScreenWidth - 125)/2, (kFullScreenHeight - 60)/2, 125, 60)];
        _pointAddImageView.image = GetImagefrombundle(@"view", nil, @"share_pointAdd@2x");
        //_pointAddImageView.image = GetUIImageInPodeName(@"imageBundle", @"share_pointAdd@2x");
    }
    return _pointAddImageView;
}

//积分内容
- (UILabel *)pointAddLbl
{
    if (!_pointAddLbl) {
        _pointAddLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 23, 80, 20)];
        _pointAddLbl.textColor = UIColorFromHex(0xffffff);
        _pointAddLbl.font = [UIFont systemFontOfSize:12];
        _pointAddLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _pointAddLbl;
}

@end
