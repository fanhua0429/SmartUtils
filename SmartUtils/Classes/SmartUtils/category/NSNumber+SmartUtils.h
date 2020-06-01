//
//  NSNumber+SmartUtils.h
//  SmartUtils
//
//  Created by 黄增权 on 2018/5/7.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(SmartUtils)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end
