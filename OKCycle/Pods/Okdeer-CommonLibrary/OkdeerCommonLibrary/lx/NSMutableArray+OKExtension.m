//
//  NSMutableArray+CCExtension.m
//  基础框架类
//
//  Created by 雷祥 on 16/12/26.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "NSMutableArray+OKExtension.h"
#import "NSObject+OKRuntime.h"

@implementation NSMutableArray (OKExtension)

+ (void)load {
//    [self ok_exchangeInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(ok_objectAtIndex:)];
    [self ok_exchangeInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(insertObject:atIndex:) otherSelector:@selector(ok_insertObject:atIndex:)];
}

//同时替换可变和不可变的objectAtIndex:方法会在从后台切换到前台时报-[UIKeyboardLayoutStar release]: message sent to deallocated instance错误
//- (id)ok_objectAtIndex:(NSUInteger)index {
//    if (self.count > index) {
//        return [self ok_objectAtIndex:index];
//    }
//
//    return nil;
//}


- (void)ok_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (self.count >= index && anObject) {
        [self ok_insertObject:anObject atIndex:index];
    }
}


@end
