//
//  CCAlertView.h
//  Okdeer-jieshun-parkinglot
//
//  Created by mao wangxin on 2016/11/15.
//  Copyright © 2016年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (Block)<UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                         title:(NSString *)title
                       message:(NSString *)message
              cancelButtonName:(NSString *)cancelButtonName
             otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end



/**
 *  兼容iOS7的UIAlertView、ActionSheet的系统弹框
 */
@interface CCAlertView : UIView

/**
 *  iOS的系统弹框, 已兼容iOS7的UIAlertView;
 *  注意:如果有设置cancelButton, 则取消按钮的buttonIndex为:0, 其他otherButton的Index依次加1;
 *  @param alertViewCallBackBlock 点击按钮回调Block
 */
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                         title:(NSString *)title message:(NSString *)message
              cancelButtonName:(NSString *)cancelButtonName
             otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION ;

/**
 *  系统Alert弹框,自动消失
 *
 *  @msg 提示文字
 */
void showAlertToast(NSString *msg);


#pragma mark ========================= 系统带输入的UIAlertView弹框 ========================

+ (void)inputAlertWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                cancelTitle:(NSString *)cancelTitle
                 otherTitle:(NSString *)otherTitle
                buttonBlock:(void (^)(NSString *inputText))buttonBlock
                cancelBlock:(void (^)())cancelBlock;


/**
 *  返回字符串Size
 */
+(CGSize)stringSize:(NSString *)string andFont:(UIFont *)fontsize andwidth:(CGFloat)numsize;

/**
 *  校验一个类是否有该属性
 */
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name;

@end

