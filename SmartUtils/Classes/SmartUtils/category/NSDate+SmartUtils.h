//
//  NSDate+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, YZODateFormatStyle) {
    YZOyyyyMMddHHmmssStyle,  // "yyyy-MM-dd HH:mm:ss"
    YZOyyMMddHHmmssStyle,    // "yy-MM-dd HH:mm:ss"
    YZOyyyyMMddHHmmStyle,    // "yyyy-MM-dd HH:mm"
    YZOyyMMddHHmmStyle,      // "yy-MM-dd HH:mm"
    YZOyyyyMMddStyle,        // "yyyy-MM-dd"
    YZOyyMMddStyle,          // "yy-MM-dd"
    YZOHHmmssStyle,          // "HH:mm:ss"
    YZOHHmmStyle             // "HH:mm"
};

@interface NSDate (SmartUtils)
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger weekDay;

@property (nonatomic, readonly) NSInteger quarter;

/**
 *  判断Date是不是今天
 *
 *
 */
- (BOOL)isToday;

/**
 *  判断Date是不是昨天
 *
 *
 */
- (BOOL)isYesterDay;

/**
 *  判断Date是不是明天
 *
 *
 */
- (BOOL)isTomorrowDay;

/**
 *  判断Date是不是本周
 *
 *
 */
- (BOOL)isWeekDay;

/**
 *  获取本周周几信息
 *
 *
 */
- (NSString *)getDateWeekDay;

/**
 *  按年添加时间
 *
 *  @param years  添加年数
 *
 *
 */
- (NSDate *)dateByAddingYears:(NSInteger)years;

/**
 *  按月添加时间
 *
 *  @param months 添加月数
 *
 *
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 *  按天添加时间
 *
 *  @param days 添加天数
 *
 *
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

/**
 *  按小时添加时间
 *
 *  @param hours 添加小时数
 *
 *
 */
- (NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 *  微商城所需接口 根绝timeStamp获取当先显示的时间内容 参照微信添加周信息
 *
 *  @param timeStamp 距离1970年的数据
 *  @param isShort   显示完整信息
 *
 *
 */
+ (NSString *)getRelevantDateStringFromTimeStamp:(long long)timeStamp isShort:(BOOL)isShort;

/**
 *  格式化当前时间
 *
 */
- (NSString *)stringFormatWithStyle:(YZODateFormatStyle)style;

/**
 *  格式化当前时间
 *
 *  @param customeFormatter 时间的格式，默认是yyyy-MM-dd HH:mm:ss
 *
 *    当前的时间格式
 */
- (NSString *)stringFormatWithCustomeFormatter:(NSString *)customeFormatter;

#pragma mark - shenzhen added
/**
 返回当天开始时间
 */
+ (NSDate *)todayOriginDate;

/**
 得到一系列的格式化时间字符串

 @param startDate 开始时间
 @param offsetDay 时间间隔
 @param formatter 格式化对象
 @return 一系列的格式化时间字符串
 */
+ (NSArray *)dateStringArrayFromDate:(NSDate *)startDate
                           offsetDay:(NSInteger)offsetDay
                       dateFormatter:(NSString *)formatter;

/**
 返回当前date对象的当天开始时间
 */
- (NSDate *)originDate;

/**
 计算距离指定date的天数

 @param date 指定的date时刻
 @return 与self间隔的天数
 */
- (NSInteger)dateOffsetWithDate:(NSDate *)date;

#pragma mark - KMDateFormmatter  使用dateFormatter用单例，速度会快些

+ (NSDateFormatter *)km_formatter;

/// format date string, default format set to @"yyyy-MM-dd HH:mm:ss"
- (NSString *)km_dateString;

/// format date string with custom dateFormat (use default format if param is nil), this dateFormat won't change default format
- (NSString *)km_dateStringWithFormat:(NSString *)dateFormat;

/// change the default format
+ (void)km_setDefaultFormat:(NSString *)newFormat;
@end
