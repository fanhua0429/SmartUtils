//
//  SmartMacros.h
//  SMTCommon
//
//  Created by 廖超龙 on 2018/9/12.
//  Copyright © 2018年 pingan.inc. All rights reserved.
//

#ifndef SmartMacros_h
#define SmartMacros_h

// ---------------------------- 强弱引用转换  -------------------------------
//弱引用/强引用  可配对引用在外面用SCWeakSelf(self)，block用SCStrongSelf(self)  也可以单独引用在外面用SCWeakSelf(self) block里面用weakself
#define SMTWeakSelf(type)  __weak typeof(type) weak##type = type;
#define SMTStrongSelf(type)  __strong typeof(type) type = weak##type;

// ---------------------------- UI 开发常用   -------------------------------

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
// 屏幕倍数
#define kScreenScale    ([[UIScreen mainScreen] scale])

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}


// 奇数像素偏移
#define kOddPixelOffset (1.f / [[UIScreen mainScreen] scale]) / 2.f
// 真实屏幕和设计图的比例
#define kDesignScale ([UIScreen mainScreen].bounds.size.width / 375.f)
// 按比例设置数值,缩放
#define ScaleNumber(n) (kDesignScale * n)

#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE5   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)

// 获取Size中的较大值
#define MAX_LENGTH(size) (size.width > size.height ? size.width : size.height)

//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]
// 是否iPad
//#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kTabBarHeight (iPhoneX ? (isDevicePortrait ? 83.f : 53.f) : (isDevicePortrait ? 49.f : ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f ? 32.f : 49.f)))

//不同屏幕尺寸字体适配（375，667是因为效果图为IPHONE6 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (kScreenWidth / 375.0)
#define kScreenHeightRatio (kScreenHeight>=812.0? 667.0/667.0:kScreenHeight / 667.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
//#define AdaptedFontSize(R)     CHINESE_SYSTEM(R)
#define AdaptedHelveticaFontSize(R)     Helvetica_SYSTEM(R)


#define UNICODETOUTF16(x) (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000


//获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y


// MainScreen bounds
#define Main_Screen_Bounds [[UIScreen mainScreen] bounds]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    SYSTEMFONT(FONTSIZE)

// 判断当前设备是否是竖屏
#define isDevicePortrait ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
// 判断当前设备是否是横屏
#define isDeviceLandscape ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationLandscapeRight)
// ---------------------------- 空处理   -------------------------------
//字典取值
#define GetObjectFromDicWithKey(dictonary, key , Class) [[dictonary objectForKey:key] isKindOfClass:[Class class]] ? [dictonary objectForKey:key] : nil

// 是否空对象
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]
//对象取值
#define GetObject(id) (id == nil) ? @"" : id

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define kStringSkipEmpty(str)   kStringIsEmpty(str)? @"" : str
#define kDictionarySkipEmpty(dic) kDictIsEmpty(dic)? @{} : dic
#define kZeroSkipEmpty(str)   kStringIsEmpty(str)? @"0" : str

// ---------------------------- iPhoneX -- ----------------------------

// 判断当前设备是否是刘海屏，不只是iPhone X
#define iPhoneX ((NSInteger)MAX_LENGTH([UIScreen mainScreen].bounds.size) >= 812)
// iPhoneX 安全区域
#define kSafeAreaTop ((iPhoneX && isDevicePortrait) ? 44.f : 0.f)
#define kSafeAreaBottom ((iPhoneX && isDevicePortrait) ? 34.f : 0.f)
#define kSafeAreaLeft ((iPhoneX && isDeviceLandscape) ? 44.f : 0.f)
#define kSafeAreaRight ((iPhoneX && isDeviceLandscape) ? 44.f : 0.f)
// 减去状态栏高度的 kSafeAreaTop
#define kSafeAreaTopExcept20pt ((kSafeAreaTop > 0) ? (kSafeAreaTop - 20.f) : 0.f)

// 状态栏高度 ---------------------------
#define kNaviBarHeight (iPhoneX ? (isDevicePortrait ? 88.f : 32.f) : (isDevicePortrait ? 64.f : 32.f))
// 地底部分栏高度
#define kTabBarHeight (iPhoneX ? (isDevicePortrait ? 83.f : 53.f) : (isDevicePortrait ? 49.f : ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f ? 32.f : 49.f)))
// 状态栏高度
#define kStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)

// -----------------------------  版本  --------------------------- 
#define ISIOS(A)        @available(iOS A, *) //a以上版本
// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])
// 机器型号(e.g. iPhone 8 Plus)
#define kCurrentModel           ([UIDevice currentDevice].machineModel)
// 是否大于等于IOS8
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
// 是否大于IOS9
#define isIOS9                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=9.0)
// 是否大于等于指定的iOS版本
#define isLater_iOS(v)    ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)

// -----------------------------  文件访问  --------------------------- 
//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// Library文件夹路径
#define kLibraryDirectoryPath ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject])
// Document文件夹路径
#define kDocumentDirectoryPath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

// -----------------------------  字符串格式化  --------------------------- 
#define StringWithFormat(FORMAT, ...) [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]
#define StringWithFloat(A) [NSString stringWithFormat:@"%f", A]
#define StringWithInt(A) [NSString stringWithFormat:@"%i", A]
#define StringWithStr(A) (A == nil) ? @"" : A

// -----------------------------   其它  ---------------------------

// 获得NSUrl对象
#define URLWithString(str) [NSURL URLWithString:str]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// 其他
#define GetLocationImage(imageName) [UIImage imageNamed:imageName]

// -----------------------------   颜色  ---------------------------

#define ColorRandom RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1.0)
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)
#define HEXCOLOR(hex)   RGB((float)((hex & 0xFF0000) >> 16), (float)((hex & 0xFF00) >> 8), (float)(hex & 0xFF))
#define HEXACOLOR(hex,a) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16))/255.0 green:((float)(((hex) & 0xFF00)>>8))/255.0 blue: ((float)((hex) & 0xFF))/255.0 alpha:(a)]



#endif /* SmartMacros_h */
