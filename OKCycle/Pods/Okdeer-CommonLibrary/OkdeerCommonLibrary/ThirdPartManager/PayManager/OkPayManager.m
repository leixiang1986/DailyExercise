//
//  OkPayManager.m
//  FirstTestFrameworks
//
//  Created by Mac on 16/12/28.
//  Copyright © 2016年 huangshupeng. All rights reserved.
//

#import "OkPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
NSString *const OkPayManagerPayCallBackNotification = @"OkPayManagerPayCallBackNotification";                         /**< 支付回调的通知*/
// 通知 返回带参数的key
NSString *const OkPayManagerPayTypeKey = @"payTypeKey";             /**< 支付类型key */
NSString *const OkPayManagerClientKey = @"clientKey";               /**< 是否客户端的key value is Number Bool*/
NSString *const OkPayManagerPayStateKey = @"payStateKey";           /**< 支付状态key */
// 通知 对应的key
NSString *const OkPayManagerPayTypeWeiXin = @"weiXin";              /**< 支付类型 微信*/
NSString *const OkPayManagerPayTypeApi = @"apiPay";                 /**< 支付类型 支付宝*/
NSString *const OkPayManagerPayStateSuccess = @"success";           /**< 支付状态 成功 */
NSString *const OkPayManagerPayStateFailue = @"failure";            /**< 支付状态 失败 */
NSString *const OkPayManagerPayStateCance = @"cance";               /**< 支付状态 取消 */
static NSString *kOkPayManagerAppScheme;                            /**< app schme*/
static NSString *kOkPayManagerWeixinId;                             /**< 微信id*/

@interface OkPayManager ()<WXApiDelegate>

@property (nonatomic,assign) BOOL clientCallback;                   /**< 是否从支付客户端返回的 YES 为是  NO 为NO*/
@end

@implementation OkPayManager
#pragma mark - //****************** 初始化 ******************//
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static OkPayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (instancetype)shareInstance{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addPayManagerNotification];
    }
    return self;
}

/**
 注册支付
 
 @param appScheme 调用支付的app注册在info.plist中的scheme
 @param weixinAppId 微信 appId
 @param weixinAppSecret 微信 appSecret
 */
+ (void)setAppScheme:(NSString *)appScheme weixinAppId:(NSString *)weixinAppId appSecret:(NSString *)weixinAppSecret{
    if (!kOkPayManagerWeixinId.length) {
        kOkPayManagerWeixinId = weixinAppId;
        [WXApi registerApp:weixinAppId];
    }
    if (!kOkPayManagerAppScheme.length) {
        kOkPayManagerAppScheme = appScheme;
    }
}
#pragma mark - //****************** 发起支付 ******************//
/**
 发起 支付请求
 
 @param payType 支付类型
 @param payParm 支付需要的参数 (支付宝 是字符串 微信是需要NSDictionary ) 这个是后台返回的
 */
+ (BOOL)sendPayRequest:(NSString *)payType payParm:(id)payParm{
    BOOL result = NO;
    if ([payType isKindOfClass:[NSString class]] && payType.length) {
        if ([payType isEqualToString:OkPayManagerPayTypeApi]) {
            result = [self sendPayRequestToAliPay:payParm];
        }else if ([payType isEqualToString:OkPayManagerPayTypeWeiXin]){
            result = [self sendPayRequestToWX:payParm];
        }
    }
    return result;
}


/**
 调起支付宝支付
 
 @param payParm 支付需要的参数
 @return 成功返回YES，失败返回NO。
 */
+ (BOOL)sendPayRequestToAliPay:(NSString *)payParm {
    BOOL success = NO;
    if ( [payParm isKindOfClass:[NSString class]] && payParm.length) {
        success = YES;
        [[AlipaySDK defaultService] payOrder:payParm fromScheme:kOkPayManagerAppScheme callback:^(NSDictionary *resultDic) {
            NSString *result = resultDic[@"resultStatus"];
            [self dealApiPayResultPayStatu:result];
        }];
    }
    return success;
}

/**
 调起微信支付
 
 @param payDic 支付需要参数
 @return 成功返回YES，失败返回NO。
 */
+ (BOOL)sendPayRequestToWX:(NSDictionary *)payDic{
    if ( payDic && [payDic isKindOfClass:[NSDictionary class]] && payDic.count) {
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [payDic objectForKey:@"appId"];
        req.partnerId           = [payDic objectForKey:@"partnerId"];
        req.prepayId            = [payDic objectForKey:@"prepayId"];
        req.nonceStr            = [payDic objectForKey:@"nonceStr"];
        req.timeStamp           = [[payDic objectForKey:@"timeStamp"] intValue];
        req.package             = [payDic objectForKey:@"packages"];
        req.sign                = [payDic objectForKey:@"sign"];
        
        BOOL success =  [WXApi sendReq:req];
        return success;
    }else{
        return NO;
    }
}
#pragma mark - //****************** 支付结果的处理 ******************//
/**
 *  处理支付宝 回调的状态
 */
+ (void)dealApiPayResultPayStatu:(NSString *)payStatues{
    if (![payStatues isKindOfClass:[NSString class]]) {
        payStatues = @"";
    }
    if ([payStatues isEqualToString:@"9000"]) {
        // 成功的通知
        payStatues = OkPayManagerPayStateSuccess;
    }
    else if ([payStatues isEqualToString:@"6001"]){
        // 取消支付
        payStatues = OkPayManagerPayStateCance;
    }
    else{
        // 失败的通知
        payStatues = OkPayManagerPayStateFailue;
    }
    [self sendPayCallBackNotification:OkPayManagerPayTypeApi payState:payStatues client:YES];
}
/**
 *  微信支付回调  处理
 */
+ (void)deleatWeiXinComplete:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        NSString *payStatues = @"";
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                payStatues = OkPayManagerPayStateSuccess;
            }
                break;
            case WXErrCodeUserCancel:
            {
                payStatues = OkPayManagerPayStateCance;
            }
                break;
            default:
            {
                payStatues = OkPayManagerPayStateFailue;
                break;
            }
        }
        [self sendPayCallBackNotification:OkPayManagerPayTypeWeiXin payState:payStatues client:YES];
    }
}

/**
 支付后回调之后 处理支付结果的URL
 
 @param url 支付结果url
 @return  成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURLInPay:(NSURL *)url{
    return [self dealHandleOpenURLInPay:url];
}

/**
 处理支付结果的URL
 
 @param url 支付结果url
 @return 成功返回YES，失败返回NO。
 */
+ (BOOL)dealHandleOpenURLInPay:(NSURL *)url{
    BOOL result = NO;
    result = [self dealHandleOpenURLInApiPay:url];
    if (!result) {
        result = [self dealHandleOpenURLInWeixin:url];
    }
    return result;
}
/**
 处理 支付宝的支付结果的URL
 
 @param url 支付结果url
 @return 成功返回YES，失败返回NO。
 */
+ (BOOL)dealHandleOpenURLInApiPay:(NSURL *)url{
    BOOL result = NO;
    if ([url isKindOfClass:[NSURL class]]) {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付宝 回调
            [OkPayManager shareInstance].clientCallback = YES;
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSString *result = resultDic[@"resultStatus"];
                [self dealApiPayResultPayStatu:result];
            }];
            result = YES;
        }else if([url.host isEqualToString:@"platformapi"]){
            [OkPayManager shareInstance].clientCallback = YES;
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                
            }];
            result = YES;
        }
    }
    
    return result;
}
/**
 处理微信支付结果的URL
 
 @param url 支付结果url
 @return 成功返回YES，失败返回NO。
 */
+ (BOOL)dealHandleOpenURLInWeixin:(NSURL *)url{
    BOOL result = NO;
    if ([url isKindOfClass:[NSURL class]]) {
        NSString *tempString = [NSString stringWithFormat:@"%@",url] ;
        NSRange rang = [tempString rangeOfString:@"pay"];
        if (rang.location != NSNotFound && [[url scheme] isEqualToString:kOkPayManagerWeixinId]){
            [OkPayManager shareInstance].clientCallback = YES;
            result = [WXApi handleOpenURL:url delegate:[OkPayManager shareInstance]];
        }
    }
    return result;
}
#pragma mark - //****************** 通知 ******************//

/**
 添加通知
 */
- (void)addPayManagerNotification{
    // 添加 监听 app 重新返回的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payManagerApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 app 重新返回的通知
 
 @param application application
 */
- (void)payManagerApplicationDidBecomeActive:(UIApplication *)application{
    if (!self.clientCallback) {
        // 不是从支付客户端返回的
        [[self class] sendPayCallBackNotification:@"" payState:@"" client:NO];
    }
    self.clientCallback = NO;
}
/**
 发起支付结果的通知
 
 @param payType 支付类型
 @param payState 支付状态
 @param client 是否为客户端  YES 为支付客户端返回的  NO不是支付客户端返回的
 */
+ (void)sendPayCallBackNotification:(NSString *)payType payState:(NSString *)payState client:(BOOL)client{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    if (payType) {
        [info setObject:payType forKey:OkPayManagerPayTypeKey];
    }
    if (payState) {
        [info setObject:payState forKey:OkPayManagerPayStateKey];
    }
    [info setObject:[NSNumber numberWithBool:client] forKey:OkPayManagerClientKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OkPayManagerPayCallBackNotification object:info];
}

#pragma mark - //****************** delegate/dataSource ******************//
- (void)onResp:(BaseResp *)resp{
    
    [[self class] deleatWeiXinComplete:resp];
}
@end
