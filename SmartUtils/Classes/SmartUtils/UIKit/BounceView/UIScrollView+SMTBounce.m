//
//  UIScrollView+SMTBounce.m
//  SMT-NT-iOS
//
//  Created by 李均(平安科技智慧生活团队IOS开发组) on 2018/7/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "UIScrollView+SMTBounce.h"
#import <objc/runtime.h>
#import "SMTBounceView.h"

@implementation UIScrollView (SMTBounce)
static const char SMT_bounceView_key = 's';
static const char SMT_multipleBounceView_key = 'z';

- (void)setSmt_bounceView:(SMTBounceView *)smt_bounceView {
    if (smt_bounceView != self.smt_bounceView) {
        
        [self.smt_bounceView removeFromSuperview];
        [self insertSubview:smt_bounceView atIndex:0];

        objc_setAssociatedObject(self, &SMT_bounceView_key,
                                 smt_bounceView, OBJC_ASSOCIATION_ASSIGN);

    }

}

- (SMTBounceView *)smt_bounceView {
    return objc_getAssociatedObject(self, &SMT_bounceView_key);
}

- (void)setSmt_multipleBounceViews:(NSArray<SMTBounceView *> *)smt_multipleBounceViews {
    
    if (smt_multipleBounceViews != self.smt_multipleBounceViews) {
        
        [self.smt_bounceView removeFromSuperview];
        for (UIView *view in self.smt_multipleBounceViews) {
            [view removeFromSuperview];
        }
        for (UIView *view in smt_multipleBounceViews) {
            [self insertSubview:view atIndex:0];
        }
        
        objc_setAssociatedObject(self, &smt_multipleBounceViews,
                                 smt_multipleBounceViews, OBJC_ASSOCIATION_ASSIGN);
        
    }
}


- (NSArray<SMTBounceView *> *)smt_multipleBounceViews {
    return objc_getAssociatedObject(self, &SMT_multipleBounceView_key);
}


@end
