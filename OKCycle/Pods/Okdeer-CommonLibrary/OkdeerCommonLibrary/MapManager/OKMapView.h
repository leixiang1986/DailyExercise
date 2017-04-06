//
//  OKMapView.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/1/23.
//  Copyright © 2017年 Mac. All rights reserved.
//
// 展示地图的类
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
@class OKMapView;
// block
typedef void(^MapViewMoveBlock)(OKMapView *mapView);          /**< 地图移动*/
typedef void(^MapViewReLocationBlock)(OKMapView *mapView);    /**< 地图重新定位*/

@interface OKMapView : UIView

@property (nonatomic,copy) MapViewMoveBlock mapMoveBlock;                   /**< 地图移动的block*/
@property (nonatomic,copy) MapViewReLocationBlock mapRelocationBlock;       /**< 地图重新定位*/

/**
 页面将要显示
 */
- (void)viewWillAppear;
/**
 页面将要消失
 */
- (void)viewWillDisappear;
/**
 获取地图的中心点的坐标

 @return 中心点坐标
 */
- (CLLocationCoordinate2D)getMapCoordinate;
/**
 添加标志到地图

 @param coordinate 坐标
 */
- (void)addAnnoationToMapCenter:(CLLocationCoordinate2D)coordinate;
/**
 更新定位的位置在地图上  由于BMKUserLocation 该类是从定位中获取但是只能获取不能赋值必须在外部传入

 @param userLocation 定位的实体类
 */
- (void)updateLocationData:(BMKUserLocation *)userLocation;
@end
