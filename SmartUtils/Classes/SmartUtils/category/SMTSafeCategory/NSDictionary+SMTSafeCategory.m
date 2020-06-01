//
//  NSDictionary+SMTSafeCategory.m
//  SMT-NT-iOS
//
//  Created by 莫冰(平安科技智慧政务团队) on 2018/5/3.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSDictionary+SMTSafeCategory.h"
#import "NSObject+SmartUtils.h"
#define isValidKey(key) ((key) != nil && ![key isKindOfClass:[NSNull class]])
#define isValidValue(value) (((value) != nil) && ![value isKindOfClass:[NSNull class]])
@implementation NSDictionary (SMTSafeCategory)

- (id)safeObjectForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (!obj) {
        return nil;
    }
    return obj;
}

- (NSString *)stringObjectForKey:(id)aKey
{
    id obj = [self safeObjectForKey:aKey];
    if (obj &&! [obj isKindOfClass:[NSNull class]]) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }else if ([obj isKindOfClass:[NSNumber class]]){
            return [NSString stringWithFormat:@"%@",obj];
        }
        return nil;
    }
    return nil;
}

//- (NSString *)smt_description {
//    NSString *desc = [self smt_description];
//    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
//    return desc;
//}

@end


@implementation NSMutableDictionary (SMTSafeCategory)

- (void)safeSetObject:(id)anObject forKey:(id)aKey{
    if (!isValidKey(aKey)) {
        return;
    }
    if ([aKey isKindOfClass:[NSString class]]) {
        [self setValue:anObject forKey:aKey];
    }
    else{
        if (anObject != nil) {
            [self setObject:anObject forKey:aKey];
        }
        else{
            [self removeObjectForKey:aKey];
        }
    }
}

- (void)safeRemoveObjectForKey:(id)aKey {
    if(aKey) {
        [self removeObjectForKey:aKey];
    }
}


@end
