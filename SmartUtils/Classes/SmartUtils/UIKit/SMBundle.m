//
//  SMBundle.m
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/8.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#import "SMBundle.h"

@implementation SMBundle
+ (NSBundle *)bundleWithName:(NSString *)bundleName {
    if(bundleName.length == 0) {
        return nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    return  [NSBundle bundleWithPath:path];
}

+ (NSBundle *)bundle {
    return [NSBundle mainBundle];
}

+ (NSString *)storyboardName {
    return nil;
}

+ (UIView *)viewWithXibFileName:(NSString *)fileName {
    return [SMBundle viewWithXibFileName:fileName inBundle:[self.class bundle]];
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    return [SMBundle imageNamed:imageName inBundle:[self.class bundle]];
}

+ (UIStoryboard *)storyboardWithName:(NSString *)storyboardName {
    return [SMBundle storyboardWithName:storyboardName inBundle:[self.class bundle]];
}

+ (UINib *)nibWithName:(NSString *)nibName {
    return [SMBundle nibWithNibName:nibName inBundle:[self.class bundle]];
}

+ (UIViewController *)viewControllerWithName:(NSString *)viewControllerName {
    return [self viewControllerWithStoryboardName:[self.class storyboardName] viewControllerName:viewControllerName];
}

+ (UIViewController *)viewControllerWithStoryboardName:(NSString *)storyboardName viewControllerName:(NSString *)viewControllerName {
    if(viewControllerName.length == 0) {
        return nil;
    }
    if(storyboardName.length == 0) {
        return [[self storyboardWithName:[self.class storyboardName]] instantiateViewControllerWithIdentifier:viewControllerName];
    }
    return [[self storyboardWithName:storyboardName] instantiateViewControllerWithIdentifier:viewControllerName];
}

+ (UIViewController *)viewControllerWithStoryboardName:(NSString *)storyboardName viewControllerName:(NSString *)viewControllerName bundle:(NSString *)bundle{
    if(viewControllerName.length == 0) {
        return nil;
    }
    if(storyboardName.length == 0) {
        return [[self storyboardWithName:[self.class storyboardName]] instantiateViewControllerWithIdentifier:viewControllerName];
    }
    return [[self storyboardWithName:storyboardName] instantiateViewControllerWithIdentifier:viewControllerName];
}

#pragma mark - private method
+ (UIImage *)imageNamed:(NSString *)imgaeName inBundle:(NSBundle *)bundle {
    if(imgaeName.length == 0 || !bundle) {
        return nil;
    }
    return [UIImage imageNamed:imgaeName inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName {
    return [self imageNamed:imageName inBundle:[self bundleWithName:bundleName]];
}

+ (UIView *)viewWithXibFileName:(NSString *)fileName inBundle:(NSBundle *)bundle {
    if(fileName.length == 0 || !bundle) {
        return nil;
    }
    //如果没有国际化，则直接去相应内容下的文件
    UIView *xibView = [[bundle loadNibNamed:fileName owner:nil options:nil] lastObject];
    if(!xibView) {
        //文件国际化之后，所有的bundle的文件资源都在base的目录下
        xibView = [[[NSBundle bundleWithPath:[bundle pathForResource:@"Base" ofType:@"lproj"]] loadNibNamed:fileName owner:nil options:nil] lastObject];
    }
    return xibView;
}

+ (UIView *)viewWithXibFileName:(NSString *)fileName bundleName:(NSString *)bundleName {
    return [self viewWithXibFileName:fileName inBundle:[self bundleWithName:bundleName]];
}
+ (UIStoryboard *)storyboardWithName:(NSString *)storyboardName inBundle:(NSBundle *)bundle {
    if(storyboardName.length == 0 || !bundle) {
        return nil;
    }
    return [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
}

+ (UIStoryboard *)storyboardWithName:(NSString *)storyboardName bundleName:(NSString *)bundleName {
    return [self storyboardWithName:storyboardName inBundle:[self bundleWithName:bundleName]];
}

+ (UINib *)nibWithNibName:(NSString *)nibName inBundle:(NSBundle *)bundle {
    if(nibName.length == 0 || !bundle ) {
        return nil;
    }
    return [UINib nibWithNibName:nibName bundle:bundle];
}


@end
