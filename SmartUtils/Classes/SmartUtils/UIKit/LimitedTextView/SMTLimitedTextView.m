//
//  SMTLimitedTextView.m
//  SMTCommon
//
//  Created by shadow on 2018/3/15.
//  Copyright © 2018年 彭健克. All rights reserved.
//

#import "SMTLimitedTextView.h"

@implementation SMTLimitedTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self evaluateText:self];
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


- (void)textChange:(NSNotification *)noti {
    
    
    UITextView *textView = noti.object;
    if (textView != self) {
        return;
    }
    [self evaluateText:self];
}

- (void)evaluateText:(UITextView *)textView {
    if (self.maxInputLength==0) {
        if (self.textDidChangeBlock) {
            self.textDidChangeBlock(self, textView.text.length);
        }
        return;
    }
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    NSInteger actualCount = toBeString.length;
    NSInteger clipIndex = -1;
    if (self.flexAlphabetCount) {
        NSInteger count = 0;
        for (int i=0; i<toBeString.length; i++) {
            unichar subChar = [toBeString characterAtIndex:i];
            if (subChar<128) {
                count ++;
            }
            NSInteger impureCount = count/2+count%2;
            actualCount = i+1 - count + impureCount;
            if (actualCount>self.maxInputLength) {
                clipIndex = i;
                break;
            }
        }
        
    }
    else {
        if (actualCount > self.maxInputLength) {
            clipIndex = self.maxInputLength;
        }
    }
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];       //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (clipIndex>-1) {
                textView.text = [toBeString substringToIndex:clipIndex];
            }
            
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    else{   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况41 7 4
        if (clipIndex>-1) {
            textView.text = [toBeString substringToIndex:clipIndex];
        }
    }
    
    if (self.textDidChangeBlock) {
        if (clipIndex>-1) {
            self.textDidChangeBlock(self, clipIndex);
            
        }
        else {
            self.textDidChangeBlock(self, textView.text.length);
            
        }
    }
}

@end
