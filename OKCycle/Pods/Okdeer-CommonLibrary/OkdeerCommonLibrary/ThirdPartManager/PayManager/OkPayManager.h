//
//  OkPayManager.h
//  FirstTestFrameworks
//
//  Created by Mac on 16/12/28.
//  Copyright © 2016年 huangshupeng. All rights reserved.
//
/**
    集成支付宝 微信等支付的处理类
    集成的步骤
        1. 在启动app的时候调用setAppScheme:(NSString *)appScheme weixinAppId:(NSString 方法
        2. 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用handleOpenURLInPay:(NSURL *)url 方法。
        3. 需要在获取支付结果的地方注册OkPayManagerPayCallBackNotification通知获取支付结果的通知
                在方法中需要先判断OkPayManagerClientKey 值 YES 为 支付宝客户端返回的 NO 为其他方式返回的（无法获取支付状态 从支付客户端的）
                OkPayManagerClientKey 的值
                YES 需要处理支付OkPayManagerPayStateKey对应的值  处理不同的结果
                NO  需要处理无法获取支付状态的逻辑
    注：支付成功或失败 不会有提示 需要提示则在各自业务去提示
    支付宝需要引入的
    libc++.tbd、libz.tbd SystemConfiguration.framework  CoreTelephony.framework QuartzCore.framework   CoreText.framework CoreGraphics.framework  CFNetwork.framework CoreMotion.framework
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 通知 名称
FOUNDATION_EXPORT NSString *const OkPayManagerPayCallBackNotification;  /**< 支付回调的通知*/
// 通知 返回带参数的key
FOUNDATION_EXPORT NSString *const OkPayManagerPayTypeKey;               /**< 支付类型key */
FOUNDATION_EXPORT NSString *const OkPayManagerPayStateKey;              /**< 支付状态key */
FOUNDATION_EXPORT NSString *const OkPayManagerClientKey;                /**< 是否客户端的key value is Number Bool*/
// 通知 对应的key
FOUNDATION_EXPORT NSString *const OkPayManagerPayTypeWeiXin;            /**< 支付类型 微信*/
FOUNDATION_EXPORT NSString *const OkPayManagerPayTypeApi;               /**< 支付类型 支付宝*/
FOUNDATION_EXPORT NSString *const OkPayManagerPayStateSuccess;          /**< 支付状态 成功 */
FOUNDATION_EXPORT NSString *const OkPayManagerPayStateFailue;           /**< 支付状态 失败 */
FOUNDATION_EXPORT NSString *const OkPayManagerPayStateCance;            /**< 支付状态 取消 */

@interface OkPayManager : NSObject

/**
    注册支付  只需调用一次就行

 @param appScheme 调用支付的app注册在info.plist中的scheme
 @param weixinAppId 微信 appId
 @param weixinAppSecret 微信 appSecret
 */
+ (void)setAppScheme:(NSString *)appScheme weixinAppId:(NSString *)weixinAppId appSecret:(NSString *)weixinAppSecret;

/**
 发起 支付请求

 @param payType 支付类型
 @param payParm 支付需要的参数 (支付宝 是字符串 微信是需要NSDictionary ) 这个是后台返回的
 */
+ (BOOL)sendPayRequest:(NSString *)payType payParm:(id)payParm;
/**
   支付后回调之后 处理支付结果的URL

 @param url 支付结果url
 @return  成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURLInPay:(NSURL *)url;

@end
