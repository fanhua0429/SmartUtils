//
//  SMBundle.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/8.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SMBundle : NSBundle
/*
 * 根据bundle的名称获取bundle
 */
+ (NSBundle *)bundleWithName:(NSString *)bundleName;

//获取bundle 每次只要重写这个方法就可以在指定的bundle中获取对应资源
+ (NSBundle *)bundle;

//指定的storyboard的名称
+ (NSString *)storyboardName;
//根据xib文件名称获取xib文件
+ (UIView *)viewWithXibFileName:(NSString *)fileName;

//根据图片名称获取图片
+ (UIImage *)imageNamed:(NSString *)imageName;

//根据sb文件名称获取对应sb文件
+ (UIStoryboard *)storyboardWithName:(NSString *)storyboardName;

//获取nib文件
+ (UINib *)nibWithName:(NSString *)nibName;

//获取指定的viewController
+ (UIViewController *)viewControllerWithName:(NSString *)viewControllerName;

//获取指定的ViewController
+ (UIViewController *)viewControllerWithStoryboardName:(NSString *)storyboardName viewControllerName:(NSString *)viewControllerName;
//从指定的bundle中获取xib文件
+ (UIView *)viewWithXibFileName:(NSString *)fileName inBundle:(NSBundle *)bundle;

//从指定的bundle中获取image文件
+ (UIImage *)imageNamed:(NSString *)imgaeName inBundle:(NSBundle *)bundle;
@end
