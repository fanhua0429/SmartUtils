//
//  UITabBar+badge.h
//  FreeCitizen
//
//  Created by 廖超龙 on 2018/4/27.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (SmartUtils)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
