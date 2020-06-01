//
//  UITableView+SMTSafeExtension.h
//  FreeCitizen
//
//  Created by 安俊(平安科技智慧生活团队) on 2018/4/16.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SmartUtils)

- (void)reloadRowsAtIndexPathsSafe:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

@end
