//
//  UILabel+PAAttributeTextTap.h
//  SmartUtils
//
//  Created by 杨彪(平安科技智慧生活团队IOS开发组) on 2018/11/8.
//  Copyright © 2018 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PAAttributeTextTapDelegate <NSObject>
@optional
/**
 *  PAAttributeTextTapDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)pa_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface UILabel (PAAttributeTextTap)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)pa_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)pa_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <PAAttributeTextTapDelegate> )delegate;

@end
