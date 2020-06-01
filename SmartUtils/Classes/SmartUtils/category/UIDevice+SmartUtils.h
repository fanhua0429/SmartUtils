//
//  UIDevice+SmartUtils.h
//  SmartUtils
//
//  Created by 凌代平 on 2018/5/4.
//Copyright © 2018年 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIDevice (SmartUtils)

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;

@property (nonatomic, readonly) BOOL isIphoneX;

/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;

/// Whether the device is jailbroken.
@property (nonatomic, readonly) BOOL isJailbroken;

/// Wherher the device can make phone calls.
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2" currentModel
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *machineModelName;

/// The System's startup time.
@property (nonatomic, readonly) NSDate *systemUptime;

/// Device system version (e.g. 8.1)
+ (double)systemVersion;

- (NSString *)platform;
- (NSString *)platformName;

+ (NSString *)appVersion;
- (NSString *)macAddress;
- (NSDictionary *)currentWifiInfo;

@end
NS_ASSUME_NONNULL_END
