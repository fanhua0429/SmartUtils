//
//  SMTVerifier.m
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/1/22.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "SMTVerifier.h"
#import "SMTRegex.h"

@implementation SMTVerifier

/**
 校验非空字符串
 
 @param string 需要校验的字符串
 @return 空串返回 NO， 非空返回 YES
 */
+ (BOOL)isNotNilString:(NSString *)string {
    
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str == nil || str.length <= 0) {
        return NO;
    }
    
    return YES;
}

/**
 校验字符串是否为纯数字
 
 @param number 需要校验的字符串
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isPureNumber:(NSString *)number{
    return [self isValidString:number withRegex:kSMTRegex_Number];
}


/**
 校验车牌号
 
 @param carNumber 需要校验的车牌号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidCarNumber:(NSString *)carNumber {
    return [self isValidString:carNumber withRegex:kSMTRegex_CarNumber];
}
/**
 校验邮箱
 
 @param email 需要校验的邮箱
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidEmail:(NSString *)email {
    return [self isValidString:email withRegex:kSMTRegex_Email];
}


/**
 校验手机号码
 
 @param mobilePhone 需要校验的手机号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidMobilePhone:(NSString *)mobilePhone {
    return [self isValidString:mobilePhone withRegex:kSMTRegex_MobilePhone];
}


/**
 校验密码格式
 
 @param password 需要校验的密码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidPassword:(NSString *)password {

//    return [self isValidString:password withRegex:kSMTRegex_Password];
    BOOL result = NO;
    if ([password length] >= 6 && [password length] <= 32){
        //数字条件
        NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];

        //符合数字条件的有几个
        NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password  options:NSMatchingReportProgress                  range:NSMakeRange(0, password.length)];

        //英文字条件
        NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];

        //符合英文字条件的有几个
        NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];

        if(tNumMatchCount >= 1 && tLetterMatchCount >= 1){
            result = YES;
        }
        //不能包含空格
        if([password containsString:@" "]) {
            result = NO;
        }
    }
    return result;
}

/**
 校验姓名
 
 @param vaildRealName 需要校验的姓名
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isVaildRealName:(NSString *)vaildRealName {
    return [self isValidString:vaildRealName withRegex:kSMTRegex_VaildRealName];
}

/**
 校验身份证机号码
 
 @param IDCardNumber 需要校验的身份证号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidIdentityCard:(NSString *)IDCardNumber {
    return [self isValidString:IDCardNumber withRegex:kSMTRegex_IDCardNumber];
}

/**
 校验银行卡号码
 
 @param cardNumber 需要校验的银行卡号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

/**
 验证是否是数字
 */
+ (BOOL)isValidNumber:(NSString *)string {
    return [self isValidString:string withRegex:kSMTRegex_OnlyNumber];
}

/**
 验证是否是数字和xX
 */
+ (BOOL)isValidNumberAndxX:(NSString *)string {
    return [self isValidString:string withRegex:kSMTRegex_NumberAndxX];
}

/**
 真实姓名输入限制
 */
+ (BOOL)isValidRealNameLimit:(NSString *)string {
    return [self isValidString:string withRegex:kSMTRegex_RealNameLimit];
}


/**
 校验字符串是否符合正则表达式
 
 @param string 需要校验的字符串
 @param regex  正则表达式
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidString:(NSString *)string withRegex:(NSString *)regex {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:string];
}



@end
