//
//  DPRollBar.m
//  Utilities
//
//  Created by DancewithPeng on 2018/1/20.
//  Copyright © 2018年 dancewithpeng@gmail.com. All rights reserved.
//

#import "DPRollBar.h"


@interface DPRollBar ()

@property (nonatomic, strong) NSMutableArray *pDataSource;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, assign, readonly) CGRect visibleRect;
@property (nonatomic, strong) NSMutableDictionary *reusePool;
@property (nonatomic, strong) NSMutableDictionary *registerClasses;
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger visibleItemIndex;
@property (nonatomic, assign, readonly) CGRect preloadNextCellFrame;

@property (nonatomic, assign, readonly) CGFloat rollingDistance;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


/** 判断是否可以滚动的标识 */
@property (nonatomic, assign) BOOL canRoll;

/** 判断是否应该滚动的标识 */
@property (nonatomic, assign) BOOL shouldRoll;

@end

@implementation DPRollBar


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.clipsToBounds = YES;
    
    if (self.itemHeight <= 0) {
        self.itemHeight = self.bounds.size.height;
    }
    
    self.itemSpacing = 0;
    
    if (self.rollingItems == 0) {
        self.rollingItems = 1;
    }
    
    if (self.itemStayDuration == 0) {
        self.itemStayDuration = 3;
    }
    
    if (self.itemRollingAnimationDuration == 0) {
        self.itemRollingAnimationDuration = 0.25;
    }
    
    [self addGestureRecognizer:self.tapGesture];
    
    self.canRoll = YES;
    if (self.shouldRoll) {
        self.shouldRoll = NO;
        
        [self startRoll];
    }
}

#pragma mark - Interfaces

- (void)startRoll {
    
    if (self.canRoll == NO) {
        self.shouldRoll = YES;
        return;
    }
    
    if (self.timer) {
        [self stopRoll];
    }
    
    self.timer = [NSTimer timerWithTimeInterval:self.itemStayDuration+self.itemRollingAnimationDuration target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopRoll {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)registerClass:(Class)cls forCellWithReuseIdentifier:(NSString *)identifier {
    [self.registerClasses setObject:cls forKey:identifier];
}

- (__kindof DPRollBarCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    
    NSMutableSet *reuseSet = [self reuseSetWithIdentifier:identifier];

    DPRollBarCell *cell = [reuseSet anyObject];
    
    if (cell == nil) {
        Class cls = [self.registerClasses objectForKey:identifier];
        cell = [[cls alloc] initWithReuseIdentifier:identifier];
    } else {
        [reuseSet removeObject:cell];
    }
    
    return cell;
}

- (void)reloadData {
    
    if (self.isLoaded) {
        
        // 先停止定时器
        [self.timer invalidate];
        self.timer = nil;
        
        // 移除所有的子View
        for (UIView *v in self.visibleCells) {
            [v removeFromSuperview];
        }
        [self.visibleCells removeAllObjects];
        
        self.visibleItemIndex = 0;
        self.loaded = NO;
        [self loadCells];
        
        // 重新开始滚动
        [self startRoll];
    }
}

#pragma mark - Event Handlers

- (void)timerHandler:(NSTimer *)timer {
    
    if (timer.isValid) {
        [self rollVisibleCells];
    }
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:self];
    for (DPRollBarCell *cell in self.visibleCells) {
        if (CGRectContainsPoint(cell.frame, tapPoint)) {
            if ([self.dataSource respondsToSelector:@selector(rollBar:didSelectItemAtIndex:)]) {
                [self.dataSource rollBar:self didSelectItemAtIndex:cell.indexTag];
            }
            break;
        }
    }
}


#pragma mark - Layout

- (void)layoutSubviews {
    if (self.isLoaded == NO) {
        [self loadCells];
    }
}

#pragma mark - Helper Methods


/**
 滚动可见Cell
 1.移动位置
 2.移除不可见的Cell
 3.添加预加载的Cell
 */
- (void)rollVisibleCells {
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:weakSelf.itemRollingAnimationDuration animations:^{
        
        // 1.移动位置
        for (DPRollBarCell *cell in weakSelf.visibleCells) {
            CGRect distFrame = cell.frame;
            distFrame.origin.y -= weakSelf.rollingDistance;
            cell.frame = distFrame;
        }
        
    } completion:^(BOOL finished) {
        
        // 2.移除不可见的Cell
        NSMutableArray *willRemoveCells = [[NSMutableArray alloc] init];
        for (DPRollBarCell *cell in weakSelf.visibleCells) {
            if (CGRectIntersectsRect(weakSelf.visibleRect, cell.frame) == NO) {
                [willRemoveCells addObject:cell];
            }
        }
        
        for (DPRollBarCell *removedCell in willRemoveCells) {
            [weakSelf removeCellFromVisible:removedCell];
        }
        
        // 3.添加预加载的Cell
        [weakSelf preloadCells];
        
        // 4.记录可视区域最上面的那个cell的索引
        DPRollBarCell * cell = [self.visibleCells firstObject];
        self.visibleTopIndex = cell.indexTag;
    }];
}

- (void)removeCellFromVisible:(DPRollBarCell *)cell {
    
    [cell removeFromSuperview];
    [self.visibleCells removeObject:cell];
    
    NSMutableSet *reuseSet = [self.reusePool objectForKey:cell.reuseIdentifier];
    [reuseSet addObject:cell];
}

- (void)addCellToVisibleForRect:(CGRect)rect {
    
    DPRollBarCell *cell = [self.dataSource rollBar:self cellForItemWithIndex:self.visibleItemIndex];    
    cell.frame = rect;
    cell.indexTag = self.visibleItemIndex;
    
    if (cell) {
        [self addSubview:cell];
        [self.visibleCells addObject:cell];
    } else {
        // NSLog(@"rollBar:cellForItemWithIndex: 此方法不能返回nil");
    }
}

- (NSMutableSet *)reuseSetWithIdentifier:(NSString *)identifier {
    NSMutableSet *set = [self.reusePool objectForKey:identifier];
    if (set == nil) {
        set = [[NSMutableSet alloc] init];
        [self.reusePool setObject:set forKey:identifier];
    }
    
    return set;
}

- (void)loadCells {
    
    self.itemCount = [self.dataSource numberOfItemsInRollBar:self];
    
    [self preloadCells];
    
    self.loaded = YES;
}

- (void)preloadCells {
    
    if (self.itemCount <= 0) {
        return;
    }
    
    CGRect rect = self.preloadNextCellFrame;
    
    if (CGRectIntersectsRect(self.visibleRect, rect)) {
        
        [self addCellToVisibleForRect:rect];
        
        self.visibleItemIndex = (self.visibleItemIndex + 1) % self.itemCount;
        
        [self preloadCells];
    }
}


#pragma mark - Getter

- (NSMutableArray *)visibleCells {
    if (_visibleCells == nil) {
        _visibleCells = [[NSMutableArray alloc] init];
    }
    
    return _visibleCells;
}

- (CGRect)visibleRect {
    CGRect rect = self.bounds;
    rect.size.height += self.bounds.size.height;
    return rect;
}

- (NSMutableDictionary *)reusePool {
    if (_reusePool == nil) {
        _reusePool = [[NSMutableDictionary alloc] init];
    }
    
    return _reusePool;
}

- (NSMutableDictionary *)registerClasses {
    if (_registerClasses == nil) {
        _registerClasses = [[NSMutableDictionary alloc] init];
    }
    
    return _registerClasses;
}

- (CGRect)preloadNextCellFrame {
    DPRollBarCell *cell = [self.visibleCells lastObject];
    
    if (cell != nil) {
        
        CGRect rect = cell.frame;
        rect.origin.y += (self.itemHeight+self.itemSpacing);
        rect.origin.x = 0;
        rect.size = CGSizeMake(self.bounds.size.width, self.itemHeight);
        return rect;
    } else {
        return CGRectMake(0, 0, self.bounds.size.width, self.itemHeight);
    }
}

- (CGFloat)rollingDistance {
    return (self.itemHeight + self.itemSpacing) * self.rollingItems;
}

- (UITapGestureRecognizer *)tapGesture {
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    }
    
    return _tapGesture;
}


#pragma mark - Destroy

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
