//
//  UIScrollView+SMTBounce.h
//  SMT-NT-iOS
//
//  Created by 李均(平安科技智慧生活团队IOS开发组) on 2018/7/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTBounceView.h"

@interface UIScrollView (SMTBounce)

@property (nonatomic ,strong) SMTBounceView *smt_bounceView;

@property (nonatomic ,strong) NSArray<SMTBounceView *> *smt_multipleBounceViews;

@end
