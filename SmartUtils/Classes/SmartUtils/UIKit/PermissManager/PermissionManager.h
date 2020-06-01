//
//  PermissionManager.h
//  iCarRepair
//
//  Created by 林杜波 on 2017/12/22.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCellularData.h>


/// 蜂窝网络数据权限改变通知
extern NSString * const kSMTCellularDataPermissionDidChangedNotification;


@interface PermissionManager : NSObject

// 蜂窝网络数据权限监听，如果权限变化，会发送 `kSMTCellularDataPermissionDidChangedNotification` 通知，iOS9之后有效
// 在 notification.userInfo 中通过 key: @"CTCellularDataRestrictedState" 获取状态值
+ (void)startMonitorCellularDataPermissionChanged;
+ (void)stopMonitorCellularDataPermissionChanged;

/** 获取当前蜂窝网络数据权限 */
+ (CTCellularDataRestrictedState)cellularDataRestrictedState;

// 相机权限
+ (void)defaultRequestCameraPermissionOnSuccess:(void(^)(void))success;
+ (void)requestCameraPermissionOnSuccess:(void(^)(void))success failure:(void(^)(AVAuthorizationStatus status))failure;

// 相册权限
+ (void)defaultRequestPhotoLibraryPermissionOnSuccess:(void(^)(void))success;
+ (void)requestPhotoLibraryPermissionOnSuccess:(void(^)(void))success failure:(void(^)(PHAuthorizationStatus status))failure;

// 定位权限
+ (void)defaultRequestLocationPermissionWhenInUse:(BOOL)onlyWhenInUse success:(void(^)(void))success;
+ (void)requestLocationPermissionWhenInUse:(BOOL)onlyWhenInUse success:(void(^)(void))success failre:(void(^)(CLAuthorizationStatus status))failure;

/// 默认用户拒绝授权活动
+ (void(^)(AVAuthorizationStatus status))defaultCameraRefuseAction;
+ (void(^)(PHAuthorizationStatus status))defaultPhotoLibraryRefuseAction;
+ (void(^)(CLAuthorizationStatus status))defaultLocationRefuseAction;

@end
