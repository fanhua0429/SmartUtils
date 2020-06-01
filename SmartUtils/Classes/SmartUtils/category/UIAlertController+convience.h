//
//  UIAlertController+convience.h
//  iCarRepair
//
//  Created by 林杜波 on 2017/12/11.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIAlertController (convience)

/// Alert with confirm action, present with default confirm title @"确认" and no cancel item
+ (void)defaultAletWithTitle:(nullable NSString *)title
                         msg:(nullable NSString *)msg
        presentingController:(UIViewController *)controller
               confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction;


/// Alert with confirm and cancel action config only, present with default confirm title @"确认" and default cancel title @"取消"
+ (void)optionAletWithTitle:(nullable NSString *)title
                        msg:(nullable NSString *)msg
       presentingController:(UIViewController *)controller
              confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction
               cancelAction:(nullable void(^)(UIAlertAction * _Nullable action))cancelAction;

/// Alert with confirm config only
+ (void)confirmAlertWithTitle:(nullable NSString *)title
                          msg:(nullable NSString *)msg
         presentingController:(UIViewController *)controller
                 confirmTitle:(nullable NSString *)confirmTitle
                confirmAction:(void(^)(UIAlertAction * _Nullable action))confirmAction;


/// Alert with confirm and cancel config
+ (void)alertWithTitle:(nullable NSString *)title
                   msg:(nullable NSString *)msg
  presentingController:(UIViewController *)controller
          confirmTitle:(nullable NSString *)confirmTitle
         confirmAction:(nullable void(^)(UIAlertAction * _Nullable action))confirmAction
           cancelTitle:(nullable NSString *)cancelTitle
          cancelAction:(nullable void(^)(UIAlertAction * _Nullable action))cancelAction;



+ (void)actionSheetWithTitle:(nullable NSString *)title
                         msg:(nullable NSString *)msg
        presentingController:(UIViewController *)controller
            firstActionTitle:(nullable NSString *)firstTitle
                 firstAction:(nullable void(^)(UIAlertAction * _Nullable action))firstAction
           secondActionTitle:(nullable NSString *)secondTitle
                secondAction:(nullable void(^)(UIAlertAction * _Nullable action))secondAction;

@end
NS_ASSUME_NONNULL_END
