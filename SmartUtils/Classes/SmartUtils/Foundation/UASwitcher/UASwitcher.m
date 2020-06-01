//
//  UASwitcher.m
//  CityAccount
//
//  Created by 林杜波 on 2018/3/5.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import "UASwitcher.h"
#import <UIKit/UIKit.h>

@implementation UASwitcher



+ (void)UAAppendingString:(NSString *)string {
    NSString *userAgent = [self getOriginUA];
    userAgent = [userAgent stringByAppendingPathComponent:string];
    [self changeUA:userAgent];
}

+ (void)UAAppendingPathComponent:(NSString *)pathComponent {
    NSString *userAgent = [self getOriginUA];
    userAgent = [userAgent stringByAppendingPathComponent:pathComponent];
    [self changeUA:userAgent];
}

+ (void)changeUA:(NSString *)userAgent {
    if (userAgent) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
    }
}

+ (void)clearUA {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAgent"];
}

#pragma mark - Helper
+ (NSString *)getOriginUA {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return userAgent;
}

@end
