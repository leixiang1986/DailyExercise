//
//  CopyTestModel.m
//  BasicTest
//
//  Created by 雷祥 on 17/2/10.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "CopyTestModel.h"

@implementation CopyTestModel
- (void)setNameOfCopy:(NSString *)nameOfCopy {
//    _nameOfCopy = nameOfCopy; //这样无论是可变字符串还是不可变字符串，得到的都是原来的地址－－错误写法
    _nameOfCopy = [nameOfCopy copy]; //正确的写法
}
@end
