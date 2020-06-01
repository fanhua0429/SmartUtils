//
//  UITabBar+badge.m
//  FreeCitizen
//
//  Created by 廖超龙 on 2018/4/27.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "UITabBar+SmartUtils.h"

@implementation UITabBar (SmartUtils)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    if (self.items.count == 0) {
        return;
    }
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;//圆形
    badgeView.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.345098 alpha:1.0];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.58) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.08 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}



@end
