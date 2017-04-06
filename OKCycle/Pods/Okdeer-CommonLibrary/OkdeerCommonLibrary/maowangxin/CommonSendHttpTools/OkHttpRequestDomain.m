//
//  OkHttpRequestDomain.m
//  Pods
//
//  Created by Mac on 2017/3/27.
//
//

#import "OkHttpRequestDomain.h"

static NSString *const kDefaultMallDomain           =   @"DefaultMallDomain";
static NSString *const kDefaultPropertyDomain       =   @"DefaultPropertyDomain";
static NSString *const kDefaultSellerDomain         =   @"DefaultSellerDomain";
static NSString *const kDefaultUpdateDomain         =   @"DefaultUpdateDomain";
static NSString *const kServerMallDomain            =   @"ServerMallDomain";
static NSString *const kServerPropertyDomain        =   @"ServerPropertyDomain";
static NSString *const kServerSellerDomain          =   @"ServerSellerDomain";
static NSString *const kServerUpdateDomain          =   @"ServerUpdateDomain";

@interface OkHttpRequestDomain ()

@property (nonatomic,strong) NSMutableDictionary *domainDictionary;         /**< 域名字典*/
@property (nonatomic,assign,getter=isServer) BOOL server;                   /**< 是否取服务器url*/
@end

@implementation OkHttpRequestDomain

+ (instancetype)shareHtttpRequestDomain{
    static OkHttpRequestDomain *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OkHttpRequestDomain alloc] init];
    });
    return manager;
}
/*** 判断是否为字符串 ***/
+ (NSString *)equalIsString:(NSString *)string{
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    }else{
        return @"";
    }
}
/*** 获取字符串的长度 ***/
+ (NSUInteger)selectStringlength:(NSString *)string{
    return [self equalIsString:string].length;
}

/*** 保存域名 ***/
- (void)saveDomain:(NSString *)domain key:(NSString *)key{
    if ([[self class] selectStringlength:key] != 0) {
        [self.domainDictionary setObject:[[self class] equalIsString:domain] forKey:key];
    }
}
/*** 获取域名 ***/
- (NSString *)selectFromDomain:(NSString *)key{
    return [[self class] equalIsString:[self.domainDictionary objectForKey:key]];
}
/*** 保存是否取服务器的 ***/
+ (void)saveIsServer:(BOOL)isServer{
    [OkHttpRequestDomain shareHtttpRequestDomain].server = isServer;
}
/*** 保存商城域名  ***/
+ (void)saveMallDomain:(NSString *)mallDomain domainType:(HttpRequestDomainType)domainType{
    NSString *key = @"";
    switch (domainType) {
            case HttpRequestDomainType_Default:
        {
            key = kDefaultMallDomain;
        }
            break;
            case HttpRequestDomainType_Server:
        {
            key = kServerMallDomain;
        }
            break;
        default:
            break;
    }
    [[OkHttpRequestDomain shareHtttpRequestDomain] saveDomain:mallDomain key:key];
}
/*** 保存物业域名 ***/
+ (void)savePropertyDomain:(NSString *)propertyDomain domainType:(HttpRequestDomainType)domainType{
    NSString *key = @"";
    switch (domainType) {
            case HttpRequestDomainType_Default:
        {
            key = kDefaultPropertyDomain;
        }
            break;
            case HttpRequestDomainType_Server:
        {
            key = kServerPropertyDomain;
        }
            break;
        default:
            break;
    }
     [[OkHttpRequestDomain shareHtttpRequestDomain] saveDomain:propertyDomain key:key];
}
/*** 保存商家域名 ***/
+ (void)saveSellerDomain:(NSString *)sellerDomain domainType:(HttpRequestDomainType)domainType{
    NSString *key = @"";
    switch (domainType) {
            case HttpRequestDomainType_Default:
        {
            key = kDefaultSellerDomain;
        }
            break;
            case HttpRequestDomainType_Server:
        {
            key = kServerSellerDomain;
        }
            break;
        default:
            break;
    }
    
    [[OkHttpRequestDomain shareHtttpRequestDomain] saveDomain:sellerDomain key:key];
}
/*** 保存更新域名 ***/
+ (void)saveUpdateDomain:(NSString *)updateDomain domainType:(HttpRequestDomainType)domainType{
    NSString *key = @"";
    switch (domainType) {
            case HttpRequestDomainType_Default:
        {
            key = kDefaultUpdateDomain;
        }
            break;
            case HttpRequestDomainType_Server:
        {
            key = kServerUpdateDomain;
        }
            break;
        default:
            break;
    }
    [[OkHttpRequestDomain shareHtttpRequestDomain] saveDomain:updateDomain key:key];
}
/*** 获取商城域名 ***/
+ (NSString *)selectFromMallDomain{
    NSString *domain = [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kDefaultMallDomain];
    NSString *serverDomin =  [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kServerMallDomain];
    if ([OkHttpRequestDomain shareHtttpRequestDomain].isServer && [self selectStringlength:serverDomin]) {
        domain = serverDomin;
    }
    return domain;
}
/*** 获取物业域名 ***/
+ (NSString *)selectFromPropertyDomain{
    NSString *domain = [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kDefaultPropertyDomain];
    NSString *serverDomin =  [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kServerPropertyDomain];
    if ([OkHttpRequestDomain shareHtttpRequestDomain].isServer && [self selectStringlength:serverDomin]) {
        domain = serverDomin;
    }
    return domain;
}
/*** 获取商家域名 ***/
+ (NSString *)selectFromSellerDomain{
    NSString *domain = [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kDefaultSellerDomain];
    NSString *serverDomin =  [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kServerSellerDomain];
    if ([OkHttpRequestDomain shareHtttpRequestDomain].isServer && [self selectStringlength:serverDomin]) {
        domain = serverDomin;
    }
    return domain;
}
/*** 获取更新域名 ***/
+ (NSString *)selectFromUpdateDomain{
    NSString *domain = [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kDefaultUpdateDomain];
    NSString *serverDomin =  [[OkHttpRequestDomain shareHtttpRequestDomain] selectFromDomain:kServerUpdateDomain];
    if ([OkHttpRequestDomain shareHtttpRequestDomain].isServer && [self selectStringlength:serverDomin]) {
        domain = serverDomin;
    }
    return domain;
}

#pragma mark - //****************** setter ******************//
- (NSMutableDictionary *)domainDictionary{
    if (!_domainDictionary) {
        _domainDictionary = [[NSMutableDictionary alloc] init];
    }
    return _domainDictionary;
}
@end
