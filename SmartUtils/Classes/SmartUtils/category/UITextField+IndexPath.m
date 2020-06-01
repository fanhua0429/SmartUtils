//
//  UITextField+IndexPath.m
//  S4S
//
//  Created by 彭健克 on 17/4/23.
//  Copyright © 2017年 彭健克. All rights reserved.
//

#import "UITextField+IndexPath.h"
#import <objc/runtime.h>


@implementation UITextField (IndexPath)
static char indexPathKey;
- (NSIndexPath *)indexPath{
    return objc_getAssociatedObject(self, &indexPathKey);
}
//设置
- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
