//
//  OKUtility.m
//  Pods
//
//  Created by 雷祥 on 2017/3/13.
//
//

#import "OKUtility.h"

@implementation OKUtility
/**
 *  拨打电话
 *
 *  @param view     当前的控制器的view
 *  @param phoneNum 手机号
 */
+(void)ok_phoneCall:(UIView *)view num:(NSString *)phoneNum
{
    UIWebView*callWebview =[[UIWebView alloc] init] ;

    NSURL *telurl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telurl]];
    [view addSubview:callWebview];
}

@end
