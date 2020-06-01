//
//  SMTActionSheetView.m
//  Common
//
//  Created by 孔招娣(EX-KONGZHAODI001) on 2018/7/16.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "SMTActionSheetView.h"
#import "Masonry.h"
#import "SMTUsefulMacros.h"
#import "NSArray+SmartUtils.h"

@interface SMTActionSheetViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *marginLine;
@property (nonatomic, strong) SMTActionSheetItem *item;
@end

@interface SMTActionSheetView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *destructiveTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) UIWindow *popupWindow;
@property (nonatomic, weak)   UIViewController *popupVC;
@property (nonatomic, weak)   UIView *controllerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) SMTActionSheetHandler selectedHandler;
@end

static NSString * const kSMTActionSheetViewCellIdentifier = @"kSMTActionSheetViewCellIdentifier";
@implementation SMTActionSheetView

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
       highlightedButtonTitle:(NSString *)highlightedButtonTitle
            otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles {
    if (!(self = [super init])) return nil;
    self.popupWindow.bounds = [UIScreen mainScreen].bounds;
    NSMutableArray *titleItems = [@[] mutableCopy];
    // 普通按钮
    for (NSString *otherTitle in otherButtonTitles) {
        if (otherTitle && otherTitle.length > 0) {
            [titleItems addSafeObject:SMTActionSheetTitleItemMake(SMTActionSheetTypeNormal, otherTitle)];
        }
    }
    // 高亮红色按钮, 放在最下面.
    if (highlightedButtonTitle.length > 0) {
        [titleItems addSafeObject:SMTActionSheetTitleItemMake(SMTActionSheetTypeHighlighted, highlightedButtonTitle)];
    }
    
    self.title = title?:@"";
    self.cancelTitle = (cancelTitle.length > 0)?cancelTitle:@"取消";
    self.items = [titleItems copy];
    
    [self addSubview:self.tableView];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                        items:(NSArray<SMTActionSheetItem *> *)items {
    if (!(self = [super init])) return nil;
    self.popupWindow.bounds = [UIScreen mainScreen].bounds;
    self.title = title?:@"";
    self.cancelTitle = (cancelTitle.length > 0)?cancelTitle:@"取消";
    self.items = items?:@[];
    
    [self addSubview:self.tableView];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

// 隐藏
- (void)hideWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backView.alpha   = 0;
        CGRect newFrame   = self.frame;
        newFrame.origin.y = CGRectGetMaxY(self.controllerView.frame);
        self.frame        = newFrame;
    } completion:^(BOOL finished) {
        [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
        if (completion) completion();
        [self.backView removeFromSuperview];
        self.backView = nil;
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self removeFromSuperview];
        self.popupWindow = nil;
        self.selectedHandler = nil;
    }];
}

- (void)backViewGesture {
    [self hideWithCompletion:nil];
}

- (void)showWithSelectedCompletion:(SMTActionSheetHandler)selectedHandler
{
    self.selectedHandler = selectedHandler;
    _backView = [[UIView alloc] init];
    _backView.alpha = 0;
    _backView.backgroundColor = [UIColor blackColor];
    _backView.userInteractionEnabled = YES;
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewGesture)]];
    [_controllerView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.controllerView);
    }];
    [self.tableView reloadData];
    [_controllerView addSubview:self];
    
    CGFloat selfW = CGRectGetWidth(_controllerView.frame);
    CGFloat selfH = self.tableView.contentSize.height;
    CGFloat selfX = 0;
    CGFloat selfY = CGRectGetMaxY(_controllerView.frame);
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
    [self.popupWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backView.alpha   = 0.38;
        CGRect newFrame   = self.frame;
        newFrame.origin.y = CGRectGetMaxY(self.controllerView.frame)-selfH;
        self.frame        = newFrame;
    } completion:^(BOOL finished) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.controllerView);
            make.height.mas_equalTo(selfH);
        }];
    }];
}

- (UIView *)headerView{
    UIView *headView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.title;
    titleLabel.textColor = HEXCOLOR(0x999999);
    titleLabel.font = [UIFont systemFontOfSize:13];

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGFloat labelHeight = [self.title boundingRectWithSize:CGSizeMake(kScreenWidth-2*50,MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    CGFloat headerHeight = labelHeight+2*17;
    headView.frame = CGRectMake(0, 0, kScreenWidth, headerHeight);
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(50);
        make.right.equalTo(headView).offset(-50);
        make.center.equalTo(headView);
    }];
    return headView;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 1)?1:self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 1)?6:CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTActionSheetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMTActionSheetViewCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTActionSheetViewCell *sheetCell = (SMTActionSheetViewCell *)cell;
    if (indexPath.section == 0) {
        sheetCell.item = self.items[indexPath.row];
        sheetCell.marginLine.hidden = NO;
        if (indexPath.row == 0 && (!self.title || self.title.length == 0)) {
            sheetCell.marginLine.hidden = YES;
        }
    }else{
        SMTActionSheetItem *cancelItem = SMTActionSheetTitleItemMake(SMTActionSheetTypeNormal, _cancelTitle);
        sheetCell.item = cancelItem;
        sheetCell.marginLine.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 延迟0.1秒隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SMTWeakSelf(self);
        [self hideWithCompletion:^{
            SMTStrongSelf(self);
            if (indexPath.section == 0) {
                if (self.selectedHandler) {
                    self.selectedHandler(indexPath.row);
                }
            }
        }];
    });
}

#pragma mark - getter
- (UIWindow *)popupWindow
{
    if (_popupWindow == nil) {
        _popupWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _popupWindow.windowLevel = UIWindowLevelStatusBar+1;
        _popupWindow.rootViewController = [[UIViewController alloc] init];
        _popupVC = _popupWindow.rootViewController;
        _controllerView = _popupVC.view;
    }
    return _popupWindow;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SMTActionSheetViewCell class] forCellReuseIdentifier:kSMTActionSheetViewCellIdentifier];
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
        if (self.title.length > 0) {
            _tableView.tableHeaderView = [self headerView];
        }
    }
    return _tableView;
}
@end

#pragma mark - SMTActionSheetViewCell
@implementation SMTActionSheetViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.marginLine];
    }
    return self;
}

- (void)layoutSubviews{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
    }];
    [self.marginLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
}

- (void)setItem:(SMTActionSheetItem *)item {
    if (_item != item) {
        _item = item;
        self.titleLabel.text = item.title;
        if (item.type == SMTActionSheetTypeHighlighted) {
            self.titleLabel.textColor = HEXCOLOR(0xFF4D4F);
        }else{
            self.titleLabel.textColor = HEXCOLOR(0x333333);
        }
    }
}
#pragma mark - getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)marginLine{
    if (_marginLine == nil) {
        _marginLine = [[UIView alloc] init];
        _marginLine.backgroundColor = HEXCOLOR(0xe8e8e8);
    }
    return _marginLine;
}
@end
@implementation SMTActionSheetItem

+ (instancetype)itemWithType:(SMTActionSheetType)type title:(NSString *)title {
    SMTActionSheetItem *item = [[SMTActionSheetItem alloc] init];
    item.type  = type;
    item.title = title;
    
    return item;
}
@end
