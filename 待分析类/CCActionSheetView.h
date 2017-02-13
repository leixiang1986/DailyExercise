//
//  CCActionSheetView.h
//  OkdeerUser
//
//  Created by mao wangxin on 2016/12/7.
//  Copyright © 2016年 okdeer. All rights reserved.
//  仿ActionSheet的弹框

#import <UIKit/UIKit.h>


/**
 * 仿ActionSheet的弹框
 */
@interface CCActionSheetView : UIView


#pragma mark - 底部显示直角的ActionSheet

/**
 *  自定义从底部弹出的直角ActionSheet （注意：则取消按钮的buttonIndex为:0, 其他otherButton的Index依次加1）
 *
 *  @param alertViewCallBackBlock 点击按钮回调
 *  @param cancelBlock            点击取消或点击背景退出弹框事件
 *  @param title                  标题->(支持 NSString、NSAttributedString)
 *  @param cancelButtonName       取消按钮标题->(支持 NSString、NSAttributedString)
 *  @param otherButtonTitleArr    其他按钮标题->(支持 NSString、NSAttributedString的混合数组)
 *
 *  @return 返回自定义的ActionSheet实例
 */
+ (instancetype)actionSheetByBottomSquare:(UIAlertViewCallBackBlock)buttonBlock
                              cancelBlock:(void (^)())cancelBlock
                                WithTitle:(id)title
                        cancelButtonTitle:(id)cancelButtonTitle
                      otherButtonTitleArr:(NSArray *)otherButtonTitleArr;



#pragma mark - 底部显示带圆角的ActionSheet

/**
 *  自定义从底部弹出的圆角ActionSheet （注意：则取消按钮的buttonIndex为:0, 其他otherButton的Index依次加1）
 *
 *  @param alertViewCallBackBlock 点击按钮回调
 *  @param cancelBlock            点击取消或点击背景退出弹框事件
 *  @param title                  标题->(支持 NSString、NSAttributedString)
 *  @param cancelButtonName       取消按钮标题->(支持 NSString、NSAttributedString)
 *  @param otherButtonTitleArr    其他按钮标题->(支持 NSString、NSAttributedString的混合数组)
 *
 *  @return 返回自定义的ActionSheet实例
 */
+ (instancetype)actionSheetByBottomCornerRadius:(UIAlertViewCallBackBlock)buttonBlock
                                    cancelBlock:(void (^)())cancelBlock
                                      WithTitle:(id)title
                              cancelButtonTitle:(id)cancelButtonTitle
                            otherButtonTitleArr:(NSArray *)otherButtonTitleArr;


#pragma mark - 顶部显示直角ActionSheet入口

/**
 * 从顶部弹出带圆角的ActionSheet
 */
+ (instancetype)actionSheetByTopSquare:(UIAlertViewCallBackBlock)buttonBlock
                           cancelBlock:(void (^)())cancelBlock
                             superView:(UIView *)superView
                        buttonTitleArr:(NSArray *)buttonTitleArr
                        buttonImageArr:(NSArray *)buttonImageArr;

/**
 *  获取ActionSheet上的指定按钮
 *  注意:index为所有按钮数组的角标(cancelButton的角标为0 ,其他依次加1)
 */
- (UIButton *)buttonAtIndex:(NSInteger)index;


/**
 *  给ActionSheet的指定按钮设置标题
 *  注意:index为所有按钮数组的角标(cancelButton的角标为0 ,其他依次加1)
 *
 *  @param index  所有按钮数组对应的那个角标
 *  @param title  标题->(支持 NSString、NSAttributedString)
 *  @param enable 指定的按钮之后可点击
 */
- (void)setButtonTitleToIndex:(NSInteger)index title:(id)title enable:(BOOL)enable;


/**
 *  主动退出弹框
 *  sender: 可选参数; 传一个对象即响应点击背景回调
 */
- (void)dismissCCActionSheet:(id)sender;

@end


