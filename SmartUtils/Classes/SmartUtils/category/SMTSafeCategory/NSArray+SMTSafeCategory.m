//
//  NSArray+SMTSafeCategory.m
//  SMT-NT-iOS
//
//  Created by 莫冰(平安科技智慧政务团队) on 2018/5/3.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSArray+SMTSafeCategory.h"

@implementation NSArray (SMTSafeCategory)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
