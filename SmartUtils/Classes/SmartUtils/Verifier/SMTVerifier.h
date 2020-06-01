//
//  SMTVerifier.h
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/1/22.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 校验器
 */
@interface SMTVerifier : NSObject

/**
 校验非空字符串

 @param string 需要校验的字符串
 @return 空串返回 NO， 非空返回 YES
 */
+ (BOOL)isNotNilString:(NSString *)string;

/**
 校验字符串是否为纯数字
 
 @param number 需要校验的字符串
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isPureNumber:(NSString *)number;


/**
 校验邮箱

 @param email 需要校验的邮箱
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidEmail:(NSString *)email;


/**
 校验手机号码

 @param mobilePhone 需要校验的手机号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidMobilePhone:(NSString *)mobilePhone;


/**
 校验密码格式

 @param password 需要校验的密码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidPassword:(NSString *)password;


/**
 校验字符串是否符合正则表达式

 @param string 需要校验的字符串
 @param regex  正则表达式
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidString:(NSString *)string withRegex:(NSString *)regex;


/**
 校验身份证机号码
 
 @param IDCardNumber 需要校验的身份证号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidIdentityCard:(NSString *)IDCardNumber;

/**
 校验车牌号
 
 @param carNumber 需要校验的车牌号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidCarNumber:(NSString *)carNumber;

/**
 校验银行卡号码
 
 @param cardNumber 需要校验的银行卡号码
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isValidBankCard:(NSString *)cardNumber;

/**
 校验姓名
 
 @param vaildRealName 需要校验的姓名
 @return 正确的格式返回YES，错误返回NO
 */
+ (BOOL)isVaildRealName:(NSString *)vaildRealName;


/**
 验证是否是数字
 */
+ (BOOL)isValidNumber:(NSString *)string;

/**
 验证是否是数字和xX
 */
+ (BOOL)isValidNumberAndxX:(NSString *)string;

/**
 姓名输入限制
 */
+ (BOOL)isValidRealNameLimit:(NSString *)string;
@end
