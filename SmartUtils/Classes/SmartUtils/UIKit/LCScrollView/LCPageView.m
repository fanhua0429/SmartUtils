//
//  LCPageView.m
//  LCPageView
//
//  Created by 复新会智 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//

//屏幕尺寸
#define kScreenBounds [UIScreen mainScreen].bounds
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width


#import "LCPageView.h"
//#import "UIScrollView+Category.h"
#import "UIViewController+Category.h"
//#import "SMTLawHallTableViewController.h"

static NSString *const kPageViewCollectionViewCellID = @"kPageViewCollectionViewCellID";

@interface LCPageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate,SGPageTitleViewDelegate>

/** 子控制器数组 */
@property(nonatomic, strong)NSArray <UIViewController *>*childControllers;
/** 父控制器 */
@property(nonatomic, weak)UIViewController *parentController;
/** 样式 */
@property(nonatomic, strong)SGPageTitleViewConfigure *style;

/** 最底部滚动视图 */
@property(nonatomic, strong)MainScrollView *mainScrollView;
/** <#注释#> */
@property(nonatomic, strong)UIScrollView *outsideScrollView;

/** 主标题视图 */
@property(nonatomic, strong)SGPageTitleView *titleView;
/** 主标题底部视图(存放主标题视图) */
@property(nonatomic, strong)UIView *titleBottomView;
/** 标题滚动视图 */
@property(nonatomic, strong)UIScrollView *titleScrollView;

/** 标题内容的数组 */
@property(nonatomic, strong)NSArray <UILabel *>*titleLableArray;

/** 内容视图 */
@property(nonatomic, strong) UICollectionView *contentCollectionView;
/** 内容视图开始滚动位置 */
@property(nonatomic, assign) CGFloat startOffsetX;

/** 头部视图 */
@property(nonatomic, strong) LCHeadView *headView;
/** 头部视图的高度 */
@property(nonatomic, assign)CGFloat headViewHeight;
/** 标题视图的高度 */
@property(nonatomic, assign)CGFloat titleHeight;
/** 当前的index */
@property(nonatomic, assign)NSInteger currentIndex;
/** 将要显示的collectionviewcell */
@property(nonatomic, assign)NSInteger targetIndex;
/** 将要显示的collectionviewcell */
@property(nonatomic, assign)NSInteger originalIndex;
@property(nonatomic, assign)BOOL scrollToLeft;
@end

@implementation LCPageView
{
    /** 内容滚动的代理 */
    NSPointerArray* _delegates;
}

- (void)dealloc
{
    for (UIViewController *vc in self.childControllers) {
        vc.lcScrollView.delegate = nil;
    }
    
    [self removeAllDelegates];
    NSLog(@"LCPageView - dealloc");
}
#pragma mark - 初始化操作
- (instancetype)initWithFrame:(CGRect)frame
                     headView:(LCHeadView *)headView
             childControllers:(NSArray <UIViewController *>*)childControllers
             parentController:(UIViewController *)parentController
              customTitleView:(SGPageTitleView *)customTitleView
                pageViewStyle:(SGPageTitleViewConfigure *)pageViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegates = [NSPointerArray weakObjectsPointerArray];
        self.headView = headView;
        self.childControllers = childControllers;
        self.parentController = parentController;
        self.style = pageViewStyle;
        [self initHeadView];
        [self initTitleViewWithCustomTitleView:customTitleView];
        [self initContentView];
        
    }
    return self;
}
- (void)initHeadView
{
    if (!self.headView) {
        // 没有头部视图
        return;
    }
    self.headViewHeight = self.headView.frame.size.height;
    [self.mainScrollView addSubview:self.headView];
    self.mainScrollView.contentSize = CGSizeMake(0, self.bounds.size.height + self.headView.bounds.size.height);
}
/// 初始化标题
- (void)initTitleViewWithCustomTitleView:(SGPageTitleView *)customTitleView
{
    if (self.childControllers.count <= 0) {
        /// 没有子控制器, 抛出异常
        return;
    }
    if (customTitleView) {
        self.titleView = customTitleView;
        [self.titleBottomView addSubview:customTitleView];
    }else {
        [self.titleBottomView addSubview:self.titleView];
    }
}

-(SGPageTitleView*)titleView
{
    if (_titleView==nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (UIViewController *vc in self.childControllers) {
            [array addObject:vc.title ? vc.title : @" "];
        }
        _titleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 45) delegate:self titleNames:array configure:nil];
    }
    
    return _titleView;
}

/// 初始化内容
- (void)initContentView
{
    if (self.parentController == nil) {
        /// 没有父控制器, 抛出异常
        return;
    }
    if (self.childControllers.count <= 0) {
        /// 没有子控制器
        return;
    }
    __weak typeof(self) weakSelf = self;
    for (UIViewController *vc in self.childControllers) {
        [self.parentController addChildViewController:vc];
        /// 确保vc的viewDidload方法执行以后, lcScrollView 才会有值
        if (vc.view) {}
        vc.scrollBlk = ^(UIScrollView *scrollView) {
            weakSelf.outsideScrollView = scrollView;
            if (weakSelf.mainScrollView.contentOffset.y == 0) {
                if (weakSelf.headViewHeight == 0) {
                    scrollView.showsVerticalScrollIndicator = YES;
                }else {
                    scrollView.showsVerticalScrollIndicator = NO;
                }
            }else if (weakSelf.mainScrollView.contentOffset.y < weakSelf.headViewHeight) {
                scrollView.contentOffset = CGPointZero;
                scrollView.showsVerticalScrollIndicator = NO;
            }else {
                scrollView.showsVerticalScrollIndicator = YES;
            }
        };

    }
    
    [self.mainScrollView insertSubview:self.contentCollectionView belowSubview:self.titleBottomView];
}

- (void)scrollTitleViewTop
{
    [self.mainScrollView setContentOffset:CGPointMake(0, self.headView.bounds.size.height)];
}

#pragma mark - 事件逻辑
- (void)scrollCollectionviewWithIndex:(NSInteger)index
{
    if (self.currentIndex!=index) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        NSLog(@"selectIndex - %@",@(index));
        self.titleView.resetSelectedIndex = index;
        _currentIndex = index;
    }
    
}

#pragma mark - titleView  调用的方法
- (void)scrollCollectionviewWithIndexNum:(NSNumber *)index
{
    [self scrollCollectionviewWithIndex:[index integerValue]];
}

#pragma mark - collectionview delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageViewCollectionViewCellID forIndexPath:indexPath];
    for (UIView *subV in cell.contentView.subviews) {
        [subV removeFromSuperview];
    }
    UIViewController *vc = self.childControllers[indexPath.item];
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.childControllers) {
        [vc.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(self.contentCollectionView.contentOffset.x / self.contentCollectionView.bounds.size.width);
    [self scrollCollectionviewWithIndex:index];
    self.mainScrollView.scrollEnabled = YES;
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewDidEndDecelerating:) withObject:(UICollectionView *)scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(self.contentCollectionView.contentOffset.x / self.contentCollectionView.bounds.size.width);
    [self scrollCollectionviewWithIndex:index];
    
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.mainScrollView.scrollEnabled = YES;
        [self performDelegateWithSel:@selector(lc_scrollViewDidEndScrollingAnimation:) withObject:(UICollectionView *)scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.mainScrollView.scrollEnabled = YES;
        SuppressPerformSelectorLeakWarning([self performDelegateWithSel:@selector(lc_scrollViewDidEndDragging:) withObject1:(UICollectionView *)scrollView withobject2:@(decelerate)]);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.mainScrollView.scrollEnabled = NO;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        [self performDelegateWithSel:@selector(lc_scrollViewWillBeginDragging:) withObject:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.outsideScrollView.contentOffset.y > 0 ||
        scrollView.contentOffset.y > self.headViewHeight) {
        //mainScrollView停止滚动
        self.mainScrollView.contentOffset = CGPointMake(0, self.headViewHeight);
    }
    
    if (scrollView.contentOffset.y != 0 && scrollView.contentOffset.y < self.headViewHeight-1) {
        for (UIViewController *vc in self.childControllers) {
            //lcScrollView停止滚动
            vc.lcScrollView.contentOffset = CGPointZero;
        }
    }
    
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewDidHorizontalScroll:) withObject:scrollView];
        [self scroll:scrollView];
    }else {
        [self performDelegateWithSel:@selector(lc_scrollViewDidVerticalScroll:) withObject:scrollView];
    }
    
}

-(void)scroll:(UIScrollView *)scrollView
{
            CGFloat progress = 0;
            NSInteger originalIndex = 0;
            NSInteger targetIndex = 0;
            // 2、判断是左滑还是右滑
            CGFloat currentOffsetX = scrollView.contentOffset.x;
            CGFloat scrollViewW = scrollView.bounds.size.width;
            if (currentOffsetX > _startOffsetX) { // 左滑
                self.scrollToLeft = YES;
                // 1、计算 originalIndex
                originalIndex = currentOffsetX / scrollViewW;
                // 2、计算 targetIndex
                targetIndex = originalIndex + 1;
                // 3、计算 progress
                NSInteger targetX = targetIndex*scrollView.bounds.size.width;
                CGFloat totalOffsetX = targetX-originalIndex*scrollView.bounds.size.width;
                NSInteger moveX = scrollView.contentOffset.x-originalIndex*scrollView.bounds.size.width;
                progress =  moveX/totalOffsetX;
                if (targetIndex >= self.childControllers.count) {
                    progress = 1;
                    targetIndex = self.childControllers.count - 1;
                }
                // 4、如果完全划过去
                if (currentOffsetX - _startOffsetX == scrollViewW) {
                    progress = 1;
                    targetIndex = originalIndex;
                }
            } else { // 右滑
                self.scrollToLeft = NO;
                // 1、计算 targetIndex
                targetIndex = currentOffsetX / scrollViewW;
                // 2、计算 originalIndex
                originalIndex = targetIndex + 1;
                // 3、计算 progress
                NSInteger targetX = targetIndex*scrollView.bounds.size.width;
                CGFloat totalOffsetX = targetX-originalIndex*scrollView.bounds.size.width;
                NSInteger moveX = scrollView.contentOffset.x-originalIndex*scrollView.bounds.size.width;
                progress =  moveX/totalOffsetX;
                if (originalIndex >= self.childControllers.count) {
                    originalIndex = self.childControllers.count - 1;
                }
            }
    
            self.originalIndex = originalIndex;
            self.targetIndex = targetIndex;
    //        NSLog(@"%@>>%@ ,progress - %@",@(originalIndex),@(self.targetIndex),@(progress));
            [self.titleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex!=self.currentIndex) {
        NSLog(@"pageTitleView %@",@(selectedIndex));
        self.currentIndex = selectedIndex;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}

#pragma mark - 懒加载
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[MainScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.scrollsToTop = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        
//#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//#endif
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
- (UIView *)titleBottomView
{
    if (!_titleBottomView) {
        _titleBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bounds.size.height, self.bounds.size.width, self.titleView.bounds.size.height)];
        _titleBottomView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:_titleBottomView];
    }
    return _titleBottomView;
}
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headView.bounds.size.height, self.bounds.size.width, self.titleView.bounds.size.height)];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
    }
    return _titleScrollView;
}
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height - self.titleView.bounds.size.height);
        layout.itemSize = size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.titleBottomView.frame), size.width, size.height);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPageViewCollectionViewCellID];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11, *)) {
            _contentCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _contentCollectionView;
}

#pragma mark - LCMultiDelegate
- (void)addDelegate:(id<LCPageContentViewProtocol>)delegate {
    [_delegates addPointer:(__bridge void*)delegate];
}
- (void)removeDelegate:(id<LCPageContentViewProtocol>)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound)
        [_delegates removePointerAtIndex:index];
    [_delegates compact];
}
- (void)removeAllDelegates {
    for (NSUInteger i = _delegates.count; i > 0; i -= 1)
        [_delegates removePointerAtIndex:i - 1];
}
- (void)performDelegateWithSel:(SEL)sel withObject:(id)object
{
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        id delegate = [_delegates pointerAtIndex:i];
        if ([delegate respondsToSelector:sel]) {
            SuppressPerformSelectorLeakWarning1([delegate performSelector:sel withObject:object]);
        }
    }
}
- (void)performDelegateWithSel:(SEL)sel withObject1:(id)object1 withobject2:(id)onject2
{
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        id delegate = [_delegates pointerAtIndex:i];
        if ([delegate respondsToSelector:sel]) {
            SuppressPerformSelectorLeakWarning1([delegate performSelector:sel withObject:object1 withObject:onject2]);
        }
    }
}
- (NSUInteger)indexOfDelegate:(id)delegate {
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}
- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector])
        return YES;
    for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:selector] && [delegate respondsToSelector:@selector(lc_scrollViewDidVerticalScroll)])
            //只响应LCPageView回调LCHeadView的函数
            return YES;
    }
    return NO;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;
    
    [_delegates compact];
    if (_delegates.count == 0) {
        return [self methodSignatureForSelector:@selector(description)];
    }
    for (id delegate in _delegates) {//存储了各个对象的代理
        if (!delegate)
            continue;
        signature = [delegate methodSignatureForSelector:selector];
        if (signature)
            break;
    }
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = [invocation selector];
    BOOL responded = NO;
    for (id delegate in _delegates) {
        if ((delegate && [delegate respondsToSelector:selector])) {
            [invocation invokeWithTarget:delegate];
            responded = YES;
        }
    }
    if (!responded)
        [self doesNotRecognizeSelector:selector];
}

@end
