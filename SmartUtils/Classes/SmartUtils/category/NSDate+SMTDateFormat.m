//
//  NSDate+SMTDateFormat.m
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/2/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSDate+SMTDateFormat.h"

@implementation NSDate (SMTDateFormat)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringWithDefaultDateFormat {
    return [self stringWithFormat:kSMTDefaultDateFormat];
}

- (NSString *)stringWithWeatherDateFormat {
    return [self stringWithFormat:kSMTWeatherDateFormat];
}

- (NSString *)stringWithWeatherDateFormat2 {
    return [self stringWithFormat:kSMTWeatherDateFormat2];
}

@end

@implementation NSString (SMTDateFormat)

- (NSDate *)dateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = format;
    
    return [[dateFormatter dateFromString:self] dateByAddingTimeInterval:dateFormatter.timeZone.secondsFromGMT];
}

- (NSDate *)dateWithDefaultDateFormat {
    return [self dateWithFormat:kSMTDefaultDateFormat];
}

- (NSDate *)dateWithWeatherDateFormat {
    return [self dateWithFormat:kSMTWeatherDateFormat];
}

- (NSDate *)dateWithWeatherDateFormat2 {
    return [self dateWithFormat:kSMTWeatherDateFormat2];
}

@end
