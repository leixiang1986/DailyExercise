//
//  OkHttpRequestDomain.h
//  Pods
//
//  Created by Mac on 2017/3/27.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HttpRequestDomainType) {
    HttpRequestDomainType_Default,          /**< 默认域名 */
    HttpRequestDomainType_Server,           /**< 服务器域名 */
}; /**< 域名类型 */

@interface OkHttpRequestDomain : NSObject
/*** 保存是否取服务器的 ***/    
+ (void)saveIsServer:(BOOL)isServer;
/*** 保存商城域名  ***/
+ (void)saveMallDomain:(NSString *)mallDomain domainType:(HttpRequestDomainType)domainType;
/*** 保存物业域名 ***/
+ (void)savePropertyDomain:(NSString *)propertyDomain domainType:(HttpRequestDomainType)domainType;
/*** 保存商家域名 ***/
+ (void)saveSellerDomain:(NSString *)sellerDomain domainType:(HttpRequestDomainType)domainType;
/*** 保存更新域名 ***/
+ (void)saveUpdateDomain:(NSString *)updateDomain domainType:(HttpRequestDomainType)domainType;
/*** 获取商城域名 ***/
+ (NSString *)selectFromMallDomain;
/*** 获取物业域名 ***/
+ (NSString *)selectFromPropertyDomain;
/*** 获取商家域名 ***/
+ (NSString *)selectFromSellerDomain;
/*** 获取更新域名 ***/
+ (NSString *)selectFromUpdateDomain;
@end

/*** 商城域名 ***/
#define HTTP_MallPrefix_URL             ([OkHttpRequestDomain selectFromMallDomain])
/*** 物业域名 ***/
#define HTTP_PropertyPrefix_URL         ([OkHttpRequestDomain selectFromPropertyDomain])
/*** 商家域名 ***/
#define HTTP_SellerPrefix_URL           ([OkHttpRequestDomain selectFromSellerDomain])
/*** 更新域名 ***/    
#define HTTP_UpdatePrefix_URL           ([OkHttpRequestDomain selectFromUpdateDomain])
