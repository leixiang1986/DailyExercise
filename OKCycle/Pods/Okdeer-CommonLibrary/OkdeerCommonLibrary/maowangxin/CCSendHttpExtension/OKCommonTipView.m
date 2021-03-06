//
//  CCParkingRequestTipView.m
//  OkdeerUser
//
//  Created by mao wangxin on 2016/11/24.
//  Copyright © 2016年 okdeer. All rights reserved.
//

#import "OKCommonTipView.h"
#import "UIButton+OKExtension.h"
#import "UIView+OKExtension.h"
#import "OkdeerCommDefine.h"

@implementation MBProgressHUD (Extension)

#pragma mark - 弹框在指定view上

/**
 *  获取子view
 */
+ (UIView *)getHUDFromSubview:(UIView *)addView
{
    if (addView) {
        for (UIView *tipVieww in addView.subviews) {
            if ([tipVieww isKindOfClass:[MBProgressHUD class]]) {
                if (tipVieww.superview) {
                    [tipVieww removeFromSuperview];
                }
            }
        }
    } else {
        addView = [UIApplication sharedApplication].keyWindow;
    }
    return addView;
}

/**
 *  隐藏指定view上创建的MBProgressHUD
 */
+ (void)hideLoadingFromView:(UIView *)view
{
    for (UIView *tipView in view.subviews) {
        if ([tipView isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *HUD = (MBProgressHUD *)tipView;
            if (tipView.superview) {
                [tipView removeFromSuperview];
            }
            [HUD showAnimated:YES];
        }
    }
}

/**
 *  在指定view上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法)
 *
 *  @param tipStr 提示语
 */
+ (void)showLoadingWithView:(UIView *)addView text:(NSString *)tipStr
{
    addView = [self getHUDFromSubview:addView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.userInteractionEnabled = NO;
    HUD.label.text = tipStr;
    [HUD showAnimated:YES];
}

@end


@implementation OKCommonTipView

/**
 *  根据类型显示提示view
 */
+ (UIView *)tipViewByFrame:(CGRect)frame tipImageName:(NSString *)imageName tipText:(id)tipText actionTitle:(NSString *)actionTitle actionBlock:(void(^)())touchBlock
{
    OKCommonTipView *tipBgView = [[OKCommonTipView alloc] initWithFrame:frame];
    tipBgView.tag = kRequestTipViewTag;
    tipBgView.backgroundColor = UIColorFromHex(0xf5f6f8);
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    //中间文字
    UILabel *_tipLabel = nil;
    if (tipText) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont boldSystemFontOfSize:14];
        _tipLabel.textColor = UIColorFromHex(0x666666);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [tipBgView addSubview:_tipLabel];
        
        if ([tipText isKindOfClass:[NSString class]]) {
            _tipLabel.text = tipText;
        } else if ([tipText isKindOfClass:[NSAttributedString class]]) {
            _tipLabel.attributedText = tipText;
        }
        [_tipLabel sizeToFit];
        _tipLabel.x = (frame.size.width - _tipLabel.width)/2;
        _tipLabel.y = frame.size.height *0.4;
    }
    
    //顶部图片
    UIImageView *_tipImageView = nil;
    if (image && _tipLabel) {
        CGFloat tipImageX = (frame.size.width-image.size.width)/2;
        _tipImageView = [[UIImageView alloc] initWithImage:image];
        _tipImageView.frame = CGRectMake(tipImageX, 0, image.size.width, image.size.height);
        [tipBgView addSubview:_tipImageView];
        _tipImageView.y = CGRectGetMinY(_tipLabel.frame) - (_tipImageView.height);
        _tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    //底部按钮
    if (actionTitle && touchBlock && _tipLabel) {
        CGFloat actionBtnW = 80;
        CGFloat actionBtnX = (frame.size.width - actionBtnW)/2;
        CGFloat actionBtnY = CGRectGetMaxY(_tipLabel.frame) + 15;
        UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(actionBtnX, actionBtnY, actionBtnW, 30)];
        [actionBtn setTitle:actionTitle forState:0];
        actionBtn.backgroundColor = [UIColor whiteColor];
        actionBtn.layer.cornerRadius = 6;
        actionBtn.layer.borderColor = UIColorFromHex(0x666666).CGColor;
        actionBtn.layer.borderWidth = 1;
        [actionBtn setTitleColor:UIColorFromHex(0x666666) forState:0];
        actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [actionBtn addTouchUpInsideHandler:^(UIButton *btn) {
            touchBlock();
        }];
        [tipBgView addSubview:actionBtn];
    }
    return tipBgView;
}

@end
