//
//  NSUserDefaults+safe.m
//  FreeCitizen
//
//  Created by 林杜波 on 2018/4/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSUserDefaults+safe.h"
#import <objc/runtime.h>
//#import "SmartLog.h"

static NSString *const SMTSafeUserDefaultsModule = @"SMTSafeUserDefaultsModule";

@implementation NSUserDefaults (safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(setObject:forKey:);
        SEL swizzledSelector = @selector(smt_setObject:forKey:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)smt_setObject:(id)value forKey:(NSString *)defaultName {
    if (!value) {
        [self smt_setObject:value forKey:defaultName];
        return;
    }
    
    // ref: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html#//apple_ref/doc/uid/10000048i-CH3-54303
    
    
    // filter non-property-list object
    __block BOOL isPropertyListObj = NO;
    [[self propertyList] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:NSClassFromString(obj)]) {
            isPropertyListObj = YES;
        }
    }];
    if (!isPropertyListObj) {
        NSString *log = [NSString stringWithFormat:@"try to save a non-property object:[%@] into NSUserDefaults forKey: %@", value, defaultName];
//        STLogError(SMTSafeUserDefaultsModule, log);
        return;
    }
    
    if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
        // filter non-property-list object in NSArray && NSDictionary
        value = [self collectionFilter:value];
    }
    [self smt_setObject:value forKey:defaultName];
}

// nest filter
- (id)collectionFilter:(id)collection {
    if ([collection isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([collection isKindOfClass:[NSArray class]]) {
        if ([collection indexOfObject:[NSNull null]] != NSNotFound) {
            return nil;
        } else {
            NSMutableArray *result = [collection mutableCopy];
            [collection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id rsp = [self collectionFilter:obj];
                if (!rsp) {
                    [result removeObject:obj];
                } else {
                    [result replaceObjectAtIndex:idx withObject:rsp];
                }
            }];
            return result;
        }
    } else if ([collection isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *result = [collection mutableCopy];
        [collection enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id rsp = [self collectionFilter:obj];
            if (!rsp) {
                [result removeObjectForKey:key];
            } else {
                [result setObject:rsp forKey:key];
            }
        }];
        return result;
    }
    return collection;
}

- (NSArray<NSString *> *)propertyList {
    static NSArray<NSString *> *whiteListCls = nil;
    if (!whiteListCls) {
        whiteListCls = @[@"NSString", @"NSArray", @"NSNumber", @"NSDictionary", @"NSData", @"NSDate"];
        // @"__NSDictionary0", @"__NSSingleEntryDictionaryI", @"__NSDictionaryI", @"__NSDictionaryM", @"__NSArray0", @"__NSSingleObjectArrayI", @"__NSArrayI", @"__NSArrayM", @"__NSCFConstantString", @"NSTaggedPointerString", @"_NSZeroData", @"__NSCFString", @"NSConcreteData", @"NSConcreteMutableData"...
    }
    return whiteListCls;
}

@end
