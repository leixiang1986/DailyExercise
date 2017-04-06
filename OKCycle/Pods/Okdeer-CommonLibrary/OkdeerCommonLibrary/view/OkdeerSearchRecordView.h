//
//  OkdeerSearchRecordView.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

/**
 *
 *  搜索结果记录页面
 *
 **/

#import <UIKit/UIKit.h>

@interface OkdeerSearchRecordView : UIView

@property (nonatomic, strong) NSArray *titleArray;      //数据源

@property (nonatomic, copy) void (^didClickTagAtString)(NSString *title);   //点击触发事件
@property (nonatomic, copy) void (^didTaprecoginizer)();                //手指点击事件
@property (nonatomic, copy) void (^didClickDelAllSource)();                //清除历史记录事件

@end
