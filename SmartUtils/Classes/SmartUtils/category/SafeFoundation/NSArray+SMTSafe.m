//
//  NSArray+SMTSafe.m
//  FreeCitizen
//
//  Created by 林杜波 on 2018/4/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSArray+SMTSafe.h"
#import "NSObject+swizzle.h"
//#import "SmartLog.h"

static NSString *const SMTSafeArrayModule = @"SMTSafeArrayModule";

@implementation NSArray (SMTSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// objectAtIndex:
        [self smt_exchangeInstanceMethod:@selector(objectAtIndex:) ofClass:@"__NSArrayI" withMethod:@selector(smt_objectAtIndex:) ofOtherClass:@"NSArray"];
        [self smt_exchangeInstanceMethod:@selector(objectAtIndex:) ofClass:@"__NSArray0" withMethod:@selector(smt_emptyArrayObjectAtIndex:) ofOtherClass:@"NSArray"];
        //iOS10 以下不要调用此方法，键盘弹出情况下前后台切换会出现奔溃
        if (@available(iOS 10.0, *)) {
            [self smt_exchangeInstanceMethod:@selector(objectAtIndex:) ofClass:@"__NSArrayM" withMethod:@selector(smt_mutableArrayObjectAtIndex:) ofOtherClass:@"NSArray"];
        }
        /// arrayByAddingObject:
        [self smt_exchangeInstanceMethod:@selector(arrayByAddingObject:) ofClass:@"__NSArrayI" withMethod:@selector(smt_arrayByAddingObject:) ofOtherClass:@"NSArray"];
        
        /// objectAtIndexedSubscript:
        [self smt_exchangeInstanceMethod:@selector(objectAtIndexedSubscript:) ofClass:@"__NSArray0" withMethod:@selector(smt_emptyArrayObjectAtIndexedSubscript:) ofOtherClass:@"NSArray"];
        [self smt_exchangeInstanceMethod:@selector(objectAtIndexedSubscript:) ofClass:@"__NSArrayM" withMethod:@selector(smt_mutableArrayObjectAtIndexedSubscript:) ofOtherClass:@"NSArray"];
        [self smt_exchangeInstanceMethod:@selector(objectAtIndexedSubscript:) ofClass:@"__NSArrayI" withMethod:@selector(smt_imutableArrayObjectAtIndexedSubscript:) ofOtherClass:@"NSArray"];
        
    });
}

- (id)smt_objectAtIndex:(NSUInteger)index{
    // 越界
    if (index >= [self count]) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: index %@ beyond bounds", cls, method, @(index));
        return nil;
    }
    
    id obj = [self smt_objectAtIndex:index];
    return obj;
}

- (id)smt_emptyArrayObjectAtIndex:(NSUInteger)index{
    return nil;
}

- (id)smt_mutableArrayObjectAtIndex:(NSUInteger)index{
    // 越界
    if (index >= [self count]) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: index %@ beyond bounds", cls, method, @(index));
        return nil;
    }
    
    id obj = [self smt_mutableArrayObjectAtIndex:index];
    return obj;
}

- (NSArray *)smt_arrayByAddingObject:(id)anObject {
    if (!anObject) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: insert a nil object", cls, method);
        return self;
    }
    return [self smt_arrayByAddingObject:anObject];
}

- (id)smt_emptyArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: index %@ beyond bounds", cls, method, @(idx));
        return nil;
    }
    return [self smt_emptyArrayObjectAtIndexedSubscript:idx];
}

- (id)smt_imutableArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: index %@ beyond bounds", cls, method, @(idx));
        return nil;
    }
    return [self smt_imutableArrayObjectAtIndexedSubscript:idx];
}

- (id)smt_mutableArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *cls = NSStringFromClass(self.class);
        NSString *method = NSStringFromSelector(_cmd);
//        STLogError(SMTSafeArrayModule, @"[%@ %@]: index %@ beyond bounds", cls, method, @(idx));
        return nil;
    }
    return [self smt_mutableArrayObjectAtIndexedSubscript:idx];
}

@end
