//
//  MenuViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeChangeDelegate.h"

@interface MenuViewContr : UIViewController<UIScrollViewDelegate, TimeChangeDelegate>
{
    IBOutlet UIScrollView *_scrollerView;
    IBOutlet UIScrollView *_filterScrollerV;
    
    int CurrentYears;
    
    BOOL rightSlip; // 向右滑动
    BOOL leftSlip;  // 向左滑动
    
    BOOL delegateScroll;
}
@property(nonatomic, weak)id<TimeChangeDelegate>delegate;
@property(nonatomic, strong)IBOutlet UIScrollView *_scrollerView;
@property(nonatomic, assign)BOOL delegateScroll;
- (void)rebuiltMenuView:(NSArray*)eventAry;
- (void)rebuiltBaseView;
+ (void)reloadMapInfo;  //// 仅当地图打开时调用这个功能
+ (void)scrollStopUpdaBgImage;
- (void)filterModel:(NSArray*)infoArray;
- (void)customModel;
- (void)deleteMenuView:(int)count; 
- (void)loadCurrentPagePreAfterFive:(int)currentPage count:(int)count;
- (void)fakeMenuView;/////  假象模式
- (void)removeFakeMenuView;

@end
