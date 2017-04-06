//
//  UIApplication+OKExtension.m
//  Pods
//
//  Created by 雷祥 on 2017/3/10.
//
//

#import "UIApplication+OKExtension.h"

@implementation UIApplication (OKExtension)

/**
 *  强制隐藏键盘方法
 */
+ (void)ok_hideKeyboard{
    [[[self sharedApplication] keyWindow] endEditing:YES];
    return ;
}
@end
