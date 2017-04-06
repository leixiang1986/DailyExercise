//
//  OkdeerMMPickerView.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OkdeerMMPickerView : UIView

//关闭View
+ (void)dismissWithCompletion: (void(^)(NSString *))completion;

//显示数据,只显示一维数据
+ (void)showPickerViewInView: (UIView *)view
                  withSource: (NSArray *)sourceArray
                  completion: (void(^)(NSString *selectedString, NSInteger row))completion;

//更变数据源
+ (void)changeWithSourceArray: (NSArray *)sourceArray;

@end
