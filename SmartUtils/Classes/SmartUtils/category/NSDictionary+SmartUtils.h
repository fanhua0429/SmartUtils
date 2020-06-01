//
//  NSDictionary+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (SmartUtils)
/**
 *  转化成JSON串
 *
 */
- (NSString *)jsonStringEncoded;

/**
 *  获取plist文件的内容
 *
 *  @param fileName plist文件名
 *
 */
+ (NSDictionary *)getDictionaryInfoWithPlistFile:(NSString *)fileName;



- (BOOL)pa_hasKey:(NSString *)key;

- (NSString *)pa_stringForKey:(id)key;

- (NSString *)pa_stringForKey:(id)key defaultValue:(NSString *)defaultValue;

- (NSNumber *)pa_numberForKey:(id)key;

- (NSDecimalNumber *)pa_decimalNumberForKey:(id)key;

- (NSArray *)pa_arrayForKey:(id)key;

- (NSDictionary *)pa_dictionaryForKey:(id)key;

- (NSInteger)pa_integerForKey:(id)key;

- (NSUInteger)pa_unsignedIntegerForKey:(id)key;

- (BOOL)pa_boolForKey:(id)key;

- (BOOL)pa_boolForKey:(id)aKey defaultValue:(BOOL)defaultValue;

- (int16_t)pa_int16ForKey:(id)key;

- (int32_t)pa_int32ForKey:(id)key;

- (int64_t)pa_int64ForKey:(id)key;

- (char)pa_charForKey:(id)key;

- (short)pa_shortForKey:(id)key;

- (float)pa_floatForKey:(id)key;

- (double)pa_doubleForKey:(id)key;

- (long long)pa_longLongForKey:(id)key;

- (unsigned long long)pa_unsignedLongLongForKey:(id)key;

- (NSDate *)pa_dateForKey:(id)key dateFormat:(NSString *)dateFormat;

- (CGFloat)pa_CGFloatForKey:(id)key;

- (CGPoint)pa_pointForKey:(id)key;

- (CGSize)pa_sizeForKey:(id)key;

- (CGRect)pa_rectForKey:(id)key;
@end

@interface NSMutableDictionary (SmartUtils)

/**
 *  添加对象
 *
 *  @param object ， 如果object为nil  不会进行添加
 *  @param key    key
 */
- (void)addOmegaUtilsObject:(id)object forKey:(NSString *)key;



- (void)pa_setValue:(id)i forKey:(NSString *)key;

- (void)pa_setValueEx:(id)aValue forKey:(NSString *)aKey;

- (void)pa_setString:(NSString *)i forKey:(NSString *)key;

- (void)pa_setBool:(BOOL)i forKey:(NSString *)key;

- (void)pa_setInt:(int)i forKey:(NSString *)key;

- (void)pa_setInteger:(NSInteger)i forKey:(NSString *)key;

- (void)pa_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key;

- (void)pa_setCGFloat:(CGFloat)f forKey:(NSString *)key;

- (void)pa_setChar:(char)c forKey:(NSString *)key;

- (void)pa_setFloat:(float)i forKey:(NSString *)key;

- (void)pa_setDouble:(double)i forKey:(NSString *)key;

- (void)pa_setLongLong:(long long)i forKey:(NSString *)key;

- (void)pa_setPoint:(CGPoint)o forKey:(NSString *)key;

- (void)pa_setSize:(CGSize)o forKey:(NSString *)key;

- (void)pa_setRect:(CGRect)o forKey:(NSString *)key;


@end
