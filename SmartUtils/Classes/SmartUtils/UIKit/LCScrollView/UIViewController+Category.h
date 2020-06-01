//
//  UIViewController+Category.h
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/12.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMTTableViewScrollBlock)(UIScrollView *scrollview);


@interface UIViewController (Category)


/** 滚动视图(控制器需要把当前的scrollView赋值过来) */
@property(nonatomic, strong) UIScrollView *lcScrollView;

@property (nonatomic,copy) SMTTableViewScrollBlock scrollBlk;

@end
