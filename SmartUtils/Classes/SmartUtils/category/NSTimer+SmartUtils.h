//
//  NSTimer+SmartUtils.h
//  SmartUtils
//
//  Created by 黄增权 on 2018/5/7.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SmartUtils)


#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block ;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
#endif

/**
 @param shouldUseProxy 使用代理转发，避免循环引用
 @param runloopMode runloop模式
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
                            target:(id)aTarget
                          selector:(SEL)aSelector
                          userInfo:(id)userInfo
                           repeats:(BOOL)yesOrNo
                          useProxy:(BOOL)shouldUseProxy
                       runloopMode:(NSRunLoopMode)runloopMode;

- (void)sm_pause;
- (void)sm_resume;
- (void)sm_resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
