//
//  NSMutableAttributedString+SmartUtils.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "NSMutableAttributedString+SmartUtils.h"
#import <objc/runtime.h>

@implementation NSMutableAttributedString (SmartUtils)
- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name])
        return;
    if (value && ![NSNull isEqual:value]) {
        [self addAttribute:name value:value range:range];
    } else {
        [self removeAttribute:name range:range];
    }
}

- (NSAttributedString *)highlightKeyword:(NSString *)keyword withColor:(UIColor *)color {
    if (color == nil || self.length == 0) {
        return self;
    }
    
    NSRange range = [self.string rangeOfString:keyword];
    while (range.location != NSNotFound) {
        [self setAttribute:NSForegroundColorAttributeName value:color range:range];
        range = [self.string rangeOfString:keyword
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(range.location + range.length,
                                                       self.string.length - range.location - range.length)];
    }
    return self;
}

- (NSAttributedString *)highlightKeyword:(NSString *)keyword withFont:(UIFont *)font {
    if (font == nil || self.length == 0) {
        return self;
    }
    
    NSRange range = [self.string rangeOfString:keyword];
    while (range.location != NSNotFound) {
        [self setAttribute:NSFontAttributeName value:font range:range];
        range = [self.string rangeOfString:keyword
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(range.location + range.length,
                                                       self.string.length - range.location - range.length)];
    }
    return self;
}

- (NSAttributedString *)hightlightedNumbersWithColor:(UIColor *)color andFont:(UIFont *)font {
    if ((color == nil && font == nil) || self.length < 1) {
        return self;
    }
    
    NSString *regexPattern = @"\\d+";
    NSRegularExpression *regex =
    [[NSRegularExpression alloc] initWithPattern:regexPattern options:0 error:nil];
    
    NSArray *matches =
    [regex matchesInString:self.string options:0 range:NSMakeRange(0, self.length)];
    if (matches.count < 1) {
        return self;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (color) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    
    for (NSTextCheckingResult *match in matches) {
        if (match.range.length > 0) {
            [self setAttributes:attributes range:match.range];
        }
    }
    return self;
}

+ (NSMutableAttributedString *)pa_attributeText:(NSString *)string {
    if (string) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
        return att;
    }
    return nil;
}

- (CGSize)pa_drawingSizeWithSize:(CGSize)size {
    CGSize drawingSize = [self boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            context:nil]
    .size;
    return drawingSize;
}

- (void)pa_setFont:(UIFont *)font {
    [self pa_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)pa_setFont:(UIFont *)font range:(NSRange)range {
    [self addAttributes:@{ NSFontAttributeName: font } range:range];
}

- (void)pa_setColor:(UIColor *)color {
    [self pa_setColor:color range:NSMakeRange(0, self.length)];
}

- (void)pa_setColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{ NSForegroundColorAttributeName: color } range:range];
}

#pragma mark - about paragraph

- (void)pa_setLineSpace:(NSInteger)space {
    [self.paragraph setLineSpacing:space];
    [self addAttribute:NSParagraphStyleAttributeName
                 value:self.paragraph
                 range:NSMakeRange(0, self.length)];
}

- (void)pa_setLineSpace:(NSInteger)space range:(NSRange)range {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:space];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
}

- (void)pa_setLineHeight:(NSInteger)height {
    [self.paragraph setMinimumLineHeight:height];
    [self addAttribute:NSParagraphStyleAttributeName
                 value:self.paragraph
                 range:NSMakeRange(0, self.length)];
}

- (void)pa_setLineHeight:(NSInteger)height range:(NSRange)range {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setMinimumLineHeight:height];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
}

- (void)pa_setLineBreakMode:(NSLineBreakMode)breakMode {
    [self.paragraph setLineBreakMode:breakMode];
    [self addAttribute:NSParagraphStyleAttributeName
                 value:self.paragraph
                 range:NSMakeRange(0, self.length)];
}

- (void)pa_setLineBreakMode:(NSLineBreakMode)breakMode range:(NSRange)range {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:breakMode];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
}

- (void)pa_setAlignment:(NSTextAlignment)alitnment {
    NSMutableParagraphStyle *paragraph = self.paragraph;
    [paragraph setAlignment:alitnment];
    [self addAttribute:NSParagraphStyleAttributeName
                 value:self.paragraph
                 range:NSMakeRange(0, self.length)];
}

#pragma mark - image

+ (NSAttributedString *)pa_attachmentAttributedWithImage:(UIImage *)image {
    return [[self class] pa_attachmentAttributedWithImage:image offset:0];
}

+ (NSAttributedString *)pa_attachmentAttributedWithImage:(UIImage *)image offset:(CGFloat)offset {
    if (image) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, offset, image.size.width, image.size.height);
        return [NSAttributedString attributedStringWithAttachment:attachment];
    }
    return nil;
}

- (void)pa_addImage:(UIImage *)image atIndex:(NSInteger)idx {
    if (image) {
        [self insertAttributedString:[[self class] pa_attachmentAttributedWithImage:image]
                             atIndex:idx];
    }
}

- (void)pa_addImage:(UIImage *)image atIndex:(NSInteger)idx offset:(CGFloat)offset {
    if (image) {
        [self
         insertAttributedString:[[self class] pa_attachmentAttributedWithImage:image offset:offset]
         atIndex:idx];
    }
}

- (void)pa_replaceCharactersInRange:(NSRange)range withImage:(UIImage *)image {
    if (image) {
        [self replaceCharactersInRange:range
                  withAttributedString:[[self class] pa_attachmentAttributedWithImage:image]];
    }
}

#pragma mark - paragarph porperty

- (NSMutableParagraphStyle *)paragraph {
    NSMutableParagraphStyle *paragraph = objc_getAssociatedObject(self, @selector(paragraph));
    
    if (!paragraph) {
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        self.paragraph = para;
        paragraph = para;
    }
    
    return paragraph;
}

- (void)setParagraph:(NSMutableParagraphStyle *)paragraph {
    objc_setAssociatedObject(self, @selector(paragraph), paragraph, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
