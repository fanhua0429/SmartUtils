//
//  SMTRegex.h
//  SMT-NT-iOS
//
//  Created by 张鹏 on 2018/1/26.
//  Copyright © 2018年 pingan. All rights reserved.
//

#ifndef SMTRegex_h
#define SMTRegex_h


/** 手机号码 正则表达式 */
static NSString * const kSMTRegex_MobilePhone = @"^(1[3-9])\\d{9}$";

/** 注册密码 正则表达式 */
static NSString * const kSMTRegex_Password = @"^(1[3-9][0-9])\\d{8}$";


//static NSString * const kSMTRegex_Password = @"^(?=.*\d)(?=.*[A-Za-z])[^ ]{6,32}$";


/** 邮箱 正则表达式 */
static NSString * const kSMTRegex_Email = @"^[A-Za-zd]+([-_.][A-Za-zd]+)*@([A-Za-zd]+[-.])+[A-Za-zd]{2,5}$";

/** 身份证 正则表达式 */
static NSString * const kSMTRegex_IDCardNumber = @"^(\\d{14}|\\d{17})(\\d|[xX])$";

/** 姓名 正则表达式 */
static NSString * const kSMTRegex_VaildRealName = @"^[a-zA-Z\\u4E00-\\u9FA5·]{2,18}+$";

/** 只能是数字 正则表达式 */
static NSString * const kSMTRegex_OnlyNumber = @"^[0-9]*$";

/** 数字和xX 正则表达式 */
static NSString * const kSMTRegex_NumberAndxX = @"^(\\d|[xX])$";

/** 姓名输入限制 正则表达式 */
static NSString * const kSMTRegex_RealNameLimit = @"^[a-zA-Z\\u4E00-\\u9FA5·]+$";

/** 所有车牌，包括新能源车牌 正则表达式 */
static NSString * const kSMTRegex_CarNumber = @"^([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1})$";

/** 普通车牌，不包括新能源车牌 正则表达式 */
static NSString * const kSMTRegex_NormalCarNumber = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1}$";

/** 新能源小车 正则表达式 */
static NSString * const kSMTRegex_NewEnergySmallCarNumber = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}([DF][A-HJ-NP-Z0-9][0-9]{4})$";

/** 新能源大车 正则表达式 */
static NSString * const kSMTRegex_NewEnergyLargeCarNumber = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}([0-9]{5}[DF])$";

/** 纯数字 正则表达式 */
static NSString * const kSMTRegex_Number = @"[0-9]*";

#endif /* SMTRegex_h */
