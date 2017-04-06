//
//  OKDeerPoiInfo.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/2/17.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OKDeerPoiInfo : NSObject
@property (nonatomic, strong) NSString* name;                   /**< POI名称*/
@property (nonatomic, strong) NSString* uid;                    /**< POIuid*/
@property (nonatomic, strong) NSString* address;                /**< POI地址*/
@property (nonatomic, strong) NSString* city;                   /**< POI所在城市*/
@property (nonatomic, strong) NSString* phone;                  /**< POI电话号码*/
@property (nonatomic, strong) NSString* postcode;               /**< POI邮编*/
@property (nonatomic) int epoitype;                             /**< POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路*/
@property (nonatomic) CLLocationCoordinate2D pt;                /**< POI坐标*/
@property (nonatomic, assign) BOOL panoFlag;                    /**< 是否有全景*/
@property (nonatomic,assign) double distance;                   /**< 距离*/
@end

