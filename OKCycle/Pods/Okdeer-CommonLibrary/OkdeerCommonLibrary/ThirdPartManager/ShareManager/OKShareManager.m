//
//  OKShareManager.m
//  ShareDemo
//
//  Created by huangshupeng on 16/10/13.
//  Copyright © 2016年 huangshupeng. All rights reserved.
//

#import "OKShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

static NSString *OKShareManagerShareUrl ;                   /**< 默认的分享URL*/

@implementation OKShareManager

#pragma mark - //****************** 初始化 ******************//
+ (instancetype)defaultManager{
    static OKShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OKShareManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/**
 设置默认的分享链接  网页分享时没有传分享链接则拿这个数据
 
 @param shareUrl 分享链接
 */
+ (void)setDefaultShareUrl:(NSString *)shareUrl{
    OKShareManagerShareUrl = shareUrl;
}
/**
 注册各分享平台的key
 
 @param platformType 平台枚举
 @param appKey appkey
 @param appSecret appSecret
 @param redirectURL redirectURL
 */
+ (void)registApp:(SharePlatformType)platformType
           appKey:(NSString *)appKey
        appSecret:(NSString *)appSecret
      redirectURL:(NSString *)redirectURL{
    switch(platformType){
        case SharePlatformTypeUmeng:
            // 注册友盟的key
            [[UMSocialManager defaultManager] setUmSocialAppkey:appKey];
            break;
        case SharePlatformTypeOfQQ:
        case SharePlatformTypeOfQzone:
            // 注册QQ
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:appKey  appSecret:appSecret redirectURL:redirectURL];
            break;
            case SharePlatformTypeOfSina:
            // 注册新浪微博
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:appKey appSecret:appSecret redirectURL:redirectURL];
            break;
        case SharePlatformTypeOfWechatSession:
        case SharePlatformTypeOfWechatTimeLine:
            // 注册微信的key和id
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:appKey appSecret:appSecret redirectURL:redirectURL];
            break;
        default:
            break;
            
    }
}
/**
 调起分享
 
 @param shareDataModel 分享内容的model
 @param completeBlock 分享成功或失败的回调
 @param dismissBlock 关闭的回调
 */
+ (void)shareToOKShareDataModel:(OKShareDataModel *)shareDataModel
                       complete:(ShareCompleteBlock)completeBlock
                        dismiss:(ShareDismissBlock)dismissBlock{
    NSArray *platformTypeArray = [self obtainPlatformTypeArray:shareDataModel.sharePlatformType];
    if (shareDataModel.sharePlatformType != SharePlatformTypeOfAll && platformTypeArray.count == 0) {
        return;
    }
    [self showShareMenuView:shareDataModel platformTypeArray:platformTypeArray complete:completeBlock dismiss:dismissBlock];
}
/**
 *  展示分享的view
 */
+ (void)showShareMenuView:(OKShareDataModel *)shareDataModel
        platformTypeArray:(NSArray *)platformTypeArray
                 complete:(ShareCompleteBlock)completeBlock
                  dismiss:(ShareDismissBlock)dismissBlock{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformTypeArray:platformTypeArray platformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        [self shareWithPlatformType:platformType shareDataModel:shareDataModel complete:completeBlock];
    } dismissBlock:^{
        if (dismissBlock) {
            dismissBlock();
        }
    }];
}
/**
 * 分享不同的内容到平台platformType
 */
+ (void)shareWithPlatformType:(UMSocialPlatformType)platformType
             shareDataModel:(OKShareDataModel *)shareDataModel
                     complete:(ShareCompleteBlock)completeBlock {
    UMSocialMessageObject *messageObject = [self obtainMessageObjectWithOKShareDataModel:shareDataModel];
    if (platformType == UMSocialPlatformType_Sina && shareDataModel.descr.length > 0 && shareDataModel.shareContentType == ShareContentTypeOfWeb) {
        messageObject.text = shareDataModel.descr;
    }
    
    if (messageObject && [messageObject isKindOfClass:[UMSocialMessageObject class]]) {
        // 返回的对象有值 调起分享
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:shareDataModel.currentViewController completion:^(id result, NSError *error) {
            // 分享成功或失败的回调
            // 判断返回错误 并且错误码为2003  2003 是图片不存在
            if (error && error.code == UMSocialPlatformErrorType_ShareFailed) {
                // 设置为默认值 重新调用直接分享到某个平台的
                shareDataModel.thumbImage = shareDataModel.placeholderImage;
                [self shareWithPlatformType:platformType shareDataModel:shareDataModel complete:completeBlock];
            }else{
                [self dealCompleteData:result error:error complete:completeBlock];
            }
        }];

        [self changeCloseItemTextColorForWebSina:platformType];
    }
}
/**
 处理返回的数据

 @param result 结果
 @param error 是否错误
 @param completeBlock 回调
 */
+ (void)dealCompleteData:(id)result
                   error:(NSError *)error
                complete:(ShareCompleteBlock) completeBlock{
    if (error) {
        [self callBackToComplete:completeBlock completeModel:nil error:error];
    }else{
        if ([result isKindOfClass:[UMSocialShareResponse class]]) {
            UMSocialShareResponse *resp = result;
            OKShareCompleteModel *completeModel = [[OKShareCompleteModel alloc] init];
            completeModel.uid = resp.uid;
            completeModel.openid = resp.openid;
            completeModel.refreshToken = resp.refreshToken;
            completeModel.expiration = resp.expiration;
            completeModel.accessToken = resp.accessToken;
            completeModel.message = resp.message;
            [self callBackToComplete:completeBlock completeModel:completeModel error:nil];
        }else{
            [self callBackToComplete:completeBlock completeModel:nil error:nil];
        }
    }
}
/**
 分享成功或失败的回调

 @param completeBlock 回调
 @param completeModel 返回数据
 @param error 是否错误
 */
+ (void)callBackToComplete:(ShareCompleteBlock)completeBlock
             completeModel:(OKShareCompleteModel *)completeModel
                     error:(NSError *)error{
    if (completeBlock) {
        completeBlock(completeModel,error);
    }
}

/**
 获取分享消息对象

 @param shareDataModel 分享数据源
 @return UMSocialMessageObject
 */
+ (UMSocialMessageObject *)obtainMessageObjectWithOKShareDataModel:(OKShareDataModel *)shareDataModel{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    switch (shareDataModel.shareContentType) {
        case ShareContentTypeOfText:
            messageObject.text = shareDataModel.title;
            break;
        case ShareContentTypeOfImage:
            if ([shareDataModel.title isKindOfClass:[NSString class]]) {
                messageObject.text = shareDataModel.title;
            }
            messageObject.shareObject = [self obtainShareImageObject:shareDataModel];
            break;
        case ShareContentTypeOfWeb:
            messageObject.shareObject = [self obtainShareWebpageObject:shareDataModel];
            break;
        case ShareContentTypeOfMusic:
            messageObject.shareObject = [self obtainShareMusicObject:shareDataModel];
            break;
        case ShareContentTypeOfVedio:
            messageObject.shareObject = [self obtainShareVideoObject:shareDataModel];
            break;
        default:
            break;
    }
    return messageObject;
}
/**
 获取分享图片内容对象

 @param shareDataModel 分享数据源
 @return UMShareImageObject
 */
+ (UMShareImageObject *)obtainShareImageObject:(OKShareDataModel *)shareDataModel{
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = shareDataModel.thumbImage;
    [shareObject setShareImage:shareDataModel.shareData];
    return shareObject;
}
/**
 获取分享网页内容对象

 @param shareDataModel 分享数据源
 @return UMShareWebpageObject
 */
+ (UMShareWebpageObject *)obtainShareWebpageObject:(OKShareDataModel *)shareDataModel{
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareDataModel.title descr:shareDataModel.descr thumImage:shareDataModel.thumbImage];
    if ([shareDataModel.shareData isKindOfClass:[NSString class]]) {
        shareObject.webpageUrl = shareDataModel.shareData;
    }
    if ( !shareObject.webpageUrl || shareObject.webpageUrl.length == 0) {
        shareObject.webpageUrl = OKShareManagerShareUrl;
    }
    
    return shareObject;
}
/**
 获取分享音乐内容对象

 @param shareDataModel 分享数据源
 @return UMShareMusicObject
 */
+ (UMShareMusicObject *)obtainShareMusicObject:(OKShareDataModel *)shareDataModel{
    //创建音乐内容对象
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:shareDataModel.title descr:shareDataModel.descr thumImage:shareDataModel.thumbImage];
    if ([shareDataModel.shareData isKindOfClass:[NSString class]]) {
        shareObject.musicUrl = shareDataModel.shareData;
    }
    return shareObject;
}
/**
 获取分享视频内容对象

 @param shareDataModel 分享数据源
 @return UMShareVideoObject
 */
+ (UMShareVideoObject *)obtainShareVideoObject:(OKShareDataModel *)shareDataModel{
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:shareDataModel.title descr:shareDataModel.descr thumImage:shareDataModel.thumbImage];
    //设置视频网页播放地址
    if ([shareDataModel.shareData isKindOfClass:[NSString class]]) {
        shareObject.videoUrl = shareDataModel.shareData;
    }
    return shareObject;
}

/**
 获取分享的平台

 @param sharePlatformType 分享平台
 @return 友盟分享平台数组
 */
+ (NSArray <NSNumber *>*)obtainPlatformTypeArray:(SharePlatformType)sharePlatformType{
    NSArray *platformTypeArray = nil;
    switch (sharePlatformType) {
        case SharePlatformTypeOfAll:
            break;
        case SharePlatformTypeOfAllExceptSms:
            platformTypeArray = [self obtainAllExceptSmsPlatformType];
            break;
        case SharePlatformTypeOfFriend:
            platformTypeArray = [self obtainFriendPlatformType];
            break;
        case SharePlatformTypeOfFriendExceptSms:
            platformTypeArray = [self obtainFriendExceptSmsPlatformType];
            break;
        case SharePlatformTypeOfSina:
            platformTypeArray = [self obtainSinaPlatformArray];
            break;
        case SharePlatformTypeOfWechatSession:
            platformTypeArray = [self obtainWechatSessionPlatformArray];
            break;
        case SharePlatformTypeOfWechatTimeLine:
            platformTypeArray = [self obtainWechatTimeLinePlatformArray];
            break;
        case SharePlatformTypeOfQQ:
            platformTypeArray = [self obtainQQPlatformArray];
            break;
        case SharePlatformTypeOfQzone:
            platformTypeArray = [self obtainQzonePlatformArray];
            break;
        case SharePlatformTypeOfSms:
            platformTypeArray = [self obtainSmsPlatformArray];
            break;
        case SharePlatformTypeOfAlipay:
            platformTypeArray = [self obtainAlipaySessionPlatformArray];
            break;
        default:
            break;
    }
    return platformTypeArray;
}
/**
 * 获取全部平台除了短信平台的
 */
+ (NSArray *)obtainAllExceptSmsPlatformType{
    NSMutableArray *platformTypeArray = [[NSMutableArray alloc] init];
    [platformTypeArray addObjectsFromArray:[self obtainWechatSessionPlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainWechatTimeLinePlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainQQPlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainQzonePlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainSinaPlatformArray]];
    return platformTypeArray;
}
/**
 * 获取分享好友的平台
 */
+ (NSArray *)obtainFriendPlatformType{
    NSMutableArray *platformTypeArray = [[NSMutableArray alloc] init];
    [platformTypeArray addObjectsFromArray:[self obtainWechatSessionPlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainQQPlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainSmsPlatformArray]];
    return platformTypeArray;
}
/**
 * 获取分享好友平台除了短信
 */
+ (NSArray *)obtainFriendExceptSmsPlatformType{
    NSMutableArray *platformTypeArray = [[NSMutableArray alloc] init];
    [platformTypeArray addObjectsFromArray:[self obtainWechatSessionPlatformArray]];
    [platformTypeArray addObjectsFromArray:[self obtainQQPlatformArray]];
    return platformTypeArray;
}
/**
 * 获取新浪
 */
+ (NSArray *)obtainSinaPlatformArray{
    NSNumber *sina = [self obtainSinaPlatform];
    return [self obtainNumberArrayWithNumber:sina];
}
/**
 * 获取QQ
 */
+ (NSArray *)obtainQQPlatformArray{
    NSNumber *qq = [self obtainQQPlatform];
    return [self obtainNumberArrayWithNumber:qq];
}
/**
 * 获取qq空间
 */
+ (NSArray *)obtainQzonePlatformArray{
    NSNumber *qZone = [self obtainQzonePlatform];
    return [self obtainNumberArrayWithNumber:qZone];
}
/**
 * 获取微信好友
 */
+ (NSArray *)obtainWechatSessionPlatformArray{
    NSNumber *wechatSession = [self obtainWechatSessionPlatform];
    return [self obtainNumberArrayWithNumber:wechatSession];
}
/**
 * 获取微信朋友圈
 */
+ (NSArray *)obtainWechatTimeLinePlatformArray{
    NSNumber *wechatTimeLine = [self obtainWechatTimeLinePlatform];
    return [self obtainNumberArrayWithNumber:wechatTimeLine];
}

/**
 * 获取支付宝
 */
+ (NSArray *)obtainAlipaySessionPlatformArray{
    NSNumber *alipaySession = [self obtainAlipaySessionPlatform];
    return [self obtainNumberArrayWithNumber:alipaySession];
}
/**
 * 获取短信
 */
+ (NSArray *)obtainSmsPlatformArray{
    NSNumber *sms = [self obtainSmsPlatfrom];
    return [self obtainNumberArrayWithNumber:sms];
}
/**
 * 判断是否为NSNumber 对象
 */
+ (BOOL)isNumberClass:(NSNumber *)numberClass{
    if (numberClass && [numberClass isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    return NO;
}
/**
 * 传入number 对象组装成数组  是number 对象返回数组  否则返回nil
 */
+ (NSArray *)obtainNumberArrayWithNumber:(NSNumber *)number{
    if ([self isNumberClass:number]) {
        return @[number];
    }
    return nil;
}

/**
 * 获取新浪的平台
 */
+ (NSNumber *)obtainSinaPlatform{
    return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfSina]];
}
/**
 * 获取微信好友的平台
 */
+ (NSNumber *)obtainWechatSessionPlatform{
    if ([self isAppInstalledToPlatform:SharePlatformTypeOfWechatSession]) {
        return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfWechatSession]];
    }
    return nil;
    
}
/**
 * 获取微信朋友圈的平台
 */
+ (NSNumber *)obtainWechatTimeLinePlatform{
    if ([self isAppInstalledToPlatform:SharePlatformTypeOfWechatTimeLine]) {
        return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfWechatTimeLine]];
    }
    return nil;
}
/**
 * 获取QQ的平台
 */
+ (NSNumber *)obtainQQPlatform{
    if ([self isAppInstalledToPlatform:SharePlatformTypeOfQQ]) {
        return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfQQ]];
    }
    return nil;
}
/**
 * 获取QQ空间的平台
 */
+ (NSNumber *)obtainQzonePlatform{
    if ([self isAppInstalledToPlatform:SharePlatformTypeOfQzone]) {
        return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfQzone]];
    }
    return nil;
}
/**
 * 获取支付宝的平台
 */
+ (NSNumber *)obtainAlipaySessionPlatform{
    if ([self isAppInstalledToPlatform:SharePlatformTypeOfAlipay]) {
        return [NSNumber numberWithInteger:[self obtainSocialPlatformTypeWithSharePlatformType:SharePlatformTypeOfAlipay]];
    }
    return nil;
}
/**
 * 获取短信的平台
 */
+ (NSNumber *)obtainSmsPlatfrom{
    return [NSNumber numberWithInteger:UMSocialPlatformType_Sms];
}
/**
 自定义类型获取第三方的分享类型

 @param sharePlatformType 平台
 @return 友盟对应分享平台
 */
+ (UMSocialPlatformType )obtainSocialPlatformTypeWithSharePlatformType:(SharePlatformType) sharePlatformType{
    UMSocialPlatformType socialPlatformType = UMSocialPlatformType_UnKnown;
    switch (sharePlatformType) {
        case SharePlatformTypeOfAll:
        case SharePlatformTypeOfFriend:
        case SharePlatformTypeOfAllExceptSms:
        case SharePlatformTypeOfFriendExceptSms:
            socialPlatformType = UMSocialPlatformType_UnKnown;
            break;
        case SharePlatformTypeOfQQ:
            socialPlatformType = UMSocialPlatformType_QQ;
            break;
            case SharePlatformTypeOfQzone:
            socialPlatformType = UMSocialPlatformType_Qzone;
            break;
            case SharePlatformTypeOfWechatSession:
            socialPlatformType = UMSocialPlatformType_WechatSession;
            break;
            case SharePlatformTypeOfWechatTimeLine:
            socialPlatformType = UMSocialPlatformType_WechatTimeLine;
            break;
            case SharePlatformTypeOfSina:
            socialPlatformType = UMSocialPlatformType_Sina;
            break;
            case SharePlatformTypeOfAlipay:
            socialPlatformType = UMSocialPlatformType_AlipaySession;
            break;
            case SharePlatformTypeOfSms:
            socialPlatformType = UMSocialPlatformType_Sms;
            break;
        default:
            break;
    }
    return socialPlatformType;
}

/**
 判断是否安装某个平台
 
 @param sharePlatformType 平台
 @return 成功 为安装  失败 为未安装
 */
+ (BOOL)isAppInstalledToPlatform:(SharePlatformType)sharePlatformType{
    BOOL isInstalled = NO;
    switch (sharePlatformType) {
        case SharePlatformTypeOfAll:
            isInstalled = NO;
            break;
        case SharePlatformTypeOfFriend:
            isInstalled = NO;
            break;
        case SharePlatformTypeOfAllExceptSms:
            isInstalled = NO;
            break;
        case SharePlatformTypeOfWechatSession:
        case SharePlatformTypeOfWechatTimeLine:
            // 判断有没安装微信
            isInstalled = [self isWXAppInstalled];
            break;
        case SharePlatformTypeOfQQ:
        case SharePlatformTypeOfQzone:
            isInstalled = [self isQQAppInstalled];
            break;
        case SharePlatformTypeOfSina:
            isInstalled = [self isSinaAppInstalled];
            break;
        case SharePlatformTypeOfAlipay:
            isInstalled = [self isAlipayAppInstalled];
            break;
        case SharePlatformTypeOfSms:
            isInstalled = YES;
            break;
        default:
            break;
    }
    return isInstalled;
}
/**
 授权登录
 
 @param shareDataModel 授权登录需要数据model
 @param completeBlock 成功或失败的回调
 */
+ (void)authWithPlatform:(OKShareDataModel *)shareDataModel
                complete:(ShareCompleteBlock )completeBlock{
    UMSocialPlatformType platformType = [self obtainSocialPlatformTypeWithSharePlatformType:shareDataModel.sharePlatformType];
    [[UMSocialManager defaultManager] authWithPlatform:platformType currentViewController:shareDataModel.currentViewController completion:^(id result, NSError *error) {
        if (error) {
            [self callBackToComplete:completeBlock completeModel:nil error:error];
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                OKShareCompleteModel *completeModel = [[OKShareCompleteModel alloc] init];
                completeModel.uid = resp.uid;
                completeModel.openid = resp.openid;
                completeModel.refreshToken = resp.refreshToken;
                completeModel.expiration = resp.expiration;
                completeModel.accessToken = resp.accessToken;
                completeModel.clickPlatformType = shareDataModel.sharePlatformType;
                [self callBackToComplete:completeBlock completeModel:completeModel error:nil];
            }else{
                 [self callBackToComplete:completeBlock completeModel:nil error:nil];
            }
        }
    }];

    [self changeCloseItemTextColorForWebSina:platformType];
}

//修改网页新浪微博的关闭按钮颜色
+ (void)changeCloseItemTextColorForWebSina:(UMSocialPlatformType)platformType {
    if (platformType == UMSocialPlatformType_Sina && ![self isAppInstalledToPlatform:SharePlatformTypeOfSina]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning 获取最顶层的控制器
//            UIViewController *viewController = [CCUtility obtainCurrentViewController];
//            CCLog(@"viewController %@",viewController);
//            NSArray *leftBarButtonItemsArray = viewController.navigationItem.leftBarButtonItems;
//            UIBarButtonItem *closeItem = ArrayGetValueIsClass(leftBarButtonItemsArray, CCNumberTypeOf0, @"UIBarButtonItem");
//            if (closeItem) {
//                [closeItem setTintColor:UIColorFromHex(COLOR_666666)];
//            }
        });
    }
}
/**
 获取各平台的用户信息
 
 @param shareDataModel 需要的model
 @param completeBlock 成功或失败的回调
 */
+ (void)getUserInfoWithPlatform:(OKShareDataModel *)shareDataModel
                       complete:(ShareCompleteBlock)completeBlock{
      UMSocialPlatformType platformType = [self obtainSocialPlatformTypeWithSharePlatformType:shareDataModel.sharePlatformType];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:shareDataModel.currentViewController completion:^(id result, NSError *error) {
        if (error) {
            [self callBackToComplete:completeBlock completeModel:nil error:error];
        }else{
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                 UMSocialUserInfoResponse *userinfo =result;
                 OKShareCompleteModel *completeModel = [[OKShareCompleteModel alloc] init];
                completeModel.uid = userinfo.uid;
                completeModel.openid = userinfo.openid;
                completeModel.refreshToken = userinfo.refreshToken;
                completeModel.expiration = userinfo.expiration;
                completeModel.accessToken = userinfo.accessToken;
                completeModel.originalResponse = userinfo.originalResponse;
                completeModel.name = userinfo.name;
                completeModel.iconurl = userinfo.iconurl;
                completeModel.gender = userinfo.gender;
                completeModel.clickPlatformType = shareDataModel.sharePlatformType;
                [self callBackToComplete:completeBlock completeModel:completeModel error:nil];
            }else{
                [self callBackToComplete:completeBlock completeModel:nil error:nil];
            }
        }
    }];
}
/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
+ (BOOL)handleOpenURL:(NSURL *)url{
    return [[UMSocialManager defaultManager] handleOpenURL:url]; 
}
/**
 *  判断微信是否安装
 */
+ (BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}
/**
 *  判断QQ是否安装
 */
+ (BOOL)isQQAppInstalled{
    // 暂时屏蔽qq
//    return [QQApiInterface isQQInstalled];
    return NO;
}
/**
 * 判断新浪是否安装
 */
+ (BOOL)isSinaAppInstalled{
   return  [WeiboSDK isWeiboAppInstalled];
}
/**
 * 判断支付宝是否安装
 */
+ (BOOL)isAlipayAppInstalled{
//    return [APOpenAPI isAPAppInstalled];
    return NO;
}

@end


// 分享内容的model
@implementation OKShareDataModel



@end

// 分享成功的回调
@implementation OKShareCompleteModel



@end
