//
//  SMTBounceView.h
//  SMT-NT-iOS
//
//  Created by 李均(平安科技智慧生活团队IOS开发组) on 2018/7/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SMTBounceViewType) {
    SMTBounceViewTypeTop,
    SMTBounceViewTypeLeft,
    SMTBounceViewTypeRight,
    SMTBounceViewTypeBottom
};

typedef NS_ENUM(NSInteger, SMTBounceViewState) {
    SMTBounceViewNormalState,       //未触发状态
    SMTBounceViewTriggerdState,     //触发状态
};

@interface SMTBounceView : UIView


- (instancetype)initWithType:(SMTBounceViewType)type;


@property (nonatomic ,assign) CGFloat gap;

// action触发距离
@property (nonatomic ,assign) CGFloat triggerDistance;

// 方块的正常大小
@property (nonatomic ,assign) CGFloat normalDistance;
// 左右/上下间距
@property (nonatomic ,assign) CGFloat inset;

// 背景颜色
@property (nonatomic ,strong) UIColor *bgColor;

// 矩形区域下滑距离
@property (nonatomic ,assign) CGFloat adjustDistance;

// 矩形区域可以露出来多少
@property (nonatomic ,assign) CGFloat rectShowPartDistance;

//是否手指松开才触发事件
@property (nonatomic ,assign) BOOL triggerAfterFingerUp;

@property (nonatomic ,assign) CGFloat maxAppearance;


@property (nonatomic ,assign) SMTBounceViewState state;


// 达到触发距离后的事件
@property (nonatomic ,copy)void (^trigeredAction)(void);
@property (nonatomic ,copy)void (^stateChange)(SMTBounceViewState state);
@property (nonatomic ,copy)void (^appearanceDistanceChange)(CGFloat distance);


@end
