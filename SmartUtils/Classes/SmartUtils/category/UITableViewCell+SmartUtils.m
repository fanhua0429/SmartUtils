//
//  UITableViewCell+separator.m
//  SMTCommon
//
//  Created by dusheng on 2017/12/26.
//  Copyright © 2017年 彭健克. All rights reserved.
//

#import "UITableViewCell+SmartUtils.h"
#import "Masonry.h"
#import "SMTUsefulMacros.h"
#import <objc/runtime.h>


static char NSObject_key_line;
@implementation UITableViewCell (SmartUtils)
@dynamic line;

- (void)setLine:(UIView *)line {
    UIView *object = objc_getAssociatedObject(self, &NSObject_key_line);
    object = line;
}

- (id)line {
    UIView *object = objc_getAssociatedObject(self, &NSObject_key_line);
    if (!object) {
        object = [[UIView alloc] init];
        object.backgroundColor = HEXCOLOR(0xE8E8E8);
        [self.contentView addSubview:object];
        [object mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.left.offset(AdaptedWidth(15));
            make.right.offset(0);
            make.height.mas_equalTo(0.5);
        }];
        objc_setAssociatedObject(self, &NSObject_key_line, object, OBJC_ASSOCIATION_RETAIN);
    }
    return object;
}


@end
