//
//  OkLocationManager.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/1/23.
//  Copyright © 2017年 Mac. All rights reserved.
//
// 定位类 和坐标的反编码
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import  <BaiduMapAPI_Location/BMKLocationService.h>
typedef NS_ENUM(NSUInteger,OkLocationFaileType) {
    OkLocationFaileType_SysClose,                   /**< 系统关闭定位*/
    OkLocationFaileType_APPClose,                   /**< app 关闭定位*/
    OkLocationFaileType_NoLocation,                 /**< 没有获取到定位*/
    OkLocationFaileType_TimeOut,                    /**< 请求超时*/
};

typedef void(^LocationSuccessBlock)(void);              /**< 定位成功的回调*/
typedef BOOL(^LocationFailureBlock)(OkLocationFaileType faileType,NSString *locationFailureReason);              /**< 定位失败的回调 返回是指是否需要提示*/
typedef void(^LocationGeoCodeBlock)(NSDictionary *info);        /**< 反编码的回调  成功info 有值 否则没有值*/
typedef void (^PoiSearchSuccessBlock)(NSArray *poiInfoArray);   /**< poi搜索 成功poiInfoArray 有值 否则没有值*/


@interface OkLocationManager : NSObject

@property (nonatomic,readonly) CLLocationCoordinate2D locationCoord;                    /**< 定位的坐标 */
@property (nonatomic,readonly) BMKUserLocation *userLocation;                           /**< 定位获取到userlocation*/
@property (nonatomic,readonly,getter=isLoactionSuccess) BOOL locationSuccess;           /**< 是否定位成功 */
@property (nonatomic,readonly) NSString *locationFailureReason;                         /**< 定位失败原因 */

+ (instancetype)shareMamager;
/**
 开启定位

 @param locationSuccessBlock 定位成功的回调
 @param locationFailureBlock 定位失败的回调
 */
+ (void)startLocationToSuccess:(LocationSuccessBlock)locationSuccessBlock failure:(LocationFailureBlock)locationFailureBlock;
/**
 反编码

 @param locationCoordinate2D 需要反编码的坐标
 @param geoCodeBlock 反编码结果回调
 */
+ (void)reverseGeoCodeSearch:(CLLocationCoordinate2D)locationCoordinate2D complete:(LocationGeoCodeBlock)geoCodeBlock;
/**
 城市检索

 @param city 城市
 @param keyword 关键字
 @param searchSuccessBlock 搜索结果回调
 */
+ (void)poiSearchWithCity:(NSString *)city keyword:(NSString *)keyword complete:(PoiSearchSuccessBlock)searchSuccessBlock;
/**
 开启定位
 */
- (void)startLocation;
/**
 停止定位
 */
- (void)stopLoaction;
/**
 用来判断一个二维坐标是否合法。

 @param locationCoord 经纬度
 @return 是否合法
 */
+ (BOOL)locationCoordIsValid:(CLLocationCoordinate2D)locationCoord;

@end

UIKIT_EXTERN NSString *OKUserLocationToUserLocation;
UIKIT_EXTERN NSString *OKUserLocationToLocation;
UIKIT_EXTERN NSString *OKUserLocationToProvince;
UIKIT_EXTERN NSString *OKUserLocationToCity;
UIKIT_EXTERN NSString *OKUserLocationToDistrict;
UIKIT_EXTERN NSString *OKUserLocationToPoiList;
