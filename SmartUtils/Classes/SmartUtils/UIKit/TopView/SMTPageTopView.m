//
//  SMTPageTopView.m
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/2/5.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "SMTPageTopView.h"
#import "SMTUsefulMacros.h"

@implementation SMTPageTopView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __setupSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self __setupSubviews];
}

- (void)__setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(0, 2.f);
    self.layer.shadowRadius = 2.f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.12f;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kScreenWidth, kNaviBarHeight);
}

@end
