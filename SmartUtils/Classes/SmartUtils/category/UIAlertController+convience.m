//
//  UIAlertController+convience.m
//  iCarRepair
//
//  Created by 林杜波 on 2017/12/11.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import "UIAlertController+convience.h"

@implementation UIAlertController (convience)

+ (void)defaultAletWithTitle:(nullable NSString *)title
                         msg:(nullable NSString *)msg
        presentingController:(UIViewController *)controller
               confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction {
    return[self confirmAlertWithTitle:title msg:msg presentingController:controller confirmTitle:@"确认" confirmAction:confirmAction];
}

+ (void)optionAletWithTitle:(nullable NSString *)title
                         msg:(nullable NSString *)msg
        presentingController:(UIViewController *)controller
               confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction
               cancelAction:(nullable void(^)(UIAlertAction * _Nullable action))cancelAction{
    return [self alertWithTitle:title msg:msg presentingController:controller confirmTitle:@"确认" confirmAction:confirmAction cancelTitle:@"取消" cancelAction:cancelAction];
}

+ (void)confirmAlertWithTitle:(nullable NSString *)title
                          msg:(nullable NSString *)msg
         presentingController:(UIViewController *)controller
                 confirmTitle:(nullable NSString *)confirmTitle
                confirmAction:(void(^)(UIAlertAction * _Nullable action))confirmAction {
    [self alertWithTitle:title msg:msg presentingController:controller confirmTitle:confirmTitle confirmAction:confirmAction cancelTitle:nil cancelAction:nil];
}

+ (void)alertWithTitle:(nullable NSString *)title
                   msg:(nullable NSString *)msg
  presentingController:(UIViewController *)controller
          confirmTitle:(nullable NSString *)confirmTitle
         confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction
           cancelTitle:(nullable NSString *)cancelTitle
          cancelAction:(nullable void(^)(UIAlertAction * _Nullable action))cancelAction {
    
    NSAssert(controller != nil, @"A presenting controll is needed");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle || cancelAction) {
        if (!cancelAction) {
            cancelAction = ^(UIAlertAction *action){};
        }
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelAction];
        [alert addAction:cancel];
    }
    
    if (confirmTitle || confirmAction) {
        if (!confirmAction) {
            confirmAction = ^(UIAlertAction *action){};
        }
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmAction];
        [alert addAction:confirm];
    }

    
    [controller presentViewController:alert animated:YES completion:nil];
    
}

+ (void)actionSheetWithTitle:(nullable NSString *)title
                         msg:(nullable NSString *)msg
        presentingController:(UIViewController *)controller
            firstActionTitle:(nullable NSString *)firstTitle
                 firstAction:(nullable void(^)(UIAlertAction * _Nullable action))firstAction
           secondActionTitle:(nullable NSString *)secondTitle
                secondAction:(nullable void(^)(UIAlertAction * _Nullable action))secondAction
{
    NSAssert(controller != nil, @"A presenting controll is needed");
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (firstTitle && firstAction) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:firstAction];
        [sheet addAction:action];
    }
    
    if (secondTitle && secondAction) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:secondAction];
        [sheet addAction:action];
    }
    
    [controller presentViewController:sheet animated:YES completion:nil];
}

@end
