//
//  ReachabilityManager.m
//  RequestFrameworks
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ReachabilityManager.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>  //为判断网络制式的主要文件
#import <CoreTelephony/CTCarrier.h> //添加获取客户端运营商 支持

@interface ReachabilityManager ()

@property (nonatomic, copy) NetWorkBlock netWorkBlock;   /**< 网络状态改变的回调*/
@property (nonatomic, copy) NSString *oldNetWorkStatus;  /**< 改变前的状态*/

@end

static NSString *const kNetWorkToNoReachable     = @"NoReachable";         /**< 没有网络*/
static NSString *const kNetWorkToWifi            = @"Wifi";                 /**< wifi 网络*/
static NSString *const kNetWorkTo4G              = @"4G";                  /**< 4G 网络 */
static NSString *const kNetWorkTo3G              = @"3G";                  /**< 3G 网络*/
static NSString *const kNetWorkTo2G              = @"2G";                  /**< 2G 网络*/
static NSString *const kNetWorkToUnKnown         = @"unKnown";             /**< 未知 网络 */

static NSString *const kNetWorkStatusChangeNotification = @"netWorkStatusChangeNotification";    /**< 网络状态改变的通知 */
static NSString *const kMallIpChangeNotification = @"mallIpChangeNotification";             /**< 商城IP发生改变的通知 只有开启debug默认为发通知*/
static NSString *const kPropertyIpChangeNotification = @"propertyIpChangeNotification";     /**< 物业IP发生改变的通知 只有开启debug默认为发通知*/
static NSString *const kSellertIpChangeNotifiction = @"sellertIpChangeNotifiction";         /**< 商家IP发生改变的通知 只有开启debug默认为发通知*/
static NSString *const kAllIpChangeNotification = @"AllIpChangeNotification";               /**< 所有的IP发生变化的通知*/


@implementation ReachabilityManager
/**
 *  初始化
 */
+ (instancetype)sharedManager{
    static ReachabilityManager *reachabilityManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachabilityManager = [[ReachabilityManager alloc] init];
    });
    return reachabilityManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _netWorkStatus = @"";
        [self startMonitoring];
    }
    return self;
}
/**
 *  网络改变的回调
 */
- (void)setReachabilityStatusChangeBlock:(NetWorkBlock)netWorkBlock{
    _netWorkBlock = netWorkBlock;
}
/**
 *  是否为没有网络变成有网络的
 */
- (BOOL)notReachableToChangeReachable{
    if (!_oldNetWorkStatus.length || [_oldNetWorkStatus isEqualToString:kNetWorkToNoReachable]) {
        if (![_netWorkStatus isEqualToString:kNetWorkToNoReachable]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  开始请求网络状态
 */
- (void)startMonitoring{
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    __weak __typeof(&*self)weakSelf = self;
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        if (strongSelf) [strongSelf compareToNetworkStatus:status];
    }];
    [reachManager startMonitoring];
}
/**
 *  比较网络的状态
 */
- (void)compareToNetworkStatus:(AFNetworkReachabilityStatus)status{
    switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            [self withoutNetwork];
            return;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            [self wwanNetwork];
            return;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            [self wifiNetwork];
            return;
            case AFNetworkReachabilityStatusUnknown:
        default:
            [self unknowNetwork];
            return;
    }
}
/**
 *  没有网络
 */
-(void)withoutNetwork{
    [self netWorkChange:kNetWorkToNoReachable netStatue:WithoutNetwork];
}
/**
 *   移动网络
 */
-(void)wwanNetwork
{
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
    
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]){
        //GPRS网络
        [self wwan:kNetWorkTo2G netStatue:GPRS];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]){
        //2.75G的EDGE网络
        [self wwan:kNetWorkTo2G netStatue:Edge];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
        //3G WCDMA网络
        [self wwan:kNetWorkTo3G netStatue:WCDMA];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
        //3.5G网络
        [self wwan:kNetWorkTo3G netStatue:HSDPA];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
        //3.5G网络
        [self wwan:kNetWorkTo3G netStatue:HSUPA];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        //CDMA2G网络
        [self wwan:kNetWorkTo2G netStatue:CDMA1xNetwork];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        //CDMA的EVDORev0(应该算3G吧?)
        [self wwan:kNetWorkTo3G netStatue:CDMAEVDORev0];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        //CDMA的EVDORevA(应该也算3G吧?)
        [self wwan:kNetWorkTo3G netStatue:CDMAEVDORevA];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        [self wwan:kNetWorkTo3G netStatue:CDMAEVDORevB];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        //HRPD网络
        [self wwan:kNetWorkTo3G netStatue:HRPD];
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        //LTE4G网络
        [self wwan:kNetWorkTo4G netStatue:LTE];
    }else{
        // 未知网络
        [self wwan:kNetWorkToUnKnown netStatue:UnknowNetwork];
    }
    
}
/**
 *  移动网络
 */
- (void)wwan:(NSString *)netString netStatue:(OkdeerNetworkStatus)netStatus
{
    [self netWorkChange:netString netStatue:netStatus];
}

/**
 *  wifi
 */
-(void)wifiNetwork{
    [self netWorkChange:kNetWorkToWifi netStatue:WifiNetwork]; 
}
/**
 *  未知网络
 */
-(void)unknowNetwork{
    [self netWorkChange:kNetWorkToUnKnown netStatue:UnknowNetwork];
}
/**
 *  网络状态改变的回调
 *
 *  @param netString 网络状态改变对应的字符串
 *  @param netStatus 网络状态对应的枚举
 */
- (void)netWorkChange:(NSString *)netString netStatue:(OkdeerNetworkStatus)netStatus{
    _oldNetWorkStatus = _netWorkStatus;
    _netWorkStatus = netString;
    if (_netWorkBlock) {
        _netWorkBlock(netStatus,netString);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkStatusChangeNotification object:netString];
}
/**
 *  是否wifi 网络
 */
- (BOOL)isWifi
{
    return [_netWorkStatus isEqualToString:kNetWorkToWifi];
}
/**
 *  是否为2g 网络
 */
- (BOOL)is2G
{
    return [_netWorkStatus isEqualToString:kNetWorkTo2G];
}
/**
 *  是否为 3g 网络
 */
- (BOOL)is3G
{
    return [_netWorkStatus isEqualToString:kNetWorkTo3G];
}
/**
 *  是否为4g 网络
 */
- (BOOL)is4G
{
    return [_netWorkStatus isEqualToString:kNetWorkTo4G];
}
/**
 *  是否为 移动网络
 */
- (BOOL)isWWAN
{
    
    BOOL isWWANBool = NO;
    if ([_netWorkStatus isEqualToString:kNetWorkTo4G] || [_netWorkStatus isEqualToString:kNetWorkTo3G] || [_netWorkStatus isEqualToString:kNetWorkTo2G]) {
        isWWANBool = YES;
    }else{
        isWWANBool = NO;
    }
    return isWWANBool;
}

/**
 *  是否为 没有网络
 */
- (BOOL)isNotReachable
{
    return [_netWorkStatus isEqualToString:kNetWorkToNoReachable];
}
/**
 *  是否 未知网络
 */
- (BOOL)isUnKnown
{
    return [_netWorkStatus isEqualToString:kNetWorkToUnKnown];
}
- (void)dealloc
{
    _netWorkBlock = nil; 
}

@end
