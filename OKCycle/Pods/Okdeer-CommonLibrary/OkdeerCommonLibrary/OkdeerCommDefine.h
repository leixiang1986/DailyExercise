//
//  OkdeerCommDefine.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef OkdeerCommDefine_h
#define OkdeerCommDefine_h

#if defined(DEBUG)||defined(_DEBUG)
#define CCLog(fmt, ...) NSLog((@"[函数名:%s] " " [行号:%d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CCLog(fmt, ...)
#endif

/**
 *  定义弱引用
 */
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define STRONGSELF(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

//色码转RGB UIColor
#undef UIColorFromHex
#define UIColorFromHex(hexValue) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])
//附带透明度
#undef UIColorFromHexA
#define UIColorFromHexA(hexValue,a) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:(a)])

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define STRONGSELF(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
// 是否支持手势右滑返回
#define PopGestureRecognizerenabled(ret)   (self.navigationController.interactivePopGestureRecognizer.enabled = ret)

#undef LocalKey
#define LocalKey(key) NSLocalizedString(key, nil)

// 拼接URL    version  不需加/
#undef AppendURL
#define AppendURL(prefix,className,version,path) ([NSString stringWithFormat:@"%@%@%@%@",prefix,className,(version.length ? [NSString stringWithFormat:@"/%@",version] : @""),path])

#define kCode                                   @"code"
#define kData                                   @"data"
#define kMessage                                @"message"
#define kString                                 @"NSString"                // 字符串
#define kArray                                  @"NSArray"                 // 数组
#define kDictionary                             @"NSDictionary"            // 字典
#define kAttributedString                       @"NSAttributedString"
#define kNumber                                 @"NSNumber"
#define kQuestionMark                           @"?"                        // ？
#define kJoiner                                 @"&"                        // &

#define ScreenGridViewHeight    (1/[UIScreen mainScreen].scale)
#define kDefaultAlertTime 2.0

#define kStatusBarHeight            ([UIApplication sharedApplication].statusBarFrame.size.height)    // 状态栏高度
#define kFullScreenWidth           ([UIScreen mainScreen].bounds.size.width)                          // 全屏的宽度
#define kFullScreenHeight          ( [UIScreen mainScreen].bounds.size.height)                        // 全屏的高度
#define kExceptStatusBarHeight     (kFullScreenHeight - kStatusBarHeight)                             // 除了状态栏的高度
#define kNavigationBarHeight        44.00f                                                            // 导航栏的高度
#define kTabbarHeight               49.00f                                                            // 状态栏高度
#define kStatusBarAndNavigationBarHeight   (kNavigationBarHeight + kStatusBarHeight)          /**< 导航栏和状态栏的高度*/

/**
 *  判断版本是否大于等于7/8的布尔变量
 */
#define iOS7UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9UP  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS10UP ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

/**
 * 判断机器型号
 */
#define isPhone4 (([UIScreen mainScreen ].bounds.size.height == 480.0)?YES:NO)
#define isPhone5 (([UIScreen mainScreen ].bounds.size.height == 568.0)?YES:NO)
#define isPhone6 (([UIScreen mainScreen ].bounds.size.height == 667.0)?YES:NO)
#define isPhone6P (([UIScreen mainScreen ].bounds.size.height == 736.0)?YES:NO)


/**
 *  字体的大小
 */
#undef FONTWITHNAME
#define FONTWITHNAME(fontName,fontSize)    ([UIFont fontWithName:fontName size:fontSize])
//系统默认字体   设置字体的大小
#undef FONTDEFAULT
#define FONTDEFAULT(fontSize)            ([UIFont systemFontOfSize:fontSize])
//系统加粗字体   设置字体的大小
#undef FONTBOLD
#define FONTBOLD(fontSize)            ([UIFont boldSystemFontOfSize:fontSize])


#define ArrayGetValueIsClass(array,index,class) ([array ok_arrayItemAtIndex:index isClass:class])
#define StringGetLength(string) ([string ok_stringLength])
#define OKToString(obj)  [NSString ok_toString:(obj)]


/**
 *  获取 appdelegate
 */
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#endif /* OkdeerCommDefine_h */
