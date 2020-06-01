//
//  NSDate+SmartUtils.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "NSDate+SmartUtils.h"


@implementation NSDate (SmartUtils)

+(NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] year];
}

- (NSInteger)weekDay {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) > 60 * 60 * 24) {
        return NO;
    }
    return [NSDate new].day == self.day;
}

- (BOOL)isWeekDay {
    if (fabs(self.timeIntervalSinceNow) > 60 * 60 * 24 * 7) {
        return NO;
    }
    return [NSDate new].weekDay == self.weekDay;
}

- (BOOL)isYesterDay {
    NSDate *added = [self dateByAddingDays:1];
    return [added isToday];
}

- (BOOL)isTomorrowDay {
    NSDate *minuted = [self dateByAddingDays:-1];
    return [minuted isToday];
}

- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimerInterval = [self timeIntervalSinceReferenceDate] + 60 * 60 * 24 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimerInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * 60 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)stringFormatWithStyle:(YZODateFormatStyle)dateFormatterStyle {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    formatter.timeStyle = kCFDateFormatterShortStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = [self formatterStringFromDateFormatter:dateFormatterStyle];
    return [formatter stringFromDate:self];
}

- (NSString *)stringFormatWithCustomeFormatter:(NSString *)customeFormatter {
    if (customeFormatter.length == 0) {
        customeFormatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    formatter.timeStyle = kCFDateFormatterShortStyle;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = customeFormatter;
    return [formatter stringFromDate:self];
}

- (NSString *)formatterStringFromDateFormatter:(YZODateFormatStyle)dateFormatterStyle {
    switch (dateFormatterStyle) {
        case YZOyyyyMMddHHmmssStyle: {
            return @"yyyy-MM-dd HH:mm:ss";
            break;
        }
        case YZOyyMMddHHmmssStyle: {
            return @"yy-MM-dd HH:mm:ss";
            break;
        }
        case YZOyyyyMMddHHmmStyle: {
            return @"yyyy-MM-dd HH:mm";
            break;
        }
        case YZOyyMMddHHmmStyle: {
            return @"yy-MM-dd HH:mm";
            break;
        }
        case YZOyyyyMMddStyle: {
            return @"yyyy-MM-dd";
            break;
        }
        case YZOyyMMddStyle: {
            return @"yy-MM-dd";
            break;
        }
        case YZOHHmmssStyle: {
            return @"HH:mm:ss";
            break;
        }
        case YZOHHmmStyle: {
            return @"HH:mm";
            break;
        }
    }
    return @"yyyy-MM-dd HH:mm:ss";
}

- (NSString *)getDateWeekDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    long weekNumber = [components weekday];
    if (weekNumber == 2) {
        return @"星期一";
    } else if (weekNumber == 3) {
        return @"星期二";
    } else if (weekNumber == 4) {
        return @"星期三";
    } else if (weekNumber == 5) {
        return @"星期四";
    } else if (weekNumber == 6) {
        return @"星期五";
    } else if (weekNumber == 7) {
        return @"星期六";
    }
    return @"星期日";
}

+ (NSString *)getRelevantDateStringFromTimeStamp:(long long)timeStamp isShort:(BOOL)isShort {
    if (timeStamp == 0) {
        return @"";
    }
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    if ([newDate isToday]) {
        return (isShort)
        ? @"今天"
        : [NSString stringWithFormat:@"今天 %@", [newDate stringFormatWithStyle:YZOHHmmStyle]];
    } else if ([newDate isYesterDay]) {
        return (isShort)
        ? @"昨天"
        : [NSString stringWithFormat:@"昨天 %@", [newDate stringFormatWithStyle:YZOHHmmStyle]];
    } else if ([newDate isWeekDay]) {
        return (isShort) ? [newDate getDateWeekDay]
        : [NSString stringWithFormat:@"%@ %@", [newDate getDateWeekDay],
           [newDate stringFormatWithStyle:YZOHHmmStyle]];
    }
    return (isShort) ? [newDate stringFormatWithStyle:YZOyyyyMMddStyle]
    : [newDate stringFormatWithStyle:YZOyyMMddHHmmssStyle];
}

#pragma mark - shenzhen added
+ (NSDate *)todayOriginDate {
    NSDate *now = [NSDate date];
    return [now originDate];
}

+ (NSArray *)dateStringArrayFromDate:(NSDate *)startDate offsetDay:(NSInteger)offsetDay dateFormatter:(NSString *)formatter {
    NSMutableArray *dateStringArray = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    
    for (NSInteger i = 0; i < offsetDay; i++) {
        NSString *dateString = [dateFormatter stringFromDate:[startDate dateDayOffset:i]];
        [dateStringArray addObject:dateString];
    }
    return dateStringArray;
}

- (NSDate *)originDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDate *startDate = [calendar dateFromComponents:components];
    return startDate;
}

- (NSDate *)dateDayOffset:(NSInteger)offset {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:offset toDate:self options:NSCalendarMatchStrictly];
}

- (NSInteger)dateOffsetWithDate:(NSDate *)date {
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:date];
    return timeInterval / (24 * 60 * 60);
}

#pragma mark - kmdateformatter

+ (NSDateFormatter *)km_formatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone systemTimeZone];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return formatter;
}

+ (void)km_setDefaultFormat:(NSString *)newFormat {
    if (newFormat.length > 0) {
        NSDateFormatter *formatter = [NSDate km_formatter];
        //  确保formatter.dateFormat不会在多线程下被串改
        @synchronized(formatter) {
            formatter.dateFormat = newFormat;
        }
    }
}

- (NSString *)km_dateString {
    NSDateFormatter *formatter = [NSDate km_formatter];
    //  确保formatter.dateFormat不会在多线程下被串改
    @synchronized(formatter) {
        return [[NSDate km_formatter] stringFromDate:self];
    }
}

- (NSString *)km_dateStringWithFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate km_formatter];
    //  确保formatter.dateFormat不会在多线程下被串改
    @synchronized(formatter) {
        NSString *defaultFormat = formatter.dateFormat;
        if (dateFormat.length > 0) {
            formatter.dateFormat = dateFormat;
        }
        NSString *result = [formatter stringFromDate:self];
        formatter.dateFormat = defaultFormat;
        return result;
    }
}

@end
