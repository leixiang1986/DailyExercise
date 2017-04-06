//
//  UMSocialUIManager.h
//  UMSocialSDK
//
//  Created by umeng on 16/8/10.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMShareMenuSelectionView.h"

@interface UMSocialUIManager : NSObject

+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock;
/**
 * 增加一个方法  传多一个分享的平台
 */
+ (void)showShareMenuViewInWindowWithPlatformTypeArray:(NSArray *)platformTypeArray  platformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock dismissBlock:(void(^)())dismissBlock;

@end
