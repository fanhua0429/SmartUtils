//
//  UASwitcher.h
//  CityAccount
//
//  Created by 林杜波 on 2018/3/5.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UASwitcher : NSObject
/// 在原UA上添加
+ (void)UAAppendingString:(NSString *)string;

/// 在原UA上添加
+ (void)UAAppendingPathComponent:(NSString *)pathComponent;

/// 修改UA
+ (void)changeUA:(NSString *)userAgent;

/// 删除UA
+ (void)clearUA;


@end
