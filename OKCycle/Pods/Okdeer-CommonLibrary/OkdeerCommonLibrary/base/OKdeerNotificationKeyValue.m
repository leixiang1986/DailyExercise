//
//  OKdeerNotificationKeyValue.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/16.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKdeerNotificationKeyValue.h"

@implementation OKdeerNotificationKeyValue

/**< 单点登录, 通知Keyvalue */
NSString *const kTokenExpiryNotification = @"tokenExpiryNotification";

/**< 需要重新登录 */
NSString *const kNeedUserLoginNotification = @"needUserLoginNotification";

/**< 需要清除用户信息 */
NSString *const kClearUserInfoNotification = @"clearUserInfoNotification";

@end
