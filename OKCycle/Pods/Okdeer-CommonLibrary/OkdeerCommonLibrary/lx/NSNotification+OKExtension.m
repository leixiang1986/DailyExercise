//
//  NSNotification+OKExtention.m
//  OkdeerSeller
//
//  Created by 雷祥 on 17/3/2.
//  Copyright © 2017年 CloudCity. All rights reserved.
//

#import "NSNotification+OKExtension.h"

@implementation NSNotification (OKExtension)
/**
 * 获取键盘高度
 */
- (CGFloat)ok_getKeyboardHeight {
    NSDictionary *info = [self userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    return keyboardSize.height ;
}

@end
