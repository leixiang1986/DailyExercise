//
//  NSMutableArray+Extension2.m
//  Runtimetest
//
//  Created by 雷祥 on 17/1/3.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "NSMutableArray+Extension2.h"
#import <objc/message.h>

@implementation NSMutableArray (Extension2)

+ (void)load {
    NSLog(@"222===%@==%@",self,[self class]);
    Method method1 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(lx_insertObject:atIndex:));
    Method method2 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:));
    method_exchangeImplementations(method1, method2);
}


- (void)lx_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (self.count >= index) {
        [self lx_insertObject:anObject atIndex:index];
    }
}




@end
