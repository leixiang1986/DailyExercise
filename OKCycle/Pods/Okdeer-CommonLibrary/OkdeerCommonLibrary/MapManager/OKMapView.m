//
//  OKMapView.m
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/1/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OKMapView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Masonry.h"

#define kCenterViewWidth                20
#define kCenterViewHeight               24
#define kCenterImageViewBaseWidth       15
#define kCenterImageVIewBaseHeight      6

@interface OKMapView ()<BMKMapViewDelegate>

@property (nonatomic,strong) BMKMapView *mapView;                       /**< 地图 */
@property (nonatomic,strong) UIView *centerView;                        /**< 中间的view*/
@property (nonatomic,strong) UIImageView *locationImageView;            /**< 显示位置的动画imageVIew */

@end

@implementation OKMapView
#pragma mark - //****************** 事件 action ******************//
/**
 页面将要显示
 */
- (void)viewWillAppear{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
}
/**
 页面将要消失
 */
- (void)viewWillDisappear{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}
/**
 获取地图的中心点的坐标
 
 @return 中心点坐标
 */
- (CLLocationCoordinate2D)getMapCoordinate{
    return self.mapView.centerCoordinate; 
}
/**
 添加标志到地图
 
 @param coordinate 坐标
 */
- (void)addAnnoationToMapCenter:(CLLocationCoordinate2D)coordinate{
    [self setupMapViewCenter:coordinate];
    [self accuracyCircleShow:NO];
    [self centerView];
}
/**
 更新定位的位置在地图上  由于BMKUserLocation 该类是从定位中获取但是只能获取不能赋值必须在外部传入
 
 @param userLocation 定位的实体类
 */
- (void)updateLocationData:(BMKUserLocation *)userLocation{
    [self updateMapLocationData:userLocation];
    [self addAnnoationToMapCenter:userLocation.location.coordinate];
}
/**
 更新地图上的定位

 @param userLocation 定位的实体类
 */
- (void)updateMapLocationData:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
}
/**
 *  设置定位的圆圈是否显示
 */
- (void)accuracyCircleShow:(BOOL)show
{
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isAccuracyCircleShow = show;         //显示定位标识，但不要精度圈
    [_mapView updateLocationViewWithParam:displayParam];
}
/**
 *  根据经纬度设置为地图的中心点
 */
- (void)setupMapViewCenter:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = coordinate;//中心点
    [self.mapView setRegion:region animated:YES];
}
- (CAKeyframeAnimation *)getAnimation{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    NSNumber *value1 = [NSNumber numberWithDouble:0];
    NSNumber *value2 = [NSNumber numberWithDouble:-20];
    NSNumber *value3 = [NSNumber numberWithDouble:0];
    
    anim.values = @[value1,value2,value3];
    anim.keyTimes = @[@0,@0.5,@1];
    anim.duration = 0.5;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

#pragma mark ---- BMKMapViewDelegate
/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [_locationImageView.layer addAnimation:[self getAnimation] forKey:nil];
    if (_mapMoveBlock) {
        _mapMoveBlock(self);
    }
}
#pragma mark - //****************** UI ******************//
- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel = 20;
        [self addSubview:_mapView];
        [self addConstraintToMapView];
    }
    return _mapView;
}
/**
 添加约束到mapView
 */
- (void)addConstraintToMapView{
    if (_mapView.superview) {
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self).offset(0);
        }];
    }
}
- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        [self addSubview:_centerView];
        [self addConstraintToCenterView];
        UIImageView *baseImageView = [[UIImageView alloc] init];
        [_centerView addSubview:baseImageView];
        [baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kCenterImageViewBaseWidth, kCenterImageVIewBaseHeight));
            make.centerX.equalTo(_centerView).offset(0);
            make.bottom.equalTo(_centerView.mas_bottom).offset(0);
        }];
        
        _locationImageView = [[UIImageView alloc] init];
        [_centerView addSubview:_locationImageView];
        [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(_centerView).offset(0);
        }];
    }
    return _centerView;
}
/**
 添加约束到中间的view
 */
- (void)addConstraintToCenterView{
    if (_centerView.superview) {
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kCenterViewWidth, kCenterViewHeight));
            make.center.equalTo(self).offset(0);
        }];
    }
}
- (void)dealloc{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _mapView = nil;
}

@end
