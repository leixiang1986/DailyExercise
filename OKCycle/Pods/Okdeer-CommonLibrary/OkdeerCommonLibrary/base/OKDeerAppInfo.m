//
//  OKDeerAppInfo.m
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/2/16.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKDeerAppInfo.h"

@implementation OKDeerAppInfo
/**
 获取info plist的字典

 @return  info plist的字典
 */
+ (NSDictionary *)obtainInfoDictionary{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Info.plist"];
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    return infoDic;
}
/**
 获取app的名称
 
 @return app名称
 */
+ (NSString *)obtainAPPName{
    NSDictionary *infoDic = [self obtainInfoDictionary];
    if (infoDic) {
        return infoDic[@"CFBundleDisplayName"];
    }
    return @"";
}
/**
 获取应用的唯一标识
 
 @return 唯一的标识
 */
+ (NSString *)obtainBundleId{
    NSDictionary *infoDic = [self obtainInfoDictionary];
    if (infoDic) {
        return infoDic[@"CFBundleIdentifier"];
    }
    return @"";
}
/**
 获取app的版本 （带有v）
 
 @return app的版本
 */
+ (NSString *)obtainAPPVersion{
    NSDictionary *infoDic = [self obtainInfoDictionary];
    if (infoDic) {
        return infoDic[@"ShowVersion"];
    }
    return @"";
}
/**
 获取app版本的标识
 
 @return 版本的标识
 */
+ (NSString *)obtainAPPVersionCode{
    NSDictionary *infoDic = [self obtainInfoDictionary];
    if (infoDic) {
          return infoDic[@"VersionCode"];
    }
    return @"";
}

@end
