//
//  NSObject+swizzle.m
//  FreeCitizen
//
//  Created by 林杜波 on 2018/4/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSObject+swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (swizzle)

+ (void)smt_exchangeInstanceMethod:(SEL)originMethod ofClass:(NSString *)ofCls withMethod:(SEL)newMethod ofOtherClass:(NSString *)toCls {
    Class ofClass = NSClassFromString(ofCls);
    Class toClass = NSClassFromString(toCls);
    if (!ofClass || !toClass) {
        return;
    }
    
    Method ofMethod = class_getInstanceMethod(ofClass, originMethod);
    Method toMethod = class_getInstanceMethod(toClass, newMethod);
    if (!ofMethod || !toMethod) {
        return;
    }
    
    method_exchangeImplementations(ofMethod, toMethod);
}

+ (void)smt_exchangeClassMethod:(SEL)originMethod ofClass:(NSString *)ofCls withMethod:(SEL)newMethod ofOtherClass:(NSString *)toCls {
    Class ofClass = NSClassFromString(ofCls);
    Class toClass = NSClassFromString(toCls);
    if (!ofClass || !toClass) {
        return;
    }
    
    Method ofMethod = class_getClassMethod(ofClass, originMethod);
    Method toMethod = class_getClassMethod(toClass, newMethod);
    if (!ofMethod || !toMethod) {
        return;
    }
    
    method_exchangeImplementations(ofMethod, toMethod);
}

- (BOOL)isNull {
    return [self isEqual:[NSNull null]];
}

@end
