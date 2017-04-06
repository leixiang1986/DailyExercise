//
//  OkdeerCommHandle.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "OkdeerCommHandle.h"

@implementation OkdeerCommHandle

// --- 获取主线程
void okdeerGetMainQueue(void(^complete)(void))
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(complete) complete();
    });
}

// --- 获取dispatch_async线程
void okdeerAsyncQueue(NSString *queueName,void(^complete)(void))
{
    dispatch_async(dispatch_queue_create([queueName UTF8String], NULL), ^{
        if (complete)  complete();
    });
}

// --- dispatch_after 延迟线程
void okdeerAfterTimeQueue(NSTimeInterval timeInterval,void(^complete)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complete) complete();
    });
}

@end
