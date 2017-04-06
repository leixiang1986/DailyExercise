//
//  OKUtility.h
//  Pods
//
//  Created by 雷祥 on 2017/3/13.
//
//

#import <Foundation/Foundation.h>

@interface OKUtility : NSObject

/**
 *  拨打电话
 *
 *  @param view     当前的控制器的view
 *  @param phoneNum 手机号
 */
+(void)ok_phoneCall:(UIView *)view num:(NSString *)phoneNum;


@end
