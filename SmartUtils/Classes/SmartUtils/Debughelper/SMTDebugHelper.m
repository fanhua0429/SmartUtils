//
//  SMTDebugHelper.m
//  SMT-NT-iOS
//
//  Created by 莫冰(平安科技智慧政务团队) on 2018/4/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

#import "SMTDebugHelper.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#import <objc/message.h>
#else
#import <objc/objc-class.h>
#endif
//#import "SMTAppDelegate.h"
#import <mach/mach.h>
#import "UIView+SmartUtils.h"
#import "UIColor+SmartUtils.h"

#if DEBUG
vm_size_t usedMemory(void){
    struct task_basic_info info;
    mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (host_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pageSize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pageSize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pageSize;
}

NSString *logMemUsage(void) {
    @autoreleasepool {
        // compute memory usage and log if different by >= 100k
        static long prevMemUsage = 0;
        long curMemUsage = usedMemory();
        long memUsageDiff = curMemUsage - prevMemUsage;
        
        prevMemUsage = curMemUsage;
        
        CGFloat logUsageMem = curMemUsage / 1024.0f;
        CGFloat logDiffMem = memUsageDiff / 1024.0f;
        CGFloat logFreeMem = freeMemory() / 1024.0f;
        
        NSString *log = [NSString stringWithFormat:@"内存使用 %.2f MB(%7.1f kb (%+5.0fkb)), 剩余 %.2f MB(%7.1f kb)", logUsageMem / 1024.0f, logUsageMem, logDiffMem, logFreeMem / 1024.0f, logFreeMem];
        return log;
    }
}

#endif


static char kEx_Object_SMT;

@implementation NSObject (SMTDebugHelper)

- (void)setExObject:(NSObject *)exObject
{
    objc_setAssociatedObject(self, &kEx_Object_SMT, exObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *)exObject
{
    return objc_getAssociatedObject(self, &kEx_Object_SMT);
}

- (NSString *)nameWithInstance:(id)instatnce
{
    unsigned int numIvars = 0;
    NSString *key = nil;
    for (Class class = self.class; (class != nil && key == nil); class = class.superclass) {
        Ivar *ivars = class_copyIvarList(class, &numIvars);
        for (int i = 0; i < numIvars; i++) {
            Ivar thisIvar = ivars[i];
            const char *type = ivar_getTypeEncoding(thisIvar);
            NSString *stringType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
            //过滤掉其他不需要的
            if (![stringType hasPrefix:@"@"] || [stringType isEqualToString:@"@\"NSIndexPath\""] || ([stringType rangeOfString:@"<"]).location != NSNotFound) {
                continue;
            }
            if ((object_getIvar(self, thisIvar) == instatnce)) {
                key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
                break;
            }
        }
        free(ivars);
    }
    return key;
}
@end


static SMTDebugHelper *globalInstance = nil;
@interface SMTDebugHelper ()
{
    BOOL _debug;
}

@property (nonatomic, strong) NSDictionary *testDic;
@property (nonatomic, strong) UILabel *longPressLabel;
@property (nonatomic, strong) NSString *debugInfoPath;
@property (nonatomic, weak) UIView *lastView;
@property (nonatomic, strong) CAGradientLayer *borderLayer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *doubleFingerLongPressGR;
@property (nonatomic, strong) UITextView *logView;
@property (nonatomic, strong) UIView *windowMainView;
@property (nonatomic, strong) NSString *logPath;

@end

#define kTagDebugLongPress 849941
#define kTagDebugDoubleFingerLongPress 843942
#define THEWINDOW ([UIApplication sharedApplication].keyWindow ?: ([[UIApplication sharedApplication] windows].count > 0 ? [[UIApplication sharedApplication] windows][0] : nil))
#define DEEP

@implementation SMTDebugHelper

+ (SMTDebugHelper *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalInstance = [[SMTDebugHelper alloc] init];
#ifdef DEBUG
        [globalInstance initLogDebuger];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        NSArray *path = [[paths objectAtIndex:0] componentsSeparatedByString:@"/"];
        NSString *desktopPath = [[[path[1] stringByAppendingPathComponent:path[2]] stringByAppendingPathComponent:@"Destop"] stringByAppendingPathComponent:@"debugHelper.txt"];
        desktopPath = [@"/" stringByAppendingString:desktopPath];
        globalInstance.debugInfoPath = desktopPath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:desktopPath]) {
            globalInstance.needLog = YES;
        }
#endif
    });
    return globalInstance;
}

+ (void)setup
{
#ifdef DEBUG
    //NSLog(@"沙盒路径:%@", NSHomeDirectory());
    [[self sharedInstance] setDebug:YES];
#endif
}


- (void)initLogDebuger
{
    //真机时将log输出到文件
    if (!globalInstance.logPath) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        path = [path stringByAppendingPathComponent:@"log"];
        globalInstance.logPath = path;
    }
    if (!isatty(STDERR_FILENO)) {
        NSString *path = globalInstance.logPath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        freopen([path cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
    }
 
}

- (void)setDebug:(BOOL)debug
{
    _debug = debug;
    if (_debug) {
        if (!_longPressGR) {
            UILongPressGestureRecognizer *gestureOneFinger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(debugLongPressed:)];
            gestureOneFinger.exObject = @(kTagDebugLongPress);
            self.longPressGR = gestureOneFinger;
        }
        if (!_doubleFingerLongPressGR) {
            UILongPressGestureRecognizer *gestureDoubleFinger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(debugDoubleFingerLongPressed:)];
            gestureDoubleFinger.numberOfTouchesRequired = 2;
            gestureDoubleFinger.exObject = @(kTagDebugDoubleFingerLongPress);
            self.doubleFingerLongPressGR = gestureDoubleFinger;
        }
        
        [THEWINDOW addGestureRecognizer:_longPressGR];
        [THEWINDOW addGestureRecognizer:_doubleFingerLongPressGR];
    } else {
        [THEWINDOW removeGestureRecognizer:_longPressGR];
        [THEWINDOW removeGestureRecognizer:_doubleFingerLongPressGR];
        
    }
    
}

- (void)debugLongPressed:(UILongPressGestureRecognizer *)recognizer
{
    @autoreleasepool {
        UIEvent * event = [[UIEvent alloc] init];
        UIEvent * touchEvent = (UIEvent *)[[event touchesForGestureRecognizer:recognizer] anyObject];
        CGPoint fingerPoint = [recognizer locationInView:THEWINDOW];
        UIView *view = [THEWINDOW hitTest:fingerPoint withEvent:touchEvent];
        for (UIView *subView in view.subviews) {
#ifdef DEEP
            if ([subView pointInside:[recognizer locationInView:subView] withEvent:touchEvent])
#else
                if ([subView pointInside:[recognizer locationInView:subView] withEvent:touchEvent] && subView.userInteractionEnabled)
#endif
                {
                    view = subView;
                    break;
                }
        }
        if (view != _lastView) {
            self.lastView = view;
            UIViewController *topController = [SMTDebugHelper topMostController];
            UILabel *label = self.longPressLabel;
            if (recognizer.state != UIGestureRecognizerStateCancelled && recognizer.state != UIGestureRecognizerStateEnded) {
                CGRect frameBottom = CGRectMake(0, THEWINDOW.bounds.size.height - 80, THEWINDOW.bounds.size.width, 80);
                CGRect frameUp = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, THEWINDOW.bounds.size.width, 80);
                if (!label) {
                    label = [[UILabel alloc] initWithFrame:CGRectZero];
                    label.font = [UIFont systemFontOfSize:14.0];
                    label.tag = kTagDebugLongPress;
                    label.adjustsFontSizeToFitWidth = YES;
                    label.numberOfLines =10;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.backgroundColor = [UIColor lightGrayColor];
                    label.layer.borderColor = [UIColor grayColor].CGColor;
                    label.layer.borderWidth = 0.5;
                    label.frame = frameBottom;
                    if (fingerPoint.y > [UIScreen mainScreen].bounds.size.height * 0.85) {
                        [label setFrame:frameUp];
                    }
                    if (fingerPoint.y < [UIScreen mainScreen].bounds.size.height * 0.15) {
                        [label setFrame:frameBottom];
                    }
                    self.longPressLabel = label;
                }
                if (!_borderLayer) {
                    self.borderLayer = [self createGradientBorderLayer];
                }
                [UIView animateWithDuration:0.2 animations:^{
                    if (fingerPoint.y > [UIScreen mainScreen].bounds.size.height * 0.85) {
                        [label setFrame:frameUp];
                    }
                    if (fingerPoint.y < [UIScreen mainScreen].bounds.size.height * 0.15) {
                        [label setFrame:frameBottom];
                    }
                }];
                __block NSString *varName = [topController nameWithInstance:view];
                __block NSString *varNameSuper = [topController nameWithInstance:view.superview];
                if (!varNameSuper) {
                    varNameSuper = [NSString stringWithFormat:@"%p", view.superview];
                }
                if (!varName) {
                    varName = [NSString stringWithFormat:@"%p", view];
                }
                
                NSString *tipSuper = [NSString stringWithFormat:@"(Super)<%@,%@>: %@", NSStringFromClass(view.superview.class), varNameSuper, StringFromCGRect(view.superview.frame)];
                NSString *tip = [NSString stringWithFormat:@"<%@,%@>: %@", NSStringFromClass(view.class), varName, StringFromCGRect(view.frame)];
                tip = [tip stringByAppendingString:[self detailMessageWithView:view]];
                tipSuper = [tipSuper stringByAppendingString:[self detailMessageWithView:view.superview]];
                UIViewController *controller = [view viewController];
                NSString *parentViewController = @"";
                if (controller) {
                    parentViewController = [NSString stringWithFormat:@"%@\n", NSStringFromClass(controller.class)];
                }
#ifdef DEBUG
                label.text = [NSString stringWithFormat:@"%@%@\n%@\n%@", parentViewController, tip, tipSuper, logMemUsage()];
#else
                label.text = [NSString stringWithFormat:@"%@%@\n%@\n", parentViewController, tip, tipSuper];
#endif
                if (_needLog) {
                    [label.text writeToFile:_debugInfoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
                [THEWINDOW addSubview:label];
                CGPoint point = [view.superview convertPoint:view.frame.origin toView:nil];
                CGRect theFrame = CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height);
                [_borderLayer setFrame:theFrame];
                [_borderLayer setBounds:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                [_borderLayer.mask setFrame:_borderLayer.bounds];
                [_borderLayer.mask setBounds:_borderLayer.bounds];
                [THEWINDOW.layer addSublayer:_borderLayer];
            } else {
                [label removeFromSuperview];
                [_borderLayer removeFromSuperlayer];
                self.borderLayer = nil;
            }
        }
        if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed) {
            self.lastView = nil;
            UILabel *label = self.longPressLabel;
            [label removeFromSuperview];
            [_borderLayer removeFromSuperlayer];
            self.borderLayer = nil;
        }
    }
}

- (void)debugDoubleFingerLongPressed:(UILongPressGestureRecognizer *)recognizer
{
    @autoreleasepool {
        UIWindow *window = THEWINDOW;
        static BOOL open;
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            if (!_logView) {
                if (window.subviews.count > 0) {
                    self.windowMainView = window.subviews[0];
                }
                UITextView *logView = [[UITextView alloc] initWithFrame:(CGRect){{0, 20}, {window.frame.size.width, window.frame.size.height - 20}}];
                [logView setContentInset:UIEdgeInsetsZero];
                logView.backgroundColor = [UIColor darkTextColor];
                logView.editable = NO;
                logView.textColor = UIRGBColor(0, 230, 16);
                logView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                [window addSubview:logView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshLogView)];
                self.logView = logView;
                [self.logView addGestureRecognizer:tap];
                
                UILongPressGestureRecognizer * gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(debugDoubleFingerLongPressed:)];
                gesture.numberOfTouchesRequired = 2;
                gesture.exObject = @(kTagDebugDoubleFingerLongPress);
                [self.logView addGestureRecognizer:gesture];
                
                [window sendSubviewToBack:_logView];
            }
            if (!open) {
                [self refreshLogView];
                open = YES;
                _logView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    [self->_windowMainView setFrame:CGRectMake(self->_windowMainView.frame.origin.x, self->_windowMainView.frame.size.height, self->_windowMainView.frame.size.width, self->_windowMainView.frame.size.height)];
                }];
            } else {
                open = NO;
                [UIView animateWithDuration:.3 animations:^{
                    [self->_windowMainView setFrame:CGRectMake(0, 0, self->_windowMainView.frame.size.width, self->_windowMainView.frame.size.height)];
                } completion:^(BOOL finished) {
                    self->_logView.hidden = YES;
                }];
            }
        }
        
    }
    
}

NSString *cFloatString(CGFloat f)
{
    NSString *str = nil;
    if (fmodf(f, 1) == 0) {
        str = [NSString stringWithFormat:@"%.0f", f];
    } else if (fmodf(f * 10, 1) == 0) {
        str = [NSString stringWithFormat:@"%.1f", f];
    } else {
        str = [NSString stringWithFormat:@"%.2f", f];
    }
    return str;
}

NSString *StringFromCGRect(CGRect rect)
{
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return NSStringFromCGRect(CGRectZero);
    } else {
        return [NSString stringWithFormat:@"{%@, %@, %@, %@}", cFloatString(rect.origin.x), cFloatString(rect.origin.y), cFloatString(rect.size.width), cFloatString(rect.size.height)];
    }
}


- (void)refreshLogView
{
    @autoreleasepool {
        NSString *content = [[NSString alloc] initWithContentsOfFile:_logPath encoding:NSUTF8StringEncoding error:nil];
        _logView.text = content;
        if (content.length > 0) {
            [_logView scrollRangeToVisible:NSMakeRange(content.length - 1, 1)];
        }
    }
}

+ (UIViewController *)topMostController
{
    UIViewController *topControlelr = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topControlelr.presentedViewController) {
        topControlelr = topControlelr.presentedViewController;
    }
    if ([topControlelr isKindOfClass:[UINavigationController class]]) {
        topControlelr = [(UINavigationController *)topControlelr topViewController];
    }
    return topControlelr;
}

+ (void)showMemoryUseage
{
#ifdef DEBUG
    NSLog(@"%@", logMemUsage());
#endif
}



- (CAGradientLayer *)createGradientBorderLayer
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.masksToBounds = YES;
    NSMutableArray *colorArray = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 5) {
        [colorArray addObject:(id)[UIColor colorWithHue:hue / 360.0 saturation:1 brightness:1 alpha:1].CGColor];
    }
    [gradientLayer setColors:colorArray];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.borderWidth = 1;
    gradientLayer.mask = maskLayer;
    CAKeyframeAnimation *animationStartPoint = [CAKeyframeAnimation animationWithKeyPath:@"startPoint"];
    animationStartPoint.duration = 2;
    animationStartPoint.repeatCount = HUGE_VALF;
    animationStartPoint.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                   [NSValue valueWithCGPoint:CGPointMake(1, 0)],
                                   [NSValue valueWithCGPoint:CGPointMake(1, 1)],
                                   [NSValue valueWithCGPoint:CGPointMake(0, 1)],
                                   [NSValue valueWithCGPoint:CGPointMake(0, 0)]
                                   ];
    CAKeyframeAnimation *animationEndPoint = [CAKeyframeAnimation animationWithKeyPath:@"endPoint"];
    animationEndPoint.duration = 2;
    animationEndPoint.repeatCount = HUGE_VALF;
    animationEndPoint.values = @[[NSValue valueWithCGPoint:CGPointMake(1, 1)],
                                   [NSValue valueWithCGPoint:CGPointMake(0, 1)],
                                   [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                   [NSValue valueWithCGPoint:CGPointMake(1, 0)],
                                   [NSValue valueWithCGPoint:CGPointMake(1, 1)]
                                   ];
    [gradientLayer addAnimation:animationStartPoint forKey:nil];
    [gradientLayer addAnimation:animationEndPoint forKey:nil];
    return gradientLayer;
}

- (NSString *)detailMessageWithView:(UIView *)view
{
    NSString *message = @"";
    if ([view isKindOfClass:[UIControl class]]) {
        UIButton *btn = (UIButton *)view;
        for (NSObject *target in btn.allTargets) {
            NSArray *actions = [btn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside
                                ];
            if (actions.count > 0) {
                message = [message stringByAppendingFormat:@"\nClick:[%@ %@]", NSStringFromClass(target.class), actions[0]];
            }
        }
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImage *image = [(UIImageView *)view image];
        if (image.accessibilityIdentifier) {
            message = [message stringByAppendingFormat:@"\nimageNamed: %@", image.accessibilityIdentifier];
        }
    }
    return message;
}




@end



@implementation UIView (ErgodicAndSetFrame)

- (void)ergodicSubviewsWithBlock:(BOOL (^)(UIView *))handler DeepLoop:(BOOL)deeploop
{
    for (UIView *view in self.subviews) {
        if (deeploop) {
            [view ergodicSubviewsWithBlock:handler DeepLoop:deeploop];
        }
        BOOL result = handler(view);
        if (result) {
            break;
        }
    }
    
}
@end


