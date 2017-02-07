//
//  TestInitWithFrameView.m
//  Runtimetest
//
//  Created by 雷祥 on 17/1/3.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "TestInitWithFrameView.h"

@implementation TestInitWithFrameView

-(instancetype)init {
   self = [super init];
    NSLog(@"==========%s",__func__);
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"----------%s",__func__);
    return self;
}

@end
