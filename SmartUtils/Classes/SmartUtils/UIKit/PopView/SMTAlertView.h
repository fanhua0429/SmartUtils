//
//  SMAlertView.h
//  FreeCitizen
//
//  Created by 安俊(平安科技智慧生活团队) on 2018/6/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickHandler)(void);
@interface SMTAlertView : UIView

/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 标题
 */
@property (nonatomic, strong) UITextView *titleTextView;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmBtn;


/**
 初始化一个弹窗视图 <如果只需要显示一个文本，请将title传nil，content正常设值即可>
 不希望用户点击的按钮颜色: HEXCOLOR(0x666666)    灰色
 希望用户点击的按钮颜色: HEXCOLOR(0x27A5F9)      蓝色

 @param title 标题
 @param content 内容 不为空
 @param cancelTitle 取消按钮文字 不为空
 @param confirmTitle 确认按钮文字
 @param cancelHandler 取消点击回调
 @param confirmHandlder 确认点击回调
 @return return value description
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                cancelHandler:(BtnClickHandler)cancelHandler
               confirmHandler:(BtnClickHandler)confirmHandlder;


/**
 显示弹框
 */
- (void)showInWindow;


/**
 销毁视图
 */
- (void)invalidAlertView;

@end
