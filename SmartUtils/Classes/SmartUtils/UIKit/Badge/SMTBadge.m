//
//  SMTBadge.m
//  BadgeDemo
//
//  Created by 廖超龙 on 2018/5/18.
//  Copyright © 2018年 liaochaolong. All rights reserved.
//

#import "SMTBadge.h"
#import "UIColor+SmartUtils.h"
#import <objc/runtime.h>

@interface SMTBadge()

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, weak) UILabel *label;

@end

@implementation SMTBadge

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithHeight:8];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithHeight:8];
}

- (instancetype)initWithHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, 0, height, height)];
    if (self) {
        if (height < 3) {
            height = 3;
        }
        _height = height;
        _fonSize = height-2;
        _maximumNumber = 99;
        _number = @0;
        UILabel *label = [[UILabel alloc] init];
        _label = label;
        label.font = [UIFont systemFontOfSize:_fonSize];
        label.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = height/2;
        self.backgroundColor = [UIColor colorWithHexString:@"#FF7857"];
        self.clipsToBounds = true;
        [self setLabelColor:[UIColor whiteColor]];
        [self addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:0],
                               
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:2],
                               
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:0],
                               
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-2],
                               
                               ]];
        [self updateLabel];
    }
    return self;
}

#pragma mark ----------------       布局   ------------------------------

- (CGSize)intrinsicContentSize {
    if (self.superview) {
        CGRect boundingRect = [_label.text boundingRectWithSize:CGSizeMake(self.superview.frame.size.width/2, _height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_fonSize]} context:NULL];
        CGFloat width = boundingRect.size.width + _height/4;
        if (width < _height) {
            width = _height;
        }
        return CGSizeMake(width, _height);
    } else {
        return CGSizeMake(_height, _height);
    }
}

- (void)updateLabel {
    self.alpha = [_number isEqualToNumber:@0]? 0:1;
    if (_number.integerValue > self.maximumNumber) {
        self.label.text = [NSString stringWithFormat:@"%d+",(int)self.maximumNumber];
    } else {
        self.label.text = [_number description];
    }
    if ([SMTBadge appearance].backgroundColor) {
        self.backgroundColor = [SMTBadge appearance].backgroundColor;
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#FF7857"];
    }
    [self layoutIfNeeded];
}


#pragma mark ----------------     getters setters ----------------

- (void)setNumber:(NSNumber *)number {
    if (![_number isEqual:number]) {
        _number = number;
        [self updateLabel];
        [self.superview bringSubviewToFront:self];
    }
}

- (void)setFonSize:(CGFloat)fonSize {
    
    if (_fonSize != fonSize) {
        _fonSize = fonSize;
        _label.font = [UIFont systemFontOfSize:fonSize];
        if (self.superview) {
            [self updateLabel];
        }
    }

}

- (void)setMaximumNumber:(NSInteger)maximumNumber {
    if (maximumNumber != _maximumNumber) {
        _maximumNumber = maximumNumber;
        if (self.superview) {
            [self updateLabel];
        }
    }
}

- (void)setLabelColor:(UIColor *)labelColor {
    if (![_labelColor isEqual:labelColor]) {
        _labelColor = labelColor;
        _label.textColor = labelColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

- (UIColor *)backgroundColor {
    return [super backgroundColor];
}

@end

@implementation UIView(SMTBadge)

- (void)addBadge:(nullable NSNumber *)badgeNumber height:(CGFloat)height toTopRightCornerOffset:(CGPoint)offset {
    SMTBadge *badge = nil;
    if (self.badge) {
        badge = self.badge;
    } else {
        badge = [[SMTBadge alloc] initWithHeight:height];
        self.badge = badge;
        [self addSubview:badge];
        badge.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
                               //本视图的约束
                               [NSLayoutConstraint constraintWithItem:badge
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:offset.y],
                               
                               [NSLayoutConstraint constraintWithItem:badge
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-offset.x],
                               ]];
    }
    
    badge.number = badgeNumber;
}

- (void)addBadge:(NSNumber *)badgeNumber height:(CGFloat)height {
    [self addBadge:badgeNumber height:height toTopRightCornerOffset:CGPointMake(3, 3)];
}

- (SMTBadge *)badge {
    return (SMTBadge *)objc_getAssociatedObject(self, "SMTBadgeKey");
}

- (void)setBadge:(SMTBadge *)badge {
    objc_setAssociatedObject(self, "SMTBadgeKey", badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
