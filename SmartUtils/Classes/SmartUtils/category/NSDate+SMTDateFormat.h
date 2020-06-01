//
//  NSDate+SMTDateFormat.h
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/2/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 常用格式字符整理：
 G:      公元时代，例如AD公元
 yy:     年的后2位
 yyyy:   完整年
 MM:     月，显示为1-12,带前置0
 MMM:    月，显示为英文月份简写,如 Jan
 MMMM:   月，显示为英文月份全称，如 Janualy
 dd:     日，2位数表示，如02
 d:      日，1-2位显示，如2，无前置0
 EEE:    简写星期几，如Sun
 EEEE:   全写星期几，如Sunday
 aa:     上下午，AM/PM
 H:      时，24小时制，0-23
 HH:     时，24小时制，带前置0
 h:      时，12小时制，无前置0
 hh:     时，12小时制，带前置0
 m:      分，1-2位
 mm:     分，2位，带前置0
 s:      秒，1-2位
 ss:     秒，2位，带前置0
 S:      毫秒
 Z：      GMT（时区）
 */


/** 默认日期格式 e.g. 2018-02-07 14:02:28 */
static NSString * const kSMTDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";

/** 天气日期格式 e.g. 20180207 */
static NSString * const kSMTWeatherDateFormat = @"yyyyMMdd";

/** 天气日期格式2 e.g. 07日星期三 */
static NSString * const kSMTWeatherDateFormat2 = @"dd日EEEE";


/**
 日期格式工具
 */
@interface NSDate (SMTDateFormat)

/**
 Date -> String 根据指定的格式返回对应格式的日期字符串

 @param format 日期格式
 @return 返回对应格式的日期字符串
 */
- (NSString *)stringWithFormat:(NSString *)format;


#pragma mark - Convenient Methods


/**
 返回默认格式的日期字符串
 */
- (NSString *)stringWithDefaultDateFormat;


/**
 返回首页天气的日期字符串
 */
- (NSString *)stringWithWeatherDateFormat;


/**
 返回首页天气的日期字符串
 */
- (NSString *)stringWithWeatherDateFormat2;


@end



/**
 日期格式工具
 */
@interface NSString (SMTDateFormat)


/**
 String -> Date 根据指定的格式日期字符串格 返回对应的日期对象

 @param format 日期格式
 @return 返回对应的日期对象
 */
- (NSDate *)dateWithFormat:(NSString *)format;


#pragma mark - Convenient Methods


/**
 默认格式转换为Date对象
 */
- (NSDate *)dateWithDefaultDateFormat;

/**
 首页天气的日期格式转换为Date对象
 */
- (NSDate *)dateWithWeatherDateFormat;

/**
 首页天气的日期格式转换为Date对象
 */
- (NSDate *)dateWithWeatherDateFormat2;

@end
