//
//  NSDate+OkdeerHelp.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (OkdeerHelp)

+ (void)initializeStatics;
+ (nullable NSDateFormatter *)sharedDateFormatter;

- (nullable NSString *)stringWithFormat:(nullable NSString *)format;

- (BOOL) isToday;

/**
 *  是否是闰年, Yes 是, NO 否
 */
- (BOOL) isLeapYear:(nullable NSString *)year;

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) BOOL isLeapYear; ///< whether the year is leap year

- (nullable NSString *)stringWithFormat:(nullable NSString *)format timeZone:(nullable NSTimeZone *)timeZone;
+ (nullable NSDate *)dateWithString:(nullable NSString *)dateString format:(nullable NSString *)format timeZone:(nullable NSTimeZone *)timeZone;

@end
