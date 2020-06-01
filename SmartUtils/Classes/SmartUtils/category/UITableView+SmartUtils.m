//
//  UITableView+SMTSafeExtension.m
//  FreeCitizen
//
//  Created by 安俊(平安科技智慧生活团队) on 2018/4/16.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "UITableView+SmartUtils.h"

@implementation UITableView (SmartUtils)

- (void)reloadRowsAtIndexPathsSafe:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:indexPaths.count];
    NSInteger totalSelections=[self numberOfSections];
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger totalRows=[self numberOfRowsInSection:indexPath.section];
        if(indexPath.section<0||indexPath.section>=totalSelections||indexPath.row>=totalRows){
        }else{
            [tempArray addObject:indexPath];
        }
    }
    [self reloadRowsAtIndexPaths:tempArray withRowAnimation:animation];
}

+ (void)initialize{
    if (@available(iOS 11.0, *)){
        [[self appearance] setEstimatedRowHeight:0];
        [[self appearance] setEstimatedSectionHeaderHeight:0];
        [[self appearance] setEstimatedSectionFooterHeight:0];
    }
}

@end
