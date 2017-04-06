//
//  OkdeerUserManager+UserInfo.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

/**
 *
 *  前面实现@property(nonatomic, xxx)
 *  @implementation  中实现 @dynamic
 *  使用类型为常规数据类型
 *  即可,就 可以获取和存储 使用[OkdeerUserManager standardManager].xxx
 *  具体使用请参考ExampleDemo
 *
 **/

#import "OkdeerUserManager.h"

@interface OkdeerUserManager (UserInfo)

@property (nonatomic, strong) NSString *userPhone;

@end
