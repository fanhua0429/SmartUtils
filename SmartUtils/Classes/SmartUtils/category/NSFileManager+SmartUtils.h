//
//  NSFileManager+SmartUtils.h
//  SmartUtils
//
//  Created by 廖超龙 on 2018/9/13.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SmartUtils)

/**
 让指定文件或文件夹不使用iOS系统自带的备份属性，完全由开发者自行处理
 
 @param filePathString 文件路径
 @return 操作成功返回YES，失败返回NO
 */
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString;

@end
