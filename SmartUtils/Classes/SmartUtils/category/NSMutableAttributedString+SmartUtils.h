//
//  NSMutableAttributedString+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (SmartUtils)
/**
 *  关键字颜色修改
 *
 *  @param keyword 关键字
 *  @param color   颜色
 *
 */
- (NSAttributedString *)highlightKeyword:(NSString *)keyword withColor:(UIColor *)color;

/**
 *  关键字font修改
 *
 *  @param keyword 关键字
 *  @param font    font
 *
 */
- (NSAttributedString *)highlightKeyword:(NSString *)keyword withFont:(UIFont *)font;

/**
 *  数字字体颜色修改
 *
 *  @param color 颜色
 *  @param font  字体
 *
 */
- (NSAttributedString *)hightlightedNumbersWithColor:(UIColor *)color andFont:(UIFont *)font;

+ (NSMutableAttributedString *)pa_attributeText:(NSString *)string;

- (CGSize)pa_drawingSizeWithSize:(CGSize)size;

- (void)pa_setFont:(UIFont *)font;

- (void)pa_setFont:(UIFont *)font range:(NSRange)range;

- (void)pa_setColor:(UIColor *)color;

- (void)pa_setColor:(UIColor *)color range:(NSRange)range;

- (void)pa_setLineSpace:(NSInteger)space;

- (void)pa_setLineSpace:(NSInteger)space range:(NSRange)range;
@end
