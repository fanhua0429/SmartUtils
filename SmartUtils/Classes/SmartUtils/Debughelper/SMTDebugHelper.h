//
//  SMTDebugHelper.h
//  SMT-NT-iOS
//
//  Created by 莫冰(平安科技智慧政务团队) on 2018/4/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SMTDebugHelper : NSObject

@property (nonatomic, copy) NSString *server;
#ifdef DEBUG
//@property (nonatomic, strong) UILabel *debugLabel; //导航条上面的显示内外网的label
#endif
@property (nonatomic, assign) BOOL needLog; //是否在桌面上输出日志

+ (SMTDebugHelper *)sharedInstance;
+ (void)setup;
+ (void)showMemoryUseage;
- (void)setDebug:(BOOL)debug;
//- (void)updateLabel;s

@end

@interface NSObject (SMTDebugHelper)

@end

@interface UIView (ErgodicAndSetFrame)  //遍历View
- (void)ergodicSubviewsWithBlock:(BOOL (^)(UIView *view))handler
                        DeepLoop:(BOOL)deeploop;

@end




