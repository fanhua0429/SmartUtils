//
//  NSObject+swizzle.h
//  FreeCitizen
//
//  Created by 林杜波 on 2018/4/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzle)

/// NSArray / NSDictionary 为类族，方法实现在实际子类上，需要先找到实际实现方法的子类

+ (void)smt_exchangeInstanceMethod:(SEL)originMethod ofClass:(NSString *)ofCls withMethod:(SEL)newMethod ofOtherClass:(NSString *)toCls;
+ (void)smt_exchangeClassMethod:(SEL)originMethod ofClass:(NSString *)ofCls withMethod:(SEL)newMethod ofOtherClass:(NSString *)toCls;

- (BOOL)isNull;
@end
