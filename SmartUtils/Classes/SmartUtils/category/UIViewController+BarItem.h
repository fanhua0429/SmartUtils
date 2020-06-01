//
//  UIViewController+BarItem.h
//  PAOFWeb
//
//  Created by 罗俊宇 on 2017/5/9.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarItem)

- (void)createTitleViewWithImageName:(NSString *)imageName;

- (UIBarButtonItem *)createLeftItemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage selector:(SEL)selector;

- (UIBarButtonItem *)createRightItemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage selector:(SEL)selector;

- (UIBarButtonItem *)createLeftItemWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage selector:(SEL)selector;

- (UIBarButtonItem *)createRightItemWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage selector:(SEL)selector;

- (UIBarButtonItem *)createLeftItemWithTitle:(NSString *)title selector:(SEL)selector;

- (UIBarButtonItem *)createRightItemWithTitle:(NSString *)title selector:(SEL)selector;

- (void)removeRightItem;

@end
