//
//  OKdeerNotificationKeyValue.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/16.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

/***********************************
 *
 *
 *  存放通知Notification的keyvalue
 *
 *
 ***********************************/

#import <Foundation/Foundation.h>

@interface OKdeerNotificationKeyValue : NSObject

/**< 单点登录, 通知Keyvalue */
FOUNDATION_EXPORT NSString *const kTokenExpiryNotification;

/**< 需要重新登录 */
FOUNDATION_EXPORT NSString *const kNeedUserLoginNotification;

/**< 需要清除用户信息 */
FOUNDATION_EXPORT NSString *const kClearUserInfoNotification;

@end
