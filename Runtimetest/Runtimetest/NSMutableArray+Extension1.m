//
//  NSMutableArray+Extension1.m
//  Runtimetest
//
//  Created by 雷祥 on 17/1/3.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "NSMutableArray+Extension1.h"
#import <objc/message.h>

@implementation NSMutableArray (Extension1)
+ (void)load {
    NSLog(@"111===%@==%@",self,[self class]);
    Method method1 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
    Method method2 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(lx_objectAtIndex:));
    method_exchangeImplementations(method1, method2);
}

- (id)lx_objectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self lx_objectAtIndex:index];
    }

    return nil;
}
@end
