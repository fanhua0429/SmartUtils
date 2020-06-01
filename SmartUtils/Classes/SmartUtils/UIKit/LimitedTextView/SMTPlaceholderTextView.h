//
//  SMTPlaceholderTextView.h
//  SCar
//
//  Created by dusheng on 17/3/29.
//  Copyright © 2017年 彭健克. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTPlaceholderTextView : UITextView
@property(copy,nonatomic) NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;
@end
