//
//  SMTBadge.h
//  BadgeDemo
//
//  Created by 廖超龙 on 2018/5/18.
//  Copyright © 2018年 liaochaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMTBadge : UIView

/**
 圆点上最大的数字；默认是99
 */
@property (nonatomic, assign) NSInteger maximumNumber;

/**
 圆点上显示的数字；
 @note 设置为nil则隐藏数字；仅显示圆点
 设置成@0则隐藏当前圆点(alpha为0)
 */
@property (nonatomic, strong, nullable) NSNumber *number;

/**
 圆点上的字体大小；默认是heigh-2
 */
@property (nonatomic, assign) CGFloat fonSize;


/**
 圆点字体颜色；默认是白色
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 设置圆点背景颜色
 */
@property(nullable, nonatomic,copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 创建一个badge

 @param height 制定的高度；不能再改变； 使用其他init创建的高度是8
 @return 一个badge视图实例
 */
- (instancetype)initWithHeight:(CGFloat)height NS_DESIGNATED_INITIALIZER;


@end

NS_ASSUME_NONNULL_END


/**
 便捷设置角标
 */
@interface UIView(SMTBadge)

/**
 视图添加一个角标
 
 @param badgeNumber 角标的值
 @param height 角标的高度
 @param offset 右上角的偏移值；
 @note 圆点上显示的数字；设置为nil则隐藏数字；仅显示圆点
 设置成@0则隐藏当前圆点(alpha为0)
 @see SMTBadge.h
 */
- (void)addBadge:(nullable NSNumber *)badgeNumber height:(CGFloat)height toTopRightCornerOffset:(CGPoint)offset;

/**
 视图添加一个角标；默认偏移值(3,3)
 
 @param badgeNumber 角标的值
 @param height 角标的高度
 @note badgeNumber 设置为nil则隐藏数字；
 设置成@0则隐藏当前控件
 @see SMTBadge.h
 */
- (void)addBadge:(NSNumber *)badgeNumber height:(CGFloat)height;

/**
 获取当前设置的角标视图
 
 @return SMTBadge实例；或者无
 */
- (nullable SMTBadge *)badge;

@end




