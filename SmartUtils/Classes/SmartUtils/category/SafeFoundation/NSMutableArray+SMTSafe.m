//
//  NSMutableArray+SMTSafe.m
//  FreeCitizen
//
//  Created by 林杜波 on 2018/4/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "NSMutableArray+SMTSafe.h"
#import "NSObject+swizzle.h"

@implementation NSMutableArray (SMTSafe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self smt_exchangeInstanceMethod:@selector(insertObject:atIndex:) ofClass:@"__NSArrayM" withMethod:@selector(smt_insertObject:atIndex:) ofOtherClass:@"NSMutableArray"];
        [self smt_exchangeInstanceMethod:@selector(insertObjects:atIndexes:) ofClass:@"__NSArrayM" withMethod:@selector(smt_insertObjects:atIndexes:) ofOtherClass:@"NSMutableArray"];
        [self smt_exchangeInstanceMethod:@selector(removeObjectsInRange:) ofClass:@"__NSArrayM" withMethod:@selector(smt_removeObjectsInRange:) ofOtherClass:@"NSMutableArray"];
        //iOS10 以下不要调用此方法，键盘弹出情况下前后台切换会出现奔溃
        if (@available(iOS 10.0, *)) {
            [self smt_exchangeInstanceMethod:@selector(objectAtIndex:) ofClass:@"__NSArrayM" withMethod:@selector(smt_objectAtIndex:) ofOtherClass:@"NSMutableArray"];
        }
        [self smt_exchangeInstanceMethod:@selector(replaceObjectAtIndex:withObject:) ofClass:@"__NSArrayM" withMethod:@selector(smt_replaceObjectAtIndex:withObject:) ofOtherClass:@"NSMutableArray"];
    });
}

- (void)smt_insertObject:(id)anObject atIndex:(NSUInteger)index {
    // include addObject:
    if (!anObject) {
        return;
    }
    if (index > self.count) {
        return;
    }
    [self smt_insertObject:anObject atIndex:index];
}

- (void)smt_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    /// indexset为有序索引集合
    if (objects.count != indexes.count) {
        return;
    }
    
    NSMutableIndexSet *indexSet = indexes.mutableCopy;
    NSMutableArray *objArr = objects.mutableCopy;
    __block NSUInteger objIdx = 0;
    __block NSUInteger objCount = self.count;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > objCount) {
            [indexSet removeIndex:idx];
            [objArr removeObjectAtIndex:objIdx];
        } else {
            objIdx++;
            objCount++;
        }
    }];
    [self smt_insertObjects:objArr atIndexes:indexSet];
}

- (void)smt_removeObjectsInRange:(NSRange)range {
    // include removeObjectAtIndex:
    if (range.location >= self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        range.length = self.count - range.location;
    }
    
    [self smt_removeObjectsInRange:range];
}

- (id)smt_objectAtIndex:(NSUInteger)index{
    // 越界
    if (index >= [self count]) {
        return nil;
    }
    
    // 无法处理null，系统创建的可变数组含有null数据
    //    id obj = [self smt_objectAtIndex:index];
    //    if ([obj isNull]) {
    //        return nil;
    //    }
    return [self smt_objectAtIndex:index];
}

- (void)smt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject) {
        return;
    }
    if (index >= self.count) {
        return;
    }
    [self smt_replaceObjectAtIndex:index withObject:anObject];
}

@end
