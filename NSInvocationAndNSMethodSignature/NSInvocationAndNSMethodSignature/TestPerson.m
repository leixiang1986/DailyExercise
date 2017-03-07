//
//  TestPerson.m
//  UnfoldTableView
//
//  Created by 雷祥 on 2017/3/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "TestPerson.h"

@interface TestPerson ()

@end

@implementation TestPerson

-(instancetype)init{
    self = [super init];
    if (self) {
       SEL selectName = @selector(test);
        NSMethodSignature *sig = [self methodSignatureForSelector:selectName];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//        [invocation setTarget:self];
//        [invocation setSelector:selectName];
        _invocation = invocation;
    }

    return self;
}

- (void)addTarget:(nullable id)target action:(nonnull SEL)selector {
    
    [_invocation setSelector:selector];
    [_invocation setTarget:target];
}

- (void)action {
    [self.invocation invoke];
}

- (void)test {
    NSLog(@"自定义的事件");

}

@end
