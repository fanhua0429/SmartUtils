//
//  NSArray+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SmartUtils)
/**
 *  将数组转化成json串
 */
- (NSString *)jsonStringEncoded;
@end

@interface NSMutableArray (SmartUtils)

/**
 *  添加对象，如果object为nil  不会进行添加
 */
- (void)addSafeObject:(id)object;

/**
 *  追加对象，如果object为nil  不会进行添加
 */
- (void)appendSafeObject:(id)object;

/**
 *  追加数组
 */
- (void)appendSafeObjects:(NSArray *)objects;



#pragma mark - read

/**
 return value if index is valid, return nil if others.
 */
- (id)pa_objectAtIndex:(NSUInteger)index;

/**
 return @"" if value is nil or NSNull; return value if NSString or NSNumber class; return nil if others
 */
- (NSString *)pa_stringWithIndex:(NSUInteger)index;

/**
 return nil if value is nil or NSNull; return NSDictionary if value is NSDictionary; return nil if others.
 */
- (NSDictionary *)pa_dictionaryWithIndex:(NSUInteger)index;


@end

