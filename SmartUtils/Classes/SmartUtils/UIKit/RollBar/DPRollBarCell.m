//
//  DPRollBarCell.m
//  Utilities
//
//  Created by DancewithPeng on 2018/1/20.
//  Copyright © 2018年 dancewithpeng@gmail.com. All rights reserved.
//

#import "DPRollBarCell.h"

@implementation DPRollBarCell

- (instancetype)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [self initWithFrame:CGRectZero]) {
        self.reuseIdentifier = identifier;    
    }
    
    return self;
}

@end
