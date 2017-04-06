//
//  OKDeerAppInfo.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/2/16.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKDeerAppInfo : NSObject
/**
 获取info plist的字典
 
 @return  info plist的字典
 */
+ (NSDictionary *)obtainInfoDictionary;
/**
 获取app的名称

 @return app名称
 */
+ (NSString *)obtainAPPName;
/**
 获取应用的唯一标识

 @return 唯一的标识
 */
+ (NSString *)obtainBundleId;
/**
 获取app的版本 （带有v）

 @return app的版本
 */
+ (NSString *)obtainAPPVersion;
/**
 获取app版本的标识

 @return 版本的标识
 */
+ (NSString *)obtainAPPVersionCode;
@end
