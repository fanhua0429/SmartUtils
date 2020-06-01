//
//  NSDictionary+SMTSafeCategory.h
//  SMT-NT-iOS
//
//  Created by 莫冰(平安科技智慧政务团队) on 2018/5/3.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SMTSafeCategory)

- (id)safeObjectForKey:(id)aKey;
- (NSString *)stringObjectForKey:(id)aKey;

@end

@interface NSMutableDictionary (SMTSafeCategory)

- (void)safeSetObject:(id)anObject forKey:(id)aKey;
- (void)safeRemoveObjectForKey:(id)aKey;

@end
