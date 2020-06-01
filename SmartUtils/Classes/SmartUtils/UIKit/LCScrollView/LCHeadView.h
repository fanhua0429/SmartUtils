//
//  LCHeadView.h
//  Example
//  Created by 陈连辰 on 2018/6/11.
//  Copyright © 2018年 linechan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCHeadView : UIView

/// 子类重写获取offset方法
- (void)headViewDidScroll:(UIScrollView *)scrollview;

@end
