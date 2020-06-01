//
//  DPRollBar.h
//  Utilities
//
//  Created by DancewithPeng on 2018/1/20.
//  Copyright © 2018年 dancewithpeng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPRollBarCell.h"

@class DPRollBar;
@protocol DPRollBarDataSource <NSObject>

- (NSInteger)numberOfItemsInRollBar:(DPRollBar *)rollBar;
- (DPRollBarCell *)rollBar:(DPRollBar *)rollBar cellForItemWithIndex:(NSInteger)index;

- (void)rollBar:(DPRollBar *)rollBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface DPRollBar : UIView

@property (nonatomic, weak) id<DPRollBarDataSource> dataSource;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) NSInteger rollingItems;
@property (nonatomic, assign) NSTimeInterval itemStayDuration;
@property (nonatomic, assign) NSTimeInterval itemRollingAnimationDuration;
@property (nonatomic, assign) NSInteger visibleTopIndex; ///< 可视区域内最上面的那个cell的索引

- (void)startRoll;
- (void)stopRoll;

- (void)registerClass:(Class)cls forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof DPRollBarCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;

@end
