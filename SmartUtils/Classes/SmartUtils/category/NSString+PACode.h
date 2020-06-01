//
//  NSString+PACode.h
//  Enrich
//
//  Created by 罗俊宇 on 16/11/1.
//  Copyright © 2016年 PingAn. All rights reserved.
//

// 编码/解码

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (PACode)

+ (NSString *)pa_stringWithBase64EncodedString:(NSString *)base64EncodedString;
/// 将URL编码成UTF-8字符串
//- (NSString *)pa_stringByURLEncode;

/// 将URL解码成UTF-8字符串
//- (NSString *)pa_stringByURLDecode;

/// 普通字符串转成HTML标准的字符串 Example: "a < b" 变成 "a &lt; b".
- (NSString *)pa_stringByEscapingHTML;
/// URL编码
//- (NSString *)stringByURLEncode;

// 得到时间戳
+ (NSString *)getTimeStamp;

// 3DES CBC模式加解密
- (NSString*)desCBCEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey;

// 3DES加解密
- (NSString*)jl_desEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey;

/// 经过修正，得到jsonData字典对需要的desKey
- (NSString *)desKey;

/// 经过修正， 得到sign字典需要的signKey;
- (NSString *)signKey;

/**
 self，是转json字符串的数据。
 加密好的各个部分组装成字典
 @param signKey 签名key
 @param desKey DES秘钥
 */
- (NSDictionary *)encryptWithSignKey:(NSString *)signKey
                              desKey:(NSString *)desKey;

@end
