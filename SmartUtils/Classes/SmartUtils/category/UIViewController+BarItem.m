//
//  UIViewController+BarItem.m
//  PAOFWeb
//
//  Created by 罗俊宇 on 2017/5/9.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import "UIViewController+BarItem.h"

typedef NS_ENUM(NSInteger, PAOFItemSide) {
    PAOFItemSideLeft,
    PAOFItemSideRight
};

@implementation UIViewController (BarItem)

- (void)createTitleViewWithImageName:(NSString *)imageName
{
    
    UIImageView *titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    titleImgView.frame = CGRectMake(0, 0, titleImgView.image.size.width, titleImgView.image.size.height);
    self.navigationItem.titleView = titleImgView;
}

- (UIBarButtonItem *)createLeftItemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage selector:(SEL)selector
{
    return [self crateItemWithTitle:nil imageName:imageName highlightedImage:nil selectedImage:selectedImage inTheSide:PAOFItemSideLeft selector:selector];
}


- (UIBarButtonItem *)createLeftItemWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage selector:(SEL)selector
{
    return [self crateItemWithTitle:nil imageName:imageName highlightedImage:highlightedImage selectedImage:nil inTheSide:PAOFItemSideLeft selector:selector];
}

- (UIBarButtonItem *)createRightItemWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage selector:(SEL)selector
{
    return [self crateItemWithTitle:nil imageName:imageName highlightedImage:highlightedImage selectedImage:nil inTheSide:PAOFItemSideRight selector:selector];
}

- (UIBarButtonItem *)createRightItemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage selector:(SEL)selector
{
    return [self crateItemWithTitle:nil imageName:imageName highlightedImage:nil selectedImage:selectedImage inTheSide:PAOFItemSideRight selector:selector];
}

- (UIBarButtonItem *)createLeftItemWithTitle:(NSString *)title selector:(SEL)selector
{
    return [self crateItemWithTitle:title imageName:nil highlightedImage:nil selectedImage:nil inTheSide:PAOFItemSideLeft selector:selector];
}

- (UIBarButtonItem *)createRightItemWithTitle:(NSString *)title selector:(SEL)selector
{
    return [self crateItemWithTitle:title imageName:nil highlightedImage:nil selectedImage:nil inTheSide:PAOFItemSideRight selector:selector];
}

- (UIBarButtonItem *)crateItemWithTitle:(NSString *)title imageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage selectedImage:(NSString *)selectedImage inTheSide:(PAOFItemSide)itemSide selector:(SEL)selector
{
    UIButton *button = [[UIButton alloc] init];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(1000, 44.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
        CGFloat buttonWidth = 0;
        if (size.width > 90) {
            buttonWidth = 90;
        } else if (size.width < 44) {
            buttonWidth = 44;
        } else {
            buttonWidth = size.width;
        }
        button.frame = CGRectMake(0, 0, buttonWidth, 44);
    } else if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if (highlightedImage) {
            [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
        } else {
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        }
        button.frame = CGRectMake(0, 0, button.imageView.image.size.width, button.imageView.image.size.height);
        button.contentMode = UIViewContentModeScaleAspectFit;
        if (selectedImage) {
            [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        }
    }
    
    if (selector) {
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (itemSide == PAOFItemSideRight) {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }

    return barButtonItem;
}

- (void)removeRightItem
{
    self.navigationItem.rightBarButtonItem = nil;
}




@end
