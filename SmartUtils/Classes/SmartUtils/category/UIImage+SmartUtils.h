//
//  UIImage+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (SmartUtils)
/**
 Create and return a 1x1 point size image with the given color.
 
 @param color  The color.
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color;

/**
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's type.
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 Create and return an image with custom draw code.
 
 @param size      The image size.
 @param drawBlock The draw block.
 
 @return The new image.
 */
+ (nullable UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;


#pragma mark - Modify Image
///=============================================================================
/// @name Modify Image
///=============================================================================

/**
 Draws the entire image in the specified rectangle, content changed with
 the contentMode.
 
 @discussion This method draws the entire image in the current graphics context,
 respecting the image's orientation setting. In the default coordinate system,
 images are situated down and to the right of the origin of the specified
 rectangle. This method respects any transforms applied to the current graphics
 context, however.
 
 @param rect        The rectangle in which to draw the image.
 
 @param contentMode Draw content mode
 
 @param clips       A Boolean value that determines whether content are confined to the rect.
 */
- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;

/**
 Returns a new image which is scaled from this image.
 The image will be stretched as needed.
 
 @param size  The new size to be scaled, values should be positive.
 
 @return      The new image with the given size.
 */
- (nullable UIImage *)imageByResizeToSize:(CGSize)size;

/**
 Returns a new image which is scaled from this image.
 The image content will be changed with thencontentMode.
 
 @param size        The new size to be scaled, values should be positive.
 
 @param contentMode The content mode for image content.
 
 @return The new image with the given size.
 */
- (nullable UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 Returns a new image which is cropped from this image.
 
 @param rect  Image's inner rect.
 
 @return      The new image, or nil if an error occurs.
 */
- (nullable UIImage *)imageByCropToRect:(CGRect)rect;

/// 三角形图片
+ (UIImage *)imageTriangleWithColor:(UIColor *)color rect:(CGRect)rect point1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3;



/// 旋转图片
- (UIImage *)fixOrientation;


/**
 二维码图片
 @return CIImage 对象
 */
+ (CIImage *)generateQRCodeImage:(NSString *)source;


/**
 *  生成条形码
 * *
 *  @return 生成条形码的CIImage对象
 */
+ (CIImage *) generateBarCodeImage:(NSString *)source;

/**
 *  调整生成的图片的大小
 *
 *  @param image CIImage对象
 *  @param size  需要的UIImage的大小
 *
 *  @return size大小的UIImage对象
 */
+ (UIImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size;

/**
 内部调用imageNamed，但返回的图片不能被着色（必定全色渲染）

 @param name 图片名称，参数同imageNamed
 @return 图片对象
 */
+ (UIImage *)imageWithRenderNamed:(NSString *)name;

/**
 是否有透明通道
 */
- (BOOL)hasAlpha;
/**
 创建一张有透明通道的图
 */
- (UIImage *)imageWithAlpha;

/**
   添加透明边界
 */
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;


/**
 生成一张圆角+边界的图片

 @param cornerSize 圆角大小
 @param borderSize 边界大小
 @return 目标图片
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;


NS_ASSUME_NONNULL_END

@end
