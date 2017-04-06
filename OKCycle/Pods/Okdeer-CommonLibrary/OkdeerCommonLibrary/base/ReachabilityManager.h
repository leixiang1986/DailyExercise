//
//  ReachabilityManager.h
//  RequestFrameworks
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Mac. All rights reserved.
//
// 获取网络状态的类

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, OkdeerNetworkStatus) {
    UnknowNetwork = -1,//不知名网络
    WithoutNetwork = 0,//没有网络
    WifiNetwork = 1,   //WIFI网络
    CDMA1xNetwork = 2, //电信2G网络
    CDMAEVDORev0 = 3,  //电信3G Rev0
    CDMAEVDORevA = 4,  //电信3G RevA
    CDMAEVDORevB = 5,  //电信3G RevB
    Edge = 6,          //移动/联通E网 (2G网络)
    GPRS = 7,          //移动/联通GPRS(2G网络)
    HSDPA = 8,         //移动/联通3G网络  (虽然移动用的是td而不是wcdma但也算是3G)
    HSUPA = 9,         //移动/联通3G网络
    LTE = 10,          //4G网络
    WCDMA= 11,         //3G网络
    HRPD = 12,         //CDMA网络
    //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
    //10为4G网络
    //-1为不知名网络
};

typedef void(^NetWorkBlock)(OkdeerNetworkStatus netWorkStatus,NSString *netWorkStatusString);


@interface ReachabilityManager : NSObject

@property (nonatomic,copy,readonly)NSString *netWorkStatus;  /**< 网络状态字符串*/
/**
 *  初始化
 */
+ (instancetype)sharedManager;
/**
 *  网络改变的回调
 */
- (void)setReachabilityStatusChangeBlock:(NetWorkBlock)netWorkBlock;
/**
 *  是否为没有网络变成有网络的
 */
- (BOOL)notReachableToChangeReachable;
/**
 *  是否wifi 网络
 */
- (BOOL)isWifi;
/**
 *  是否为2g 网络
 */
- (BOOL)is2G;
/**
 *  是否为 3g 网络
 */
- (BOOL)is3G;
/**
 *  是否为 移动网络
 */
- (BOOL)isWWAN;
/**
 *  是否为4g 网络
 */
- (BOOL)is4G;
/**
 *  是否为 没有网络
 */
- (BOOL)isNotReachable;
/**
 *  是否 未知网络
 */
- (BOOL)isUnKnown;
@end
