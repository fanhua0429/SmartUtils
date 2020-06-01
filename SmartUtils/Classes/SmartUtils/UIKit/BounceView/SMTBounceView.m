//
//  SMTBounceView.m
//  SMT-NT-iOS
//
//  Created by 李均(平安科技智慧生活团队IOS开发组) on 2018/7/7.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "SMTBounceView.h"

NSString *const SMTBounceKeyPathContentOffset = @"contentOffset";
NSString *const SMTBounceKeyPathContentInset = @"contentInset";
NSString *const SMTBounceKeyPathContentSize = @"contentSize";
NSString *const SMTBounceKeyPathPanState = @"state";

@interface SMTBounceView ()

@property (nonatomic ,weak) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;


@end


@implementation SMTBounceView {
    SMTBounceViewType _type;
    CGFloat _normalOffset;
    CGFloat _appearanceDistance;
    //是否已经触发了
    BOOL _isTriggered;
}

- (void)dealloc
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _type = SMTBounceViewTypeRight;
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        self.bgColor = [UIColor colorWithWhite:0.7 alpha:1];
        _triggerDistance = 60;
        self.normalDistance = 20;
        self.triggerAfterFingerUp = YES;
    }
    return self;
}

- (instancetype)initWithType:(SMTBounceViewType)type {
    self = [self init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { 
        
        _scrollView = (UIScrollView *)newSuperview;
        
        // 设置永远支持垂直弹簧效果
        if (_type == SMTBounceViewTypeTop || _type == SMTBounceViewTypeBottom) {
            _scrollView.alwaysBounceVertical = YES;

        }
        else if (_type == SMTBounceViewTypeLeft || _type == SMTBounceViewTypeRight) {
            _scrollView.alwaysBounceHorizontal = YES;
        }
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat shapeBegin = 0;
    CGFloat ellipsePart = self.normalDistance-self.rectShowPartDistance;
    CGFloat rectPart = self.rectShowPartDistance;
    CGFloat appearance = _appearanceDistance;
    CGFloat begin = 0;
    if (self.maxAppearance>0 && appearance>self.maxAppearance) {
        appearance = self.maxAppearance;
        shapeBegin = _appearanceDistance-self.maxAppearance;
    }
    if (appearance>self.normalDistance) {
        begin = appearance-self.normalDistance;
        if (begin>self.adjustDistance) {
            begin = self.adjustDistance;
        }
    }
    
    if (appearance>self.normalDistance){
        ellipsePart = appearance - self.rectShowPartDistance;
    }
    
    if (_type == SMTBounceViewTypeTop) {
        if (rectPart>0) {
            CGPathAddRect(path, NULL, CGRectMake(begin, self.frame.size.height-rectPart-ellipsePart-shapeBegin, self.frame.size.width-2*begin, rectPart));
            
        }
        CGPathAddEllipseInRect(path, NULL, CGRectMake(begin, self.frame.size.height-ellipsePart*2-shapeBegin, self.frame.size.width-2*begin, ellipsePart*2));
    }
    else if (_type == SMTBounceViewTypeLeft) {
        if (rectPart>0) {
            CGPathAddRect(path, NULL, CGRectMake(self.frame.size.width-rectPart-ellipsePart-shapeBegin, begin, rectPart, self.frame.size.height-2*begin));
            
        }
        CGPathAddEllipseInRect(path, NULL, CGRectMake(self.frame.size.width-ellipsePart*2-shapeBegin, begin, ellipsePart*2, self.frame.size.height-2*begin));
        
    }
    else if (_type == SMTBounceViewTypeRight) {

        if (rectPart>0) {
            CGPathAddRect(path, NULL, CGRectMake(ellipsePart+shapeBegin, begin, rectPart, self.frame.size.height-2*begin));

        }
        CGPathAddEllipseInRect(path, NULL, CGRectMake(shapeBegin, begin, ellipsePart*2, self.frame.size.height-2*begin));
        
    }
    else if (_type == SMTBounceViewTypeBottom) {
        if (rectPart>0) {
            CGPathAddRect(path, NULL, CGRectMake(begin, ellipsePart+shapeBegin, self.frame.size.width-2*begin, rectPart));
            
        }
        CGPathAddEllipseInRect(path, NULL, CGRectMake(begin, shapeBegin, self.frame.size.width-2*begin, ellipsePart*2));
        
    }
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, self.bgColor.CGColor);
    CGContextFillPath(ctx);
}



- (void)adjustNormalPosition {
    
    if (_type == SMTBounceViewTypeTop) {
        
        CGFloat originY = -self.scrollView.contentInset.top - 1000 - self.gap;
        _normalOffset = -self.scrollView.contentInset.top - self.gap;
        self.frame = CGRectMake(self.inset, originY, self.scrollView.frame.size.width-2*self.inset, 1000);

    }
    else if (_type == SMTBounceViewTypeLeft) {
        
        CGFloat originX = -self.scrollView.contentInset.top - 1000 -self.gap;
        _normalOffset = -self.scrollView.contentInset.left - self.gap;
        self.frame = CGRectMake(originX, self.inset, 1000, self.scrollView.frame.size.height-2*self.inset);

    }
    else if (_type == SMTBounceViewTypeRight) {
        
        CGFloat contentWidth = self.scrollView.contentSize.width;
        CGFloat originX = self.scrollView.contentInset.right + contentWidth + self.gap;
        if (contentWidth+self.scrollView.contentInset.right+self.scrollView.contentInset.left<self.scrollView.frame.size.width) {
            originX = self.scrollView.frame.size.width + self.gap - self.scrollView.contentInset.left;
        }
        
        _normalOffset = originX;
        self.frame = CGRectMake(originX, self.inset, 1000, self.scrollView.frame.size.height-2*self.inset);
        
    }
    else if (_type == SMTBounceViewTypeBottom) {
        
        CGFloat contentHeight = self.scrollView.contentSize.height;
        CGFloat originY = self.scrollView.contentInset.bottom + contentHeight + self.gap;
        if (contentHeight+self.scrollView.contentInset.bottom+self.scrollView.contentInset.top<self.scrollView.frame.size.height) {
            originY = self.scrollView.frame.size.height + self.gap - self.scrollView.contentInset.top;
        }
        _normalOffset = originY;
        self.frame = CGRectMake(self.inset, originY, self.scrollView.frame.size.width-2*self.inset, 1000);
    }
    [self scrollViewContentOffsetDidChange];
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SMTBounceKeyPathContentSize options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:SMTBounceKeyPathContentOffset options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:SMTBounceKeyPathPanState options:options context:nil];

}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:SMTBounceKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:SMTBounceKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:SMTBounceKeyPathPanState];
    self.pan = nil;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:SMTBounceKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:SMTBounceKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange];
    }
    else if ([keyPath isEqualToString:SMTBounceKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange{
    CGFloat offset = 0;
    CGFloat oldApperanceDistance = _appearanceDistance;
    if (_type == SMTBounceViewTypeTop) {
        offset = self.scrollView.contentOffset.y;
    }
    else if (_type == SMTBounceViewTypeLeft) {
        offset = self.scrollView.contentOffset.x;
    }
    else if (_type == SMTBounceViewTypeRight) {
        offset = self.scrollView.contentOffset.x+self.scrollView.frame.size.width;
    }
    else if (_type == SMTBounceViewTypeBottom) {
        offset = self.scrollView.contentOffset.y+self.scrollView.frame.size.height;
    }
    
    if (_type == SMTBounceViewTypeTop || _type == SMTBounceViewTypeLeft) {
        if (offset < _normalOffset) {
            _appearanceDistance = offset - _normalOffset;
            _appearanceDistance = fabs(_appearanceDistance);
        }
        else {
            _appearanceDistance = 0;
        }
    }
    else {
        if (offset > _normalOffset) {
            _appearanceDistance = offset - _normalOffset;
        }
        else {
            _appearanceDistance = 0;
        }
    }
    
    if (self.triggerDistance>0) {
        if (_appearanceDistance> self.triggerDistance) {
            [self setTriggerState:SMTBounceViewTriggerdState];
        }
        else {
            [self setTriggerState:SMTBounceViewNormalState];
        }
    }
    
    if (_appearanceDistance!=oldApperanceDistance) {
        if (self.appearanceDistanceChange) {
            self.appearanceDistanceChange(_appearanceDistance);
        }
    }
    
    [self setNeedsDisplay];
}

- (void)setTriggerState:(SMTBounceViewState)state {
    
    SMTBounceViewState oldState = self.state;
    self.state = state;
    if (state == SMTBounceViewTriggerdState) {
        if (!_isTriggered) {
            _isTriggered = YES;
            if (!self.triggerAfterFingerUp) {
                if (self.trigeredAction) {
                    self.trigeredAction();
                }
            }
        }
    }
    else {
        _isTriggered = NO;
    }
    if (oldState != state) {
        if (self.stateChange) {
            self.stateChange(state);
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    
    [self adjustNormalPosition];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    switch (self.pan.state) {
        case UIGestureRecognizerStateBegan:
            if (_appearanceDistance<_triggerDistance) {
                [self setTriggerState:SMTBounceViewNormalState];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (_isTriggered) {
                if (self.trigeredAction) {
                    self.trigeredAction();
                }
            }
            break;
        default:
            break;
    }
}



@end
