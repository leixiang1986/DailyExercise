//
//  OKShareManager.h
//  ShareDemo
//
//  Created by huangshupeng on 16/10/13.
//  Copyright © 2016年 huangshupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class OKShareCompleteModel,OKShareDataModel;
typedef NS_ENUM(NSUInteger,ShareContentType) {
    ShareContentTypeOfText,                  /**< 分享文字 */
    ShareContentTypeOfImage,                 /**< 分享图片 或带文字 */
    ShareContentTypeOfWeb,                   /**< 分享带有网页的链接 */
    ShareContentTypeOfMusic,                 /**< 分享音乐链接 */
    ShareContentTypeOfVedio,                 /**< 分享视频链接 */
};  /**< 分享内容的 */

typedef NS_ENUM(NSUInteger,SharePlatformType) {
    SharePlatformTypeOfAll,                 /**< 分享所有的平台  */
    SharePlatformTypeOfFriend,              /**< 分享好友例如qq好友 微信好友，短信 */
    SharePlatformTypeOfFriendExceptSms,     /**< 分享好友例如qq好友 微信好友 除了短信 */
    SharePlatformTypeOfAllExceptSms,        /**< 分享所有的平台除了短信 */
    SharePlatformTypeOfSina,                /**< 新浪 */
    SharePlatformTypeOfWechatSession,       /**< 微信聊天 */
    SharePlatformTypeOfWechatTimeLine,      /**< 微信朋友圈 */
    SharePlatformTypeOfQQ,                  /**< QQ聊天页面 */
    SharePlatformTypeOfQzone,               /**< qq空间 */
    SharePlatformTypeOfSms,                 /**< 短信 */
    SharePlatformTypeOfAlipay,              /**< 支付宝 */
    SharePlatformTypeUmeng,                 /**< 友盟 主要用于注册key*/
    
};   /**< 分享平台 */

typedef void(^ShareCompleteBlock)(OKShareCompleteModel *completeModel,NSError *error);                /**< 分享后的回调 completeModel 为nil 则分享失败 */
typedef void(^ShareDismissBlock)(void);     /**< 点击取消按钮 */
// 分享的基础类
@interface OKShareManager : NSObject

/**
 设置默认的分享链接  网页分享时没有传分享链接则拿这个数据

 @param shareUrl 分享链接
 */
+ (void)setDefaultShareUrl:(NSString *)shareUrl;

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
      redirectURL:(NSString *)redirectURL;

/**
 调起分享

 @param shareDataModel 分享内容的model
 @param completeBlock 分享成功或失败的回调
 @param dismissBlock 关闭的回调
 */
+ (void)shareToOKShareDataModel:(OKShareDataModel *)shareDataModel
                     complete:(ShareCompleteBlock)completeBlock
                      dismiss:(ShareDismissBlock)dismissBlock;
/**
 判断是否安装某个平台

 @param sharePlatformType 平台
 @return 成功 为安装  失败 为未安装
 */
+ (BOOL)isAppInstalledToPlatform:(SharePlatformType)sharePlatformType;
/**
 授权登录

 @param shareDataModel 授权登录需要数据model
 @param completeBlock 成功或失败的回调
 */
+ (void)authWithPlatform:(OKShareDataModel *)shareDataModel
                complete:(ShareCompleteBlock )completeBlock;
/**
 获取各平台的用户信息

 @param shareDataModel 需要的model
 @param completeBlock 成功或失败的回调
 */
+ (void)getUserInfoWithPlatform:(OKShareDataModel *)shareDataModel
                       complete:(ShareCompleteBlock)completeBlock;
/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

@end


// 分享内容的model
@interface OKShareDataModel : NSObject

/**
 * 标题  若分享文本或图片加文字的 请把内容放到title中
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;
/**
 * 分享的  若是图片分享以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象  或是分享出去的链接
 */
@property (nonatomic,strong)  id shareData;
/**
 *  分享平台
 */
@property (nonatomic,assign) SharePlatformType sharePlatformType;
/**
 *  分享内容的类型
 */
@property (nonatomic,assign) ShareContentType shareContentType;
/**
 * 当前的控制器
 */
@property (nonatomic,strong)id currentViewController;
/**
 * 默认的图片  网络图片不存在 则使用该图片的
 */
@property (nonatomic,strong) UIImage *placeholderImage;
@end

// 分享成功的回调
@interface OKShareCompleteModel : NSObject

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;
@property (nonatomic, copy) NSString  *refreshToken;
@property (nonatomic, copy) NSDate    *expiration;
@property (nonatomic, copy) NSString  *accessToken;
/**
 * 第三方原始数据
 */
@property (nonatomic, strong) id  originalResponse;
/**
 * 返回的信息
 */
@property (nonatomic, copy) NSString  *message;
/**
 *  点击分享的平台
 */
@property (nonatomic,assign) SharePlatformType clickPlatformType;
// 用户信息
@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *iconurl;
@property (nonatomic, copy) NSString  *gender;


@end


