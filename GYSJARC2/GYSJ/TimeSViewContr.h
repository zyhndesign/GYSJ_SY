//
//  TimeSViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeChangeDelegate.h"

@interface TimeSViewContr : UIViewController<UIScrollViewDelegate, TimeChangeDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UILabel *preTimeLb;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIView *maskView;
    BOOL delegateScroll;/////delegate滑动scrollview
    
    float scalePram;
    BOOL isScaling;
}
@property(nonatomic, weak)id<TimeChangeDelegate>delegate;
@property(nonatomic, assign)BOOL delegateScroll;
@property(nonatomic, assign)float scalePram;
- (void)changLabelStatus:(int)years;

- (void)rebuildEventView:(NSArray*)eventAry;

@end
