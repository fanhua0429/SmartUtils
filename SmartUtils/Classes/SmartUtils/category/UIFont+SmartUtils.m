//
//  UIFont+SmartUtils.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "UIFont+SmartUtils.h"

@implementation UIFont (SmartUtils)

@end

@implementation UIFont (safe)
+ (UIFont *)safe_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [self fontWithName:fontName size:fontSize];
    if (!font) {
        if ([fontName containsString:@"Medium"]) {
            font = [self boldSystemFontOfSize:fontSize];
        } else {
            font = [self systemFontOfSize:fontSize];
        }
    }
    return font;
}


+ (UIFont *)mediumSystemFont:(CGFloat)fontSize
{
    if (@available(iOS 8.2, *)) {
        
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
    }
    else {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
}

@end
