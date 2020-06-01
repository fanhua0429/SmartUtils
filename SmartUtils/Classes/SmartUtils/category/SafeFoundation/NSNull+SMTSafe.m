//
//  NSNull+SMTSafe.m
//  FreeCitizen
//
//  Created by 林杜波 on 2018/5/3.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSNull+SMTSafe.h"
#import <objc/runtime.h>
//#import "SmartLog.h"

static NSString *const SMTSafeNULLModule = @"SMTSafeNULLModule";

@implementation NSNull (SMTSafe)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    __block id target = nil;
    [[self proxyObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:aSelector]) {
            target = obj;
            *stop = YES;
        }
    }];
//    STLogError(SMTSafeNULLModule, @"[NSNull %@] unrecognized selector", NSStringFromSelector(aSelector));
    return target;
}

- (NSArray *)proxyObjects {
    NSArray *objs = objc_getAssociatedObject(self, _cmd);
    if (!objs) {
        objs = @[@0,@"",@{},@[], [NSDate new]];
        objc_setAssociatedObject(self, _cmd, objs, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return objs;
}

@end
