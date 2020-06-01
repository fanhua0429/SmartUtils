//
//  UIFont+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (SmartUtils)

@end

@interface UIFont (safe)
+ (UIFont *)safe_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

+ (UIFont *)mediumSystemFont:(CGFloat)fontSize;

@end
