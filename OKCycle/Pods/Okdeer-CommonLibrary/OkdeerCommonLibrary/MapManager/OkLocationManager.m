//
//  OkLocationManager.m
//  OkdeerCommonLibrary
//
//  Created by Mac on 17/1/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OKDeerAppInfo.h"
#import "OKAlertView.h"
#import "OKDeerPoiInfo.h"
#import "OkdeerCommHandle.h"

@interface OkLocationManager ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate, BMKPoiSearchDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) BMKLocationService *locationService;               /**< 定位*/
@property (nonatomic,strong) CLLocationManager *locationManager;                /**< 定位manager*/
@property (nonatomic,copy) LocationSuccessBlock locationSuccessBlock;           /**< 定位成功的回调 */
@property (nonatomic,copy) LocationFailureBlock locationFailureBlock;           /**< 定位失败的回调 */
@property (nonatomic,copy) LocationGeoCodeBlock geoCodeblock;                   /**< 反编码的回调 */
@property (nonatomic,copy) PoiSearchSuccessBlock searchBlock;                   /**< 搜索的回调*/

@end

@implementation OkLocationManager

+ (instancetype)shareMamager{
    static OkLocationManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[OkLocationManager alloc] init];
    });
    return shareManager;
}
#pragma mark - //****************** 事件 action ******************//
/**
 开启定位
 
 @param locationSuccessBlock 定位成功的回调
 @param locationFailureBlock 定位失败的回调
 */
+ (void)startLocationToSuccess:(LocationSuccessBlock)locationSuccessBlock failure:(LocationFailureBlock)locationFailureBlock{
    [OkLocationManager shareMamager].locationSuccessBlock = locationSuccessBlock;
    [OkLocationManager shareMamager].locationFailureBlock = locationFailureBlock;
    [[OkLocationManager shareMamager] startLocation];
}
/**
 反编码
 
 @param locationCoordinate2D 需要反编码的坐标
 @param geoCodeBlock 反编码结果回调
 */
+ (void)reverseGeoCodeSearch:(CLLocationCoordinate2D)locationCoordinate2D complete:(LocationGeoCodeBlock)geoCodeBlock{
    //发起检索 坐标获取相对应的省市区
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = locationCoordinate2D;
    BMKGeoCodeSearch *geoSearcher = [[BMKGeoCodeSearch alloc] init];
    geoSearcher.delegate = [OkLocationManager shareMamager];
    [OkLocationManager shareMamager].geoCodeblock = geoCodeBlock;
    BOOL flag = [geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (!flag && geoCodeBlock) {
        geoCodeBlock(nil);
        [OkLocationManager shareMamager].geoCodeblock = nil;
        geoSearcher.delegate = nil;
        geoSearcher = nil;
    }

}
/**
 城市检索
 
 @param city 城市
 @param keyword 关键字
 @param searchSuccessBlock 搜索结果回调
 */
+ (void)poiSearchWithCity:(NSString *)city keyword:(NSString *)keyword complete:(PoiSearchSuccessBlock)searchSuccessBlock{
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.city = city;
    option.keyword = keyword;
    option.pageCapacity = 20;  // 每页搜索的条数
    BMKPoiSearch *poiSearcher = [[BMKPoiSearch alloc] init];
    poiSearcher.delegate = [OkLocationManager shareMamager];
    [OkLocationManager shareMamager].searchBlock = searchSuccessBlock;
    BOOL flag = [poiSearcher poiSearchInCity:option];
    if (!flag && searchSuccessBlock){
        searchSuccessBlock(nil);
        [OkLocationManager shareMamager].searchBlock = nil;
        poiSearcher.delegate = nil;
        poiSearcher = nil;
    }}
/**
 开启定位
 */
- (void)startLocation{
    [self.locationService stopUserLocationService];
    self.locationService.delegate = nil;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if (!self.locationManager) {
        [self faileComolete:OkLocationFaileType_SysClose];
    }else{
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationService startUserLocationService];
            self.locationService.delegate = self;
        }
    }
}
/**
 停止定位
 */
- (void)stopLoaction{
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
    [_locationService stopUserLocationService];
    _locationService.delegate = nil;
    _locationSuccessBlock = nil;
    _locationFailureBlock = nil;
}
/**
 用来判断一个二维坐标是否合法。
 
 @param locationCoord 经纬度
 @return 是否合法
 */
+ (BOOL)locationCoordIsValid:(CLLocationCoordinate2D)locationCoord{
    return CLLocationCoordinate2DIsValid(locationCoord);
}
/**
 处理定位成功的

 @param userLocation 位置
 */
- (void)dealLocationSuccess:(BMKUserLocation *)userLocation{
    if (userLocation && [userLocation isKindOfClass:[BMKUserLocation class]]) {
        _locationSuccess = YES;
        _locationCoord = userLocation.location.coordinate;
        _userLocation = userLocation;
        [self stopLoaction];
        if (_locationSuccessBlock) {
            _locationSuccessBlock();
        }
    }
}
/**
 处理定位失败的

 @param error 失败码
 */
- (void)dealLocationFailure:(NSError *)error{
    _locationSuccess = NO;
    _locationCoord = kCLLocationCoordinate2DInvalid;
    if (error.code == kCLErrorDenied) {
        [self faileComolete:OkLocationFaileType_APPClose];
    }else{
        [self faileComolete:OkLocationFaileType_NoLocation];
    }
    [self stopLoaction];
}
/**
 失败的回调

 @param faileType 失败类型
 */
- (void)faileComolete:(OkLocationFaileType)faileType{
    NSString *failureReason = [self obtainFaileReasonToFaileType:faileType];
    if (_locationFailureBlock) {
        BOOL isAlert = _locationFailureBlock(faileType,failureReason);
        if (isAlert) {
            [OKAlertView alertWithCallBackBlock:nil title:@"提示" message:failureReason cancelButtonName:failureReason otherButtonTitles:@"确定", nil];
        }
    }
}
/**
 根据失败的类型获取失败的原因

 @param faileType 失败类型
 @return 定位失败的原因
 */
- (NSString *)obtainFaileReasonToFaileType:(OkLocationFaileType)faileType{
    NSString *failureReason = @"";
    switch (faileType) {
        case OkLocationFaileType_SysClose:
        {
            failureReason = [NSString stringWithFormat:@"您没开启定位服务功能 请在设置->隐私->定位服务 设置为打开状态"];
        }
            break;
        case OkLocationFaileType_APPClose:
        {
            NSString *appName = [OKDeerAppInfo obtainAPPName];
            failureReason = [NSString stringWithFormat:@"您没开启定位服务功能 请在设置->隐私->定位服务->%@ 设置为打开状态",appName];
        }
            break;
        default:
            failureReason = @"没有定位到你的位置";
            break;
    }
    return failureReason;
}
/**
 百度数据转换成自己的model

 @param array 百度poiInfo数组<BMKPoiInfo>
 @param coordinate 当前的坐标
 @return poiInfoArray<OKDeerPoiInfo>
 */
- (NSArray *)baiduPoiInfoChange:(NSArray *)array coordinate:(CLLocationCoordinate2D)coordinate{
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
     BMKMapPoint currentPoint = BMKMapPointForCoordinate(coordinate);
    for (BMKPoiInfo *poiInfo in array) {
        if (![poiInfo isKindOfClass:[BMKPoiInfo class]]) {
            continue;
        }
        OKDeerPoiInfo *poiInfoModel = [[OKDeerPoiInfo alloc] init];
        poiInfoModel.name = poiInfo.name;
        poiInfoModel.uid = poiInfo.uid;
        poiInfoModel.address = poiInfo.address;
        poiInfoModel.city = poiInfo.city;
        poiInfoModel.phone = poiInfo.phone;
        poiInfoModel.postcode = poiInfo.postcode;
        poiInfoModel.epoitype = poiInfo.epoitype;
        poiInfoModel.pt = poiInfo.pt;
        if ([[self class] locationCoordIsValid:coordinate]) {
            BMKMapPoint point = BMKMapPointForCoordinate(poiInfo.pt);
            poiInfoModel.distance = BMKMetersBetweenMapPoints(currentPoint, point);
        }
        [listArray addObject:poiInfoModel];
    }
    return listArray;
}
#pragma mark - //****************** delegate ******************//
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self dealLocationSuccess:userLocation];
}
-(void)didFailToLocateUserWithError:(NSError *)error{
    [self dealLocationFailure:error];
}
#pragma mark ----反向地址编码回调
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR ) {
        okdeerAsyncQueue(@"", ^{
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
            BMKAddressComponent* addressDetail = result.addressDetail;
            NSArray *listArray = [[self baiduPoiInfoChange:result.poiList coordinate:result.location] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                OKDeerPoiInfo *poiInfo1 = (OKDeerPoiInfo *)obj1;
                OKDeerPoiInfo *poiInfo2 = (OKDeerPoiInfo *)obj2;
                if (poiInfo1.distance > poiInfo2.distance) {
                    // 第一位置距当前的位置大于第二位置
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
            [info setObject:location forKey:OKUserLocationToLocation];
            [info setObject:(addressDetail.province.length ? addressDetail.province : @"") forKey:OKUserLocationToProvince];
            [info setObject:(addressDetail.city.length ? addressDetail.city : @"") forKey:OKUserLocationToCity];
            [info setObject:(addressDetail.district.length ? addressDetail.district : @"") forKey:OKUserLocationToDistrict];
            [info setObject:(listArray ? listArray : @[]) forKey:OKUserLocationToPoiList];
            okdeerGetMainQueue(^{
                if (_geoCodeblock) {
                    _geoCodeblock(info);
                }
            });
        });
    }else{
       okdeerGetMainQueue(^{
           if (_geoCodeblock) {
               _geoCodeblock(nil);
           }
       });
    }
}
#pragma mark ----poi检索城市
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR){
        if (_searchBlock) {
            _searchBlock([self baiduPoiInfoChange:poiResult.poiInfoList coordinate:kCLLocationCoordinate2DInvalid]);
        }
    }else{
        if (_searchBlock) {
            _searchBlock(nil);
        }
    }
}
#pragma mark - //****************** getter ******************//
- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}
- (CLLocationManager *)locationManager{
    // 整个iOS系统定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) return nil;
    if (_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
    }
    return _locationManager;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

NSString *OKUserLocationToUserLocation = @"userLocation";
NSString *OKUserLocationToLocation = @"location";
NSString *OKUserLocationToProvince = @"province";
NSString *OKUserLocationToCity = @"city";
NSString *OKUserLocationToDistrict = @"district";
NSString *OKUserLocationToPoiList = @"poiList";
