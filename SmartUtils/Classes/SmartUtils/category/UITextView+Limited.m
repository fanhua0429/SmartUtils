//
//  UITextView+Limited.m
//  SMTCommon
//
//  Created by shadow on 2018/3/15.
//  Copyright © 2018年 彭健克. All rights reserved.
//

#import "UITextView+Limited.h"
#import <objc/runtime.h>
@implementation UITextView (Limited)

static const char * inputLengthKey = "cmd_maxInputLengthKey";
static const char * flexAlphabetCountKey = "cmd_flexAlphabetCountKey";

- (BOOL)flexAlphabetCount {
    return [objc_getAssociatedObject(self, flexAlphabetCountKey) boolValue];
}

- (void)setFlexAlphabetCount:(BOOL)flexAlphabetCount {
    objc_setAssociatedObject(self, flexAlphabetCountKey, [NSNumber numberWithInteger:flexAlphabetCount], OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)maxInputLength
{
    return [objc_getAssociatedObject(self, inputLengthKey) integerValue];
}

- (void)setMaxInputLength:(NSInteger)maxInputLength
{
    objc_setAssociatedObject(self, inputLengthKey, [NSNumber numberWithInteger:maxInputLength], OBJC_ASSOCIATION_RETAIN);
    
//    if (maxInputLength > 0) {
//
//        [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//    } else {
//        [self removeTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//    }
}

- (NSInteger)getAlphabetCount:(NSString *)str {
    NSInteger count = 0;
    for (int i=0; i<str.length; i++) {
        unichar subChar = [str characterAtIndex:i];
        if (subChar<128) {
            count ++;
        }
    }
    return count;
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    if (self.maxInputLength == 0) {
        return;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    NSInteger actualCount = toBeString.length;
    if (self.flexAlphabetCount) {
        NSInteger alphabetCount = [self getAlphabetCount:toBeString];
        NSInteger impureCount = alphabetCount/2+alphabetCount%2;
        actualCount = toBeString.length-alphabetCount+impureCount;
    }
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (actualCount > self.maxInputLength) {
                textField.text = [toBeString substringToIndex:self.maxInputLength];
            }
            
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    else{   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (actualCount > self.maxInputLength) {
            textField.text = [toBeString substringToIndex:self.maxInputLength];
        }
    }
}

@end
