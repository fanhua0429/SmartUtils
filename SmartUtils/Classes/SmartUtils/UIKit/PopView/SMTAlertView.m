//
//  SMAlertView.m
//  FreeCitizen
//
//  Created by 安俊(平安科技智慧生活团队) on 2018/6/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "SMTAlertView.h"
#import "SMTUsefulMacros.h"
#import "Masonry.h"
#import "NSString+SmartUtils.h"

@interface SMTAlertView()

@property (nonatomic, copy) BtnClickHandler cancelHandler;
@property (nonatomic, copy) BtnClickHandler confirmHandlder;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *confirmTitle;

@end

@implementation SMTAlertView

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                cancelHandler:(BtnClickHandler)cancelHandler
               confirmHandler:(BtnClickHandler)confirmHandlder{
    
    if(self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]){
        self.title = title;
        self.content = content;
        self.cancelTitle = cancelTitle;
        self.confirmTitle = confirmTitle;
        self.cancelHandler = cancelHandler;
        self.confirmHandlder = confirmHandlder;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = HEXACOLOR(0x000000, 0.4);
    
    UIView * whiteBackView = [[UIView alloc] init];
    whiteBackView.clipsToBounds = YES;
    whiteBackView.layer.cornerRadius = 6;
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBackView];
    [whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(270);
    }];
   
    if (self.title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = HEXCOLOR(0x333333);
        titleLabel.numberOfLines = 0;
        self.titleLabel = titleLabel;
        [whiteBackView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(24);
            make.right.mas_equalTo(-24);
        }];
        
    }
    
    // 计算标题的高度
    CGSize titleSize = [self.content sizeForFont:SYSTEMFONT(15) maxSize:CGSizeMake(270-38, MAXFLOAT)];
    // UITextView的上下左右各有一个5的留白
    CGFloat titleHeight = (titleSize.height+10 > 286 ? 286 : titleSize.height+10);
    
    UITextView * titleTextView = [[UITextView alloc] init];
    self.titleTextView = titleTextView;
    titleTextView.textColor = HEXCOLOR(0x333333);
    titleTextView.font = SYSTEMFONT(15);
    titleTextView.textAlignment = NSTextAlignmentCenter;
    titleTextView.text = self.content;
    titleTextView.editable = NO;
    [whiteBackView addSubview:titleTextView];
    [titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        (self.title.length > 0 ? make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8) : make.top.mas_equalTo(24));
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(titleHeight);
    }];
    

    // 分割线
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xe0e0e0);
    [whiteBackView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleTextView.mas_bottom).offset(24);
        make.height.mas_equalTo(0.5);
    }];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = SYSTEMFONT(18);
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEXCOLOR(0x27A5F9) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [whiteBackView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom).offset(0);
        make.height.mas_equalTo(49.5);
        make.bottom.mas_equalTo(0);
    }];
    
    if(self.confirmTitle.length > 0){
        // 两个按钮都需要显示 重新设置约束
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_bottom).offset(0);
            make.height.mas_equalTo(49.5);
            make.width.mas_equalTo(270/2.0);
            make.bottom.mas_equalTo(0);
        }];
        
        // 确认按钮
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.titleLabel.font = SYSTEMFONT(18);
        [confirmBtn setTitle:self.confirmTitle forState:UIControlStateNormal];
        [confirmBtn setTitleColor:HEXCOLOR(0x27A5F9) forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBtn = confirmBtn;
        [whiteBackView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelBtn.mas_right).offset(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_bottom).offset(0);
            make.height.mas_equalTo(49.5);
            make.width.mas_equalTo(cancelBtn.mas_width);
            make.bottom.mas_equalTo(0);
        }];
        
        // 中间的分割线
        UIView * splitView = [[UIView alloc] init];
        splitView.backgroundColor = HEXCOLOR(0xe0e0e0);
        [whiteBackView addSubview:splitView];
        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(0.5);
        }];
    }
}

// 显示视图
- (void)showInWindow{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

// 销毁视图
- (void)invalidAlertView{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 取消(左边的按钮或者单个按钮)
- (void)cancelBtnClick:(UIButton *)btn{
    if(self.cancelHandler){
        self.cancelHandler();
        self.cancelHandler = nil;
    }
    
    [self invalidAlertView];
}

// 确认(右边的按钮)
- (void)confirmBtnClick:(UIButton *)btn{
    if(self.confirmHandlder){
        self.confirmHandlder();
        self.confirmHandlder = nil;
    }
    
    [self invalidAlertView];
}

@end
