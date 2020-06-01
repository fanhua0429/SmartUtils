//
//  SMTActionSheetView.h
//  Common
//
//  Created by 孔招娣(EX-KONGZHAODI001) on 2018/7/16.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SMTActionSheetType) {
    SMTActionSheetTypeNormal = 0,    // 正常状态
    SMTActionSheetTypeHighlighted,   // 高亮状态
};
#pragma mark - SMTActionSheetItem
@interface SMTActionSheetItem : NSObject

@property (nonatomic, assign) SMTActionSheetType type; // 选项类型, 有 默认 和 高亮 两种类型.
@property (nonatomic, copy) NSString *title; // 选项标题

+ (instancetype)itemWithType:(SMTActionSheetType)type title:(NSString *)title;

@end
NS_INLINE SMTActionSheetItem *SMTActionSheetTitleItemMake(SMTActionSheetType type, NSString *title) {
    return [SMTActionSheetItem itemWithType:type title:title];
}

#pragma mark - SMTActionSheetView
typedef void(^SMTActionSheetHandler)(NSInteger selectedIndex);
@interface SMTActionSheetView : UIView

/**
 ActionSheet 弹框
 @param title 标题
 @param cancelTitle 取消按钮标题
 @param highlightedButtonTitle 高亮按钮标题
 @param otherButtonTitles 其他按钮标题集合
 */
- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
       highlightedButtonTitle:(NSString *)highlightedButtonTitle
            otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles;

/**
 ActionSheet 弹框
 @param title       标题
 @param cancelTitle 取消按钮标题
 @param items       选项按钮item
 */
- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                        items:(NSArray<SMTActionSheetItem *> *)items;

- (void)showWithSelectedCompletion:(SMTActionSheetHandler)selectedHandler;
@end
