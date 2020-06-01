//
//  SMTLimitedTextView.h
//  SMTCommon
//
//  Created by shadow on 2018/3/15.
//  Copyright © 2018年 彭健克. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTLimitedTextView : UITextView
@property (nonatomic, assign) BOOL flexAlphabetCount;       // 2个英文代表一个字符

@property (nonatomic, assign) NSInteger maxInputLength;// 允许输入的最大长度  为0时表示不限制
@property (nonatomic, copy)void (^textDidChangeBlock)(SMTLimitedTextView *textView,NSInteger nomarlCount);

@end
