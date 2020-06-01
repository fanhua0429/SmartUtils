//
//  UIColor+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN UIColor* UIRGBColor(CGFloat red, CGFloat green, CGFloat blue);
UIKIT_EXTERN UIColor* UIRGBAColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
UIKIT_EXTERN UIColor* UIColorWithHexString(NSString *hexString);
UIKIT_EXTERN UIColor* UIColorWithHexStringA(NSString *hexString, CGFloat alpha);
UIKIT_EXTERN UIColor* UIColorWithHex(NSInteger hex);
UIKIT_EXTERN UIColor* UIColorWithHexA(NSInteger hex, CGFloat alpha);

@interface UIColor (SmartUtils)
/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

/**
 生成一个随机RGB的颜色
 
 @return 返回一个随机颜色
 */
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
