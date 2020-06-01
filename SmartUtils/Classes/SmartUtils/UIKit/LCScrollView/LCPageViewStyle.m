//
//  LCPageViewStyle.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "LCPageViewStyle.h"
#import "UIColor+SmartUtils.h"

@implementation LCPageViewStyle


- (CGFloat)titleViewHeight
{
    if (_titleViewHeight <= 0) {
        _titleViewHeight = 45;
    }
    return _titleViewHeight;
}
- (CGFloat)titleLabelFont
{
    if (_titleLabelFont <= 5) {
        _titleLabelFont = 15;
    }
    return _titleLabelFont;
}

-(UIFont*)titleLabelNormalFont
{
    if (_titleLabelNormalFont == nil) {
        _titleLabelNormalFont = [UIFont systemFontOfSize:self.titleLabelFont];
    }
    return _titleLabelNormalFont;
}

-(UIFont*)titleLabelSelectFont
{
    if (_titleLabelSelectFont == nil) {
        _titleLabelSelectFont = [UIFont systemFontOfSize:self.titleLabelFont];
    }
    return _titleLabelSelectFont;
}

- (UIColor *)titleLabelNormalColor
{
    if (_titleLabelNormalColor == nil) {
        _titleLabelNormalColor = [UIColor colorWithHexString:@"#969696"];
    }
    return _titleLabelNormalColor;
}
- (UIColor *)titleLabelNormalBgColor
{
    if (_titleLabelNormalBgColor == nil) {
        _titleLabelNormalBgColor = [UIColor whiteColor];
    }
    return _titleLabelNormalBgColor;
}

- (UIColor *)titleLabelSelectColor
{
    if (_titleLabelSelectColor == nil) {
        _titleLabelSelectColor = [UIColor colorWithHexString:@"#4D73F4"];
    }
    return _titleLabelSelectColor;
}
- (UIColor *)titleLabelSelectBgColor
{
    if (_titleLabelSelectBgColor == nil) {
        _titleLabelSelectBgColor = [UIColor whiteColor];
    }
    return _titleLabelSelectBgColor;
}

- (UIColor*)bottomLineBgColor
{
    if (_bottomLineBgColor==nil) {
        _bottomLineBgColor = [UIColor colorWithHexString:@"#E8E8E8"];
    }
    return _bottomLineBgColor;
}

@end
