//
//  NSDictionary+SmartUtils.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "NSDictionary+SmartUtils.h"

@implementation NSDictionary (SmartUtils)
- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error)
            return json;
    }
    return nil;
}

+ (NSDictionary *)getDictionaryInfoWithPlistFile:(NSString *)fileName {
    if (fileName.length == 0) {
        return nil;
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if (plistPath.length == 0) {
        return nil;
    }
    return [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
}




- (BOOL)pa_hasKey:(NSString *)key {
    return [self objectForKey:key] != nil;
}

- (NSString *)pa_stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSString *)pa_stringForKey:(id)key defaultValue:(NSString *)defaultValue {
    if (key != nil && [key conformsToProtocol:@protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null]) {
            if ([ret isKindOfClass:[NSString class]]) {
                return ret;
            } else if ([ret isKindOfClass:[NSDecimalNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            } else if ([ret isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
        }
    }
    
    return defaultValue;
}

- (NSNumber *)pa_numberForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    return nil;
}

- (NSDecimalNumber *)pa_decimalNumberForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (NSArray *)pa_arrayForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return nil;
}

- (NSDictionary *)pa_dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    return nil;
}

- (NSInteger)pa_integerForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)pa_unsignedIntegerForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)pa_boolForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

// 从 NSDictionary 中获取 key 对应的 bool 型value; 若无，则返回 defaultValue
- (BOOL)pa_boolForKey:(id)key defaultValue:(BOOL)defaultValue {
    if (key != nil && [key conformsToProtocol:@protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null] &&
            ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
            return [ret boolValue];
        }
    }
    
    return defaultValue;
}

- (int16_t)pa_int16ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int32_t)pa_int32ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int64_t)pa_int64ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (char)pa_charForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value charValue];
    }
    return 0;
}

- (short)pa_shortForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (float)pa_floatForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (double)pa_doubleForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (long long)pa_longLongForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)pa_unsignedLongLongForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (NSDate *)pa_dateForKey:(id)key dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

- (CGFloat)pa_CGFloatForKey:(id)key {
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGPoint)pa_pointForKey:(id)key {
    CGPoint point = CGPointFromString(self[key]);
    return point;
}
- (CGSize)pa_sizeForKey:(id)key {
    CGSize size = CGSizeFromString(self[key]);
    return size;
}
- (CGRect)pa_rectForKey:(id)key {
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}
@end


@implementation NSMutableDictionary (OmegaUtils)

- (void)addOmegaUtilsObject:(id)object forKey:(NSString *)key {
    if (!object || key.length == 0) {
        return;
    }
    [self setObject:object forKey:key];
}



- (void)pa_setValue:(id)i forKey:(NSString *)key {
    if (i != nil) {
        [self setValue:i forKey:key];
    }
}

- (void)pa_setValueEx:(id)aValue forKey:(NSString *)aKey {
    if (aValue != nil) {
        [self setValue:aValue forKey:aKey];
    } else {
        [self removeObjectForKey:aKey];
    }
}

- (void)pa_setString:(NSString *)i forKey:(NSString *)key {
    [self setValue:i forKey:key];
}

- (void)pa_setBool:(BOOL)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setInt:(int)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setCGFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}

- (void)pa_setChar:(char)c forKey:(NSString *)key {
    self[key] = @(c);
}

- (void)pa_setFloat:(float)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setDouble:(double)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setLongLong:(long long)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)pa_setPoint:(CGPoint)o forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(o);
}

- (void)pa_setSize:(CGSize)o forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(o);
}

- (void)pa_setRect:(CGRect)o forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(o);
}

@end
