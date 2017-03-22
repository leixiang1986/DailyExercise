//
//  NSObject+KVC.m
//  NSInvocationAndNSMethodSignature
//
//  Created by 雷祥 on 2017/3/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "NSObject+KVC.h"
#import <objc/message.h>

@implementation NSObject (KVC)
+ (void)load {
    Method otherMethodOfGet = class_getClassMethod([self class], @selector(ok_valueForUndefinedKey:));
    Method originMethodOfGet = class_getClassMethod([self class], @selector(valueForUndefinedKey:));
    method_exchangeImplementations(originMethodOfGet, otherMethodOfGet);

    Method otherMethodOfSet = class_getClassMethod([self class], @selector(ok_setValue:forUndefinedKey:));
    Method originMethodOfSet = class_getClassMethod([self class], @selector(setValue:forUndefinedKey:));
    method_exchangeImplementations(otherMethodOfSet, originMethodOfSet);
}

- (id)ok_valueForUndefinedKey:(NSString *)key{
    NSLog(@" ok_valueForUndefinedKey:%@",key);
    return nil;
}

- (void)ok_setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue:%@ forUndefinedKey:%@",value,key);
}



@end
