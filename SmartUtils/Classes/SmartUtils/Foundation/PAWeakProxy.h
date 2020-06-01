//
//  PAWeakProxy.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/16.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAWeakProxy : NSProxy
/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;
@end
