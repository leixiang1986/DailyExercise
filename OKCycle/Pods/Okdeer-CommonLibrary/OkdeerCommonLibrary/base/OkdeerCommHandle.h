//
//  OkdeerCommHandle.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OkdeerCommHandle : NSObject

// --- 获取主线程
void okdeerGetMainQueue(void(^complete)(void));
// --- 获取dispatch_async线程
void okdeerAsyncQueue(NSString *queueName,void(^complete)(void));
// --- dispatch_after 延迟线程
void okdeerAfterTimeQueue(NSTimeInterval timeInterval,void(^complete)(void));

@end
