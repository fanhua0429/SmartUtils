//
//  UIButton+SmartUtils.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "UIButton+SmartUtils.h"
#define kActivityViewTag 175362

@implementation UIButton (SmartUtils)

- (void)startActivityViewLoading
{
    [self startActivityViewLoadingWithStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)startActivityViewLoadingWithStyle:(UIActivityIndicatorViewStyle)style
{
    self.userInteractionEnabled = NO;
    self.titleLabel.hidden = YES;
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
    if (activityView == nil) {
        activityView = [[UIActivityIndicatorView alloc] init];
        activityView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        activityView.tag = kActivityViewTag;
        [self addSubview:activityView];
    }
    activityView.activityIndicatorViewStyle = style;
    [activityView startAnimating];
}

- (void)stopActivityViewLoading
{
    self.userInteractionEnabled = YES;
    self.titleLabel.hidden = NO;
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
    if (activityView) {
        [activityView stopAnimating];
    }
}

@end
