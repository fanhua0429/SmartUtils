//
//  PermissionManager.m
//  iCarRepair
//
//  Created by 林杜波 on 2017/12/22.
//  Copyright © 2017年 PingAn. All rights reserved.
//

#import "PermissionManager.h"
#import "UIAlertController+convience.h"
#import "SMTAlertView.h"

/// 蜂窝网络数据权限改变通知
NSString * const kSMTCellularDataPermissionDidChangedNotification = @"kSMTCellularDataPermissionDidChangedNotification";


@interface PermissionManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, copy) void(^finishPickImageHandler)(UIImage *image);
@property (nonatomic, assign) BOOL shouldSaveImage;
@property (nonatomic, copy) void (^locationSuccess)(void);
@property (nonatomic, copy) void (^locationFailure)(CLAuthorizationStatus);

@property (nonatomic, strong) id cellularData;

@end

@implementation PermissionManager

+ (PermissionManager *)sharedInstaceDispose:(BOOL)dispose
{
    static PermissionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PermissionManager alloc] init];
    });
    if (dispose) {
        instance = nil;
        onceToken = 0;
    }
    return instance;
}

+ (PermissionManager *)sharedInstace {
    return [self sharedInstaceDispose:NO];
}

+ (void)dispose {
    [self sharedInstaceDispose:YES];
}

+ (UIViewController *)appRootController {
    UIViewController *root = [[UIApplication sharedApplication].delegate window].rootViewController;
    return root;
}

// 开始监听蜂窝网络数据权限变化
+ (void)startMonitorCellularDataPermissionChanged {
    
    if (@available(iOS 9, *)) {
        ((CTCellularData *)[self sharedInstace].cellularData).cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            [NSNotificationCenter.defaultCenter postNotificationName:kSMTCellularDataPermissionDidChangedNotification object:@(state) userInfo:@{@"CTCellularDataRestrictedState": @(state)}];
            
            if (state == kCTCellularDataNotRestricted) {
                [PermissionManager stopMonitorCellularDataPermissionChanged];
            }
        };
    }
}

// 停止监听蜂窝网络数据权限变化
+ (void)stopMonitorCellularDataPermissionChanged {
    [self sharedInstace].cellularData = nil;
}

+ (CTCellularDataRestrictedState)cellularDataRestrictedState {
    
    if (@available(iOS 9, *)) {
        return [(CTCellularData *)[self sharedInstace].cellularData restrictedState];
    } else {
        return kCTCellularDataNotRestricted;
    }
}

+ (void)defaultRequestCameraPermissionOnSuccess:(void (^)(void))success {
    [self requestCameraPermissionOnSuccess:success failure:[self defaultCameraRefuseAction]];
}

+ (void)requestCameraPermissionOnSuccess:(void(^)(void))success failure:(void(^)(AVAuthorizationStatus sts))failure {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (failure) {
            failure(authStatus);
        }
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (success) {
                        success();
                    }
                }
                else {
                    if (failure) {
                        failure(AVAuthorizationStatusDenied);
                    }
                }
            });
        }];
    }
    else {
        if (success) {
            success();
        }
    }
}

+ (void)defaultRequestPhotoLibraryPermissionOnSuccess:(void (^)(void))success {
    [self requestPhotoLibraryPermissionOnSuccess:success failure:[self defaultPhotoLibraryRefuseAction]];
}

+ (void)requestPhotoLibraryPermissionOnSuccess:(void(^)(void))success failure:(void(^)(PHAuthorizationStatus sts))failure {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestPhotoLibraryPermissionOnSuccess:success failure:failure];
            });
        }];
    }
    else if (status == PHAuthorizationStatusAuthorized) {
        if (success) {
            success();
        }
    }
    else {
        if (failure) {
            failure(status);
        }
    }
}

+ (void)defaultRequestLocationPermissionWhenInUse:(BOOL)onlyWhenInUse success:(void(^)(void))success {
    [self requestLocationPermissionWhenInUse:onlyWhenInUse success:success failre:[self defaultLocationRefuseAction]];
}

+ (void)requestLocationPermissionWhenInUse:(BOOL)onlyWhenInUse success:(void(^)(void))success failre:(void(^)(CLAuthorizationStatus status))failure {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        PermissionManager *pm = [self sharedInstace];
        pm.locationSuccess = success;
        pm.locationFailure = failure;
        CLLocationManager *lm = [CLLocationManager new];
        lm.delegate = pm;
        if (@available(iOS 8, *)) {
            if (onlyWhenInUse) {
                [lm requestWhenInUseAuthorization];
            } else {
                [lm requestAlwaysAuthorization];
            }
        } else {
            [lm startUpdatingHeading]; // call any api to trigger the warning dialog
        }
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (success) {
            success();
        }
    }
    else {
        if (failure) {
            failure(status);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (self.locationSuccess) {
            self.locationSuccess();
        } else {
            if (self.locationFailure) {
                self.locationFailure(status);
            }
        }
    }
    manager.delegate = nil;
    [PermissionManager dispose];
}

#pragma mark - Default Actions
+ (void(^)(PHAuthorizationStatus status))defaultPhotoLibraryRefuseAction {
    void(^action)(PHAuthorizationStatus status) = ^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SMTAlertView *alertView = [[SMTAlertView alloc]initWithTitle:@"无法访问相册" content:@"请在iPhone的""设置-隐私-相册""中允许访问相册" cancelTitle:@"取消" confirmTitle:@"设置" cancelHandler:^{} confirmHandler:^{
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (url && [app canOpenURL:url]) {
                    [app openURL:url];
                }
            }];
            [alertView showInWindow];
        });
    };
    return action;
}

+ (void(^)(AVAuthorizationStatus status))defaultCameraRefuseAction {
    void(^action)(AVAuthorizationStatus status) = ^(AVAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // @"prefs:root=com.test.myApp" use this to jump to App setting, needs prefs scheme in Info.plist
            SMTAlertView *alertView = [[SMTAlertView alloc]initWithTitle:@"无法使用相机" content:@"请在iPhone的""设置-隐私-相机""中允许访问相机" cancelTitle:@"取消" confirmTitle:@"设置" cancelHandler:^{} confirmHandler:^{
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (url && [app canOpenURL:url]) {
                    [app openURL:url];
                }
            }];
            [alertView showInWindow];
        });
    };
    return action;
}

+ (void (^)(CLAuthorizationStatus))defaultLocationRefuseAction {
    void(^action)(CLAuthorizationStatus status) = ^(CLAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SMTAlertView *alertView = [[SMTAlertView alloc]initWithTitle:@"无法使用定位服务" content:@"请在iPhone的""设置-隐私-定位服务""中允许使用定位服务" cancelTitle:@"取消" confirmTitle:@"设置" cancelHandler:^{} confirmHandler:^{
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (url && [app canOpenURL:url]) {
                    [app openURL:url];
                }
            }];
            [alertView showInWindow];
        });
    };
    return action;
}


#pragma mark - Getter

- (id)cellularData {
    
    if (@available(iOS 9, *)) {
        
        if (_cellularData == nil) {
            _cellularData = [[CTCellularData alloc] init];
        }
        return _cellularData;
        
    } else {
        return nil;
    }
}


@end
