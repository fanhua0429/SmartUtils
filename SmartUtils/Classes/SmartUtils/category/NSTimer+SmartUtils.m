//
//  NSTimer+SmartUtils.m
//  SmartUtils
//
//  Created by 黄增权 on 2018/5/7.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "NSTimer+SmartUtils.h"
#import "PAWeakProxy.h"

@implementation NSTimer (SmartUtils)

+ (void)sm_timerExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(sm_timerExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(sm_timerExecBlock:) userInfo:[block copy] repeats:repeats];
}
#endif

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo useProxy:(BOOL)shouldUseProxy runloopMode:(NSRunLoopMode)runloopMode {
    id target = shouldUseProxy?[[PAWeakProxy alloc] initWithTarget:aTarget]:aTarget;
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:target selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:runloopMode];
    return timer;
}

-(void)sm_pause
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)sm_resume
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)sm_resumeAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
