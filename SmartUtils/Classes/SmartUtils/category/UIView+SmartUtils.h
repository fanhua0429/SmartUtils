//
//  UIView+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SmartUtils)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;



typedef NS_ENUM(NSUInteger, UIViewAlignment) {
    UIViewAlignmentLeft = 1 << 0,
    UIViewAlignmentRight = 1 << 1,
    UIViewAlignmentTop = 1 << 2,
    UIViewAlignmentBottom = 1 << 3,
    
    UIViewAlignmentLeftEdge = 1 << 5,
    UIViewAlignmentRightEdge = 1 << 6,
    UIViewAlignmentTopEdge = 1 << 7,
    UIViewAlignmentBottomEdge = 1 << 8,
    
    UIViewAlignmentHorizontalCenter = 1 << 9,
    UIViewAlignmentVerticalCenter = 1 << 10,
};

typedef NS_ENUM(NSInteger, VerticalLayoutType) {
    VerticalLayoutTypeTop,
    VerticalLayoutTypeCenter,
    VerticalLayoutTypeBottom
};

#pragma mark - 快捷方式

/**
 * 快捷方式： frame.origin.x.
 *
 * 设置 frame.origin.x = x
 */
@property (nonatomic, assign) CGFloat x;

/**
 * 快捷方式： frame.origin.y.
 *
 * 设置 frame.origin.y = y
 */
@property (nonatomic, assign) CGFloat y;


/**
 * 快捷方式： frame.size.width
 *
 * 设置 frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * 快捷方式： frame.size.height
 *
 * 设置 frame.size.height = height
 */
@property (nonatomic) CGFloat height;
/**
 * 快捷方式： center.x
 *
 * 设置 center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * 快捷方式： center.y
 *
 * 设置 center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

@property (nonatomic, assign) CGFloat viewTop;

@property (nonatomic, assign) CGFloat viewBottom;

@property (nonatomic, assign) CGFloat viewLeft;

@property (nonatomic, assign) CGFloat viewRight;

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) CGFloat viewHeight;

/// 根据响应链找到当前的VC
- (UIViewController *)viewController;

#pragma mark - frame编程

@property (nonatomic) CGFloat frameOriginX;
@property (nonatomic) CGFloat frameOriginY;
@property (nonatomic) CGFloat frameSizeWidth;
@property (nonatomic) CGFloat frameSizeHeight;
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGPoint frameOrigin;

@property (nonatomic) CGFloat frameMaxX;
@property (nonatomic) CGFloat frameMaxY;

@property (nonatomic) CGPoint frameCenter;
@property (nonatomic) CGFloat frameCenterX;
@property (nonatomic) CGFloat frameCenterY;

+ (CGRect)alignRect:(CGRect)startingRect
             toRect:(CGRect)referenceRect
      withAlignment:(UIViewAlignment)alignment
             insets:(UIEdgeInsets)insets
andReferenceIsSuperView:(BOOL)isReferenceSuperView;

// Init
- (id)initWithSize:(CGSize)size;

// Alignment
- (void)alignRelativeToView:(UIView *)alignView
              withAlignment:(UIViewAlignment)alignment
                  andInsets:(UIEdgeInsets)insets;

- (void)alignRelativeToSuperView:(UIView *)alignView
                   withAlignment:(UIViewAlignment)alignment
                       andInsets:(UIEdgeInsets)insets;

- (void)centerAlignHorizontalForView:(UIView *)view;
- (void)centerAlignVerticalForView:(UIView *)view;

- (void)centerAlignHorizontalForView:(UIView *)view offset:(CGFloat)offset;
- (void)centerAlignVerticalForView:(UIView *)view offset:(CGFloat)offset;
- (void)centerAlignForView:(UIView *)view;

- (void)centerAlignForSuperview;
- (void)centerAlignHorizontalForSuperView;

- (void)centerAlignVerticalForSuperView;

- (void)leftAlignForView:(UIView *)view;
- (void)rightAlignForView:(UIView *)view;
- (void)topAlignForView:(UIView *)view;
- (void)bottomAlignForView:(UIView *)view;

- (void)leftAlignForView:(UIView *)view offset:(CGFloat)offset;
- (void)rightAlignForView:(UIView *)view offset:(CGFloat)offset;
- (void)topAlignForView:(UIView *)view offset:(CGFloat)offset;
- (void)bottomAlignForView:(UIView *)view offset:(CGFloat)offset;

- (void)topAlignForSuperView;
- (void)bottomAlignForSuperView;
- (void)leftAlignForSuperView;
- (void)rightAlignForSuperView;

- (void)topAlignForSuperViewOffset:(CGFloat)offset;
- (void)bottomAlignForSuperViewOffset:(CGFloat)offset;
- (void)leftAlignForSuperViewOffset:(CGFloat)offset;
- (void)rightAlignForSuperViewOffset:(CGFloat)offset;

// Positioning Relative to View
- (void)setFrameOriginYBelowView:(UIView *)view;
- (void)setFrameOriginYAboveView:(UIView *)view;
- (void)setFrameOriginXRightOfView:(UIView *)view;
- (void)setFrameOriginXLeftOfView:(UIView *)view;

- (void)setFrameOriginYBelowView:(UIView *)view offset:(CGFloat)offset;
- (void)setFrameOriginYAboveView:(UIView *)view offset:(CGFloat)offset;
- (void)setFrameOriginXRightOfView:(UIView *)view offset:(CGFloat)offset;
- (void)setFrameOriginXLeftOfView:(UIView *)view offset:(CGFloat)offset;

// Resizing
- (void)setFrameSizeToImageSize;

// Making rounded corners
- (void)roundCornersTopLeft:(CGFloat)topLeft
                   topRight:(CGFloat)topRight
                 bottomLeft:(CGFloat)bottomLeft
                bottomRight:(CGFloat)bottomRight;
static inline UIImage *createRoundedCornerMask(CGRect rect, CGFloat radius_tl, CGFloat radius_tr,
                                               CGFloat radius_bl, CGFloat radius_br);

// Fade Edges
- (void)setHorizontalFadeMaskWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;
- (void)setVerticalFadeMaskWithTopOffset:(CGFloat)topOffset bottomOffset:(CGFloat)bottomOffset;

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (UIImage *)snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/*
 * iOS 6 and prior: calls -snapshotView and wraps the result in a UIImageView
 * on iOS 7 and up: calls and returns the stock -snapshotView method
 */

//- (UIView *)snapshotImageView;

/* Debug
 *
 * The functions below are only performed in DEBUG mode
 * @param "showInRelease" will apply the function in both DEBUG and RELEASE mode
 */
- (void)showDebugFrame;
- (void)hideDebugFrame;
- (void)showDebugFrame:(BOOL)showInRelease;

- (void)logFrameChanges;

// Layout Helpers
+ (CGFloat)alignVertical:(VerticalLayoutType)type
                   views:(NSArray *)views
             withSpacing:(CGFloat)spacing
                  inView:(UIView *)view
      shrinkSpacingToFit:(BOOL)shrinkSpacingToFit;

+ (CGFloat)alignVertical:(VerticalLayoutType)type
                   views:(NSArray *)views
        withSpacingArray:(NSArray *)spacing
                  inView:(UIView *)view
      shrinkSpacingToFit:(BOOL)shrinkSpacingToFit;

// subviews
+ (UIView *)firstResponder;
- (UIView *)firstResponderInSubviews;
- (NSArray *)subviewsOfClass:(Class)aClass recursive:(BOOL)recursive;

/**
 *  获取cell所在的tableview,一般只是用来确定UITableViewCell的所属UITableview
 *
 *  @return 找到的UITableview
 */
- (UITableView *)fdd_superTableView;

/**
 *  获取view所在的tableViewCell
 *
 *  @return view所在的tableViewCell
 */
- (UITableViewCell *)fdd_superTableCell;

/**
 *  获取第一响应对象,可以是自己,或者自己的子类中寻找
 *
 *  @return 第一响应对象
 */
- (UIView *)fdd_findFirstResponder;

- (UIViewController *)fdd_viewController;

- (void)removeAllSubViews;

/**
 打印子View
 */
- (void)printSubviews;


#pragma mark -  reuseable

+(NSString *)ID;
+ (UINib *)nib;
+ (UINib *)pa_nibWithBundle:(NSBundle *)bundle;
+ (instancetype)viewFromNib;
+ (instancetype)viewFromNibWithBundle:(NSBundle *)bundle;
@end
