//
//  UIButton+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SmartUtils)

- (void)startActivityViewLoadingWithStyle:(UIActivityIndicatorViewStyle)style;
- (void)startActivityViewLoading;
- (void)stopActivityViewLoading;

@end
