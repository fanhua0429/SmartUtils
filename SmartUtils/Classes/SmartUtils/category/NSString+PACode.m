//
//  NSString+PACode.m
//  Enrich
//
//  Created by 罗俊宇 on 16/11/1.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSString+PACode.h"
#include <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import "NSData+SmartUtils.h"
#import "SMTUsefulMacros.h"
@implementation NSString (PACode)


+ (NSString *)pa_stringWithBase64EncodedString:(NSString *)base64EncodedString
{
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else{
        return nil;
    }
    
}

- (NSString *)pa_stringByURLDecode
{
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)pa_stringByEscapingHTML
{
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}


- (NSString *)desCBCEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey {
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *EncryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [deskey UTF8String];
    Byte vi[] = {0,0,0,0,0,0,0,0};
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,//kCCOptionPKCS7Padding,天眼埋点使用CBC
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vi, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr
                                      length:(NSUInteger)movedBytes];
        result = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    }else{
        // 进行base64加密处理
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}



// 3DES
- (NSString*)jl_desEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *EncryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [deskey UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    //    CCOptions i = encryptOrDecrypt == kCCDecrypt ? kCCOptionECBMode :kCCOptionPKCS7Padding;
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,//kCCOptionPKCS7Padding,        //健康云用的ECB模式
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr
                                      length:(NSUInteger)movedBytes];
        result = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    }else{
        // 进行base64加密处理
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

// 获取yyyyMMddHHmmss格式时间戳
+ (NSString *)getTimeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStamp = [formatter stringFromDate:[NSDate date]];
    return timeStamp;
}

- (NSString *)desKey {

    NSMutableString * desKey = [[NSMutableString alloc] initWithString:@""];
    
    [desKey appendString:[self substringWithRange:NSMakeRange(1, 3)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(60, 5)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(15, 4)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(5, 1)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(32, 5)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(71, 2)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(25, 3)]];
    [desKey appendString:[self substringWithRange:NSMakeRange(40, 1)]];
    
    return desKey;
}

- (NSString *)signKey {
    
    NSMutableString * mutableSignKey = [[NSMutableString alloc] init];
    
    [mutableSignKey appendString:[self substringWithRange:NSMakeRange(9, 2)]];
    [mutableSignKey appendString:[self substringWithRange:NSMakeRange(60, 3)]];
    [mutableSignKey appendString:[self substringWithRange:NSMakeRange(15, 4)]];
    [mutableSignKey appendString:[self substringWithRange:NSMakeRange(54, 1)]];
    [mutableSignKey appendString:[self substringWithRange:NSMakeRange(32, 2)]];

    return mutableSignKey;
}

- (NSString *)jl_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] jl_sha256String];
}

// 得到的这个字典最后在业务层调用网络库API发起请求
- (NSDictionary *)encryptWithSignKey:(NSString *)signKey
                              desKey:(NSString *)desKey {
    NSString *jsonStr = self.copy;

    
    // 对jsonStr 3DES加密 里面最后还做了base64加密
    NSString* contentDesStr = [jsonStr jl_desEncryptOrDecrypt:kCCEncrypt deskey:desKey];
    
    // 得到时间戳对应的字符串
    NSString* timeStamp = [NSString getTimeStamp];
    
    // 拼接时间戳字符串
    NSString* signStr = [NSString stringWithFormat:@"%@%@",signKey,timeStamp];
    
    // 得到sign串(sha256加密)
    NSString* shaSign = [signStr jl_sha256String];
    
    
    
    NSDictionary* postJson =  @{
                                @"data":StringWithStr(contentDesStr),
                                @"sign":StringWithStr(shaSign),
                                @"timestamp":StringWithStr(timeStamp)

                                };
    
    return postJson;
}

@end
