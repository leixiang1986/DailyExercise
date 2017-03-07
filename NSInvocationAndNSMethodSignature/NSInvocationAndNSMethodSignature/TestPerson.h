//
//  TestPerson.h
//  UnfoldTableView
//
//  Created by 雷祥 on 2017/3/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestPerson : NSObject
{
@public
    NSString *ID;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSInvocation *invocation;

- (void)action;

- (void)addTarget:(nullable id)target action:(nonnull SEL)selector;
@end
