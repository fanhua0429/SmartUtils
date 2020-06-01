//
//  UILabel+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UILabel (SmartUtils)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

#pragma -mark - codable

/**
 Set this property to YES in order to enable the copy feature. Defaults to NO.
 */
@property (nonatomic) IBInspectable BOOL copyingEnabled;

/**
 Used to enable/disable the internal long press gesture recognizer. Defaults to YES.
 */
@property (nonatomic) IBInspectable BOOL shouldUseLongPressGestureRecognizer;

#pragma mark - size
/**
 自动调整Label的Size到最适合的尺寸
 
 @param maxSize label可以达到的最大尺寸
 */
- (void)sizeToFit:(CGSize)maxSize;
@end
NS_ASSUME_NONNULL_END
