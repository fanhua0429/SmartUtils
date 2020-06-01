//
//  DPRollBarCell.h
//  Utilities
//
//  Created by DancewithPeng on 2018/1/20.
//  Copyright © 2018年 dancewithpeng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPRollBarCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, assign) NSInteger indexTag;

- (instancetype)initWithReuseIdentifier:(NSString *)identifier;

@end
