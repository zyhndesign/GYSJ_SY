//
//  MenuViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "MenuViewContr.h"
#import "SubMenuView.h"
#import "LocalSQL.h"
#import "SimpMenuView.h"
#import "MapRuleViewContr.h"
#import <QuartzCore/QuartzCore.h>
#import "AllVarible.h"
#import "TimeSViewContr.h"
#import "DataHandle.h"
#import <libkern/OSMemoryNotification.h>
#import "FilterMenuViewContr.h"

#define AnimaTime 0.3

@interface MenuViewContr ()

@end

@implementation MenuViewContr
@synthesize delegate;
@synthesize delegateScroll;
@synthesize _scrollerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    menuViewEixstCount = 0;
    [super viewDidLoad];
    //// 拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self                                               action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    AllMenuScrollV = _scrollerView;
    _scrollerView.clipsToBounds = NO;
    _scrollerView.scrollEnabled = NO;
    _scrollerView.bounces = YES;
    
    _filterScrollerV.clipsToBounds = NO;
    _filterScrollerV.hidden = YES;
    _filterScrollerV.scrollEnabled = NO;
    _filterScrollerV.bounces = YES;
}

////// 定义submenuview的Tag范围是3000到4000之间  MenuStartTag = 3000
//////  timeLabel的tag从7000开始   TimeLabelStartTag == 7000
////// 假象从Tag 50000开始 
- (void)rebuiltBaseView
{
    for (int i = 0; i < AllInfoArray.count; i++)
    {
        int years = [[[[AllInfoArray objectAtIndex:i] objectAtIndex:0] objectForKey:@"year"] integerValue];
        int startY = 0;
        if (years == 0)
        {
            startY = 7;
            years = StartYear;
        }
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MenuStartPosX + 60 + i * MenuViewWidth , startY + 5, 250, 40)];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:32];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.alpha = 0.4;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = [NSString stringWithFormat:@"%d", years];
        timeLabel.tag = TimeLabelStartTag + i;
        if (years == StartYear)
        {
            timeLabel.font = [UIFont boldSystemFontOfSize:26];
            timeLabel.text = [NSString stringWithFormat:@"工业革命前"];
        }
        [_scrollerView addSubview:timeLabel];
    }
    [_scrollerView setContentSize:CGSizeMake(MenuViewWidth*AllInfoArray.count, _scrollerView.frame.size.height)];
}
/*
 记录menuview上的数量 menuViewEixstCount
 AllIsEixstInView_Position
*/

- (void)fakeMenuView
{
    if (AllFilterMenuVCtr.currentFilterStr.length > 0 || AllMenuScrollV == _filterScrollerV)  /// fitler Mode
        return;
    if (AllStart < 0)
        return;
    int currentPage = _scrollerView.contentOffset.x/MenuViewWidth;
    int start = currentPage - 1;
    int end   = currentPage + 1;
    if (start < 0)
        start = 0;
    if (end > AllInfoArray.count - 1)
        end = AllInfoArray.count - 1;

    for (int i = start; i <= end; i++)
    {
        SubMenuView *submenuV = (SubMenuView*)[_scrollerView viewWithTag:MenuStartTag + i];
        UIView *subView = [_scrollerView viewWithTag:FakeStartTag + i];
        if (!submenuV && !subView)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(MenuStartPosX + 60 + i * MenuViewWidth, 50, SimpMenuWidth, SimpMenuHeigh)];
            subView.backgroundColor = [UIColor whiteColor];
            subView.tag = FakeStartTag  + i ;
            [_scrollerView addSubview:subView];
            menuViewEixstCount++;
        }
    }
}

- (void)removeFakeMenuView
{
    int page = (int)_scrollerView.contentOffset.x/MenuViewWidth;
    [self loadCurrentPagePreAfterFive:page count:2];
    for(UIView *view in [_scrollerView subviews])
    {
        if (view.tag > FakeStartTag)
            [view removeFromSuperview];
    }
}

- (void)rebuiltMenuView:(NSArray*)eventAry
{
    if (AllFilterMenuVCtr.currentFilterStr.length > 0)  /// fitler Mode
        return;
    if (AllStart < 0)
        return;
    int eventStartY = [[[[eventAry objectAtIndex:0] objectAtIndex:0] objectForKey:@"year"] intValue];
    if (eventStartY == 0)
        eventStartY = StartYear;
    int eventStartP = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", eventStartY]] intValue];
    for (int i = 0; i < eventAry.count; i++)
    {
        SubMenuView *submenuV = (SubMenuView*)[_scrollerView viewWithTag:MenuStartTag + eventStartP + i];
        if (!submenuV)
        {
            submenuV = [[SubMenuView alloc] init];
            submenuV.frame = CGRectMake(MenuStartPosX + (eventStartP + i) * MenuViewWidth, 0, MenuViewWidth, MenuViewHeigh);
            submenuV.years = [[[[eventAry objectAtIndex:i] objectAtIndex:0] objectForKey:@"year"] intValue];
            submenuV.tag = MenuStartTag + eventStartP + i;
            submenuV.infoArray = [eventAry objectAtIndex:i];
            [_scrollerView addSubview:submenuV];
            menuViewEixstCount++;
        }
        else
        {
            if (submenuV.infoArray.count < 1)
            {
                submenuV.infoArray = [eventAry objectAtIndex:i];
            }
        }
    }
    NSLog(@"menuViewEixstCount==%d", menuViewEixstCount);
}
////// count 警告级别
- (void)deleteMenuView:(int)count
{
    int currentPage = _scrollerView.contentOffset.x/MenuViewWidth;
    if (count <= 10)
    {
        for (int i = 0; i < currentPage - 2; i++)
        {
            SubMenuView *subMenuVMid = (SubMenuView*)[_scrollerView viewWithTag:(i + MenuStartTag)];
            if (subMenuVMid)
            {
                menuViewEixstCount--;
                [subMenuVMid removeFromSuperview];
                subMenuVMid = nil;
            }
        }
        for (int i = currentPage + 2; i < AllInfoArray.count; i++)
        {
            SubMenuView *subMenuVMid = (SubMenuView*)[_scrollerView viewWithTag:(i + MenuStartTag)];
            if (subMenuVMid)
            {
                menuViewEixstCount--;
                [subMenuVMid removeFromSuperview];
                subMenuVMid = nil;
            }
        }
    }
    NSLog(@"menuViewEixstCount--->%d", menuViewEixstCount);
}

- (void)rebuiltFilterMenuView:(NSArray*)eventAry
{
    //// clear
    for(UIView *view in [_filterScrollerV subviews])
        [view removeFromSuperview];
    for (int i = 0; i < eventAry.count; i++)
    {
        int years = [[[[eventAry objectAtIndex:i] objectAtIndex:0] objectForKey:@"year"] integerValue];
        int startY = 0;
        if (years == 0)
        {
            startY = 7;
            years = StartYear;
        }
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MenuStartPosX + 60 + i * MenuViewWidth , startY + 5, 250, 40)];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:32];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.alpha = 0.4;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = [NSString stringWithFormat:@"%d", years];
        timeLabel.tag = TimeLabelStartTag + i;
        if (years == StartYear)
        {
            timeLabel.font = [UIFont boldSystemFontOfSize:26];
            timeLabel.text = [NSString stringWithFormat:@"工业革命前"];
        }
        [_filterScrollerV addSubview:timeLabel];
        
        SubMenuView *submenuV = [[SubMenuView alloc] init];
        submenuV.frame = CGRectMake(MenuStartPosX + i * MenuViewWidth, startY, MenuViewWidth, MenuViewHeigh);
        [_filterScrollerV addSubview:submenuV];
        submenuV.tag = MenuStartTag + i;
        submenuV.years = years;
        submenuV.infoArray = [eventAry objectAtIndex:i];
    }
    [_filterScrollerV setContentSize:CGSizeMake(MenuViewWidth*eventAry.count, _filterScrollerV.frame.size.height)];
    [_filterScrollerV setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    int level = (int)OSMemoryNotificationCurrentLevel();
    NSLog(@"MemoryWarning-->level:%d", level);
    @autoreleasepool {
        [self deleteMenuView:level];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}


#pragma mark - TimeChangeDelegate
- (void)TimeViewArriveYear:(int)year
{
    delegateScroll = YES;
    int page = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", year]] integerValue];
    if (year != MinYear && page == 0 && AllMenuScrollV == _scrollerView)
        return;
    if (AllMenuScrollV.contentOffset.x <= page*MenuViewWidth && AllMenuScrollV.contentOffset.x > (page-1)*MenuViewWidth)
    {
        return;
    }
    if (AllMenuScrollV.contentOffset.x >= page*MenuViewWidth && AllMenuScrollV.contentOffset.x < (page+1)*MenuViewWidth)
    {
        return;
    }
    
    [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
    [AllTimeSVContr changLabelStatus:year];
}


- (void)TimeViewMoveStop
{
    delegateScroll = NO;
}

#pragma mark - gesture 
//处理快速滑动操作


/// 滑动menuview
static int slipAllGap;
static BOOL touchOver;  // 边界反弹问题， touchover是在手松开后再执行动画，不然在拖的过程中，子视图会左右震动
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    // 
    delegateScroll = NO;
    CGPoint translation = [recognizer translationInView:self.view];
    [recognizer setTranslation:CGPointZero inView:self.view];
    int offsetX;
    if (AllMenuScrollV.contentOffset.x < 0)
    {
        int rate = (0-AllMenuScrollV.contentOffset.x)/20 + 1;
        offsetX = AllMenuScrollV.contentOffset.x - translation.x*2/rate;
    }
    else if(AllMenuScrollV.contentOffset.x > AllMenuScrollV.contentSize.width - MenuViewWidth)
    {
        int rate = (AllMenuScrollV.contentOffset.x - AllMenuScrollV.contentSize.width + MenuViewWidth)/20 + 1;
        offsetX = AllMenuScrollV.contentOffset.x - translation.x*2/rate;
    }
    else
        offsetX = AllMenuScrollV.contentOffset.x - translation.x;

    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        touchOver = NO;
        isScrollAnim = 1;
        rightSlip = leftSlip = NO;
        if (translation.x > 2)
            leftSlip = YES;
        else if(translation.x < -2)
            rightSlip = YES;
        else;
        slipAllGap = translation.x;
        [AllMenuScrollV setContentOffset:CGPointMake(offsetX, 0)];
       // [AllMapRuleViewContr hiddenMapDetail];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //// 只要滑动超出30个位置，必须变化
        touchOver = YES;
        int page = 0;
        if (rightSlip && leftSlip)
        {
            if (slipAllGap < -250)
            {
                page = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
                int offx = (int)AllMenuScrollV.contentOffset.x%MenuViewWidth;
                if (slipAllGap < -MenuViewWidth)
                    page++;
                else
                {
                    if (offx > MenuViewWidth/2)
                        page++;
                }
                if (page >= AllMenuScrollV.contentSize.width/MenuViewWidth)
                    page = AllMenuScrollV.contentSize.width/MenuViewWidth - 1;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
            else if(slipAllGap > 250)
            {
                page = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
                int offx = (int)AllMenuScrollV.contentOffset.x%MenuViewWidth;
                if (slipAllGap > MenuViewWidth)
                {
                    if (offx > MenuViewWidth/2)
                        page++;
                }
                if (page < 0)
                    page = 0;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
            else
            {
                page = (int)(AllMenuScrollV.contentOffset.x + slipAllGap)/MenuViewWidth;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
        }
        else
        {
            if (slipAllGap < -20)
            {
                page = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
                int offx = (int)AllMenuScrollV.contentOffset.x%MenuViewWidth;
                if (slipAllGap > -MenuViewWidth)
                    page++;
                else
                {
                    if (offx > MenuViewWidth/2)
                        page++;
                }
                if (page >= AllMenuScrollV.contentSize.width/MenuViewWidth)
                    page = AllMenuScrollV.contentSize.width/MenuViewWidth - 1;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
            else if(slipAllGap > 20)
            {
                page = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
                int offx = (int)AllMenuScrollV.contentOffset.x%MenuViewWidth;
                if (slipAllGap > MenuViewWidth)
                {
                    if (offx > MenuViewWidth/2)
                        page++;
                }
                if (page < 0)
                    page = 0;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
            else
            {
                page = ((int)AllMenuScrollV.contentOffset.x)/MenuViewWidth;
                if (slipAllGap > 0)  ////向右
                    page++;
                if (page > AllMenuScrollV.contentSize.width/MenuViewWidth - 1)
                    page = AllMenuScrollV.contentSize.width/MenuViewWidth - 1;
                [AllMenuScrollV setContentOffset:CGPointMake(page*MenuViewWidth, 0) animated:YES];
            }
        }
        
        //SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:(page + MenuStartTag)];
        UILabel *tempLb = (UILabel*)[AllMenuScrollV viewWithTag:(page + TimeLabelStartTag)];
        int currentY = [tempLb.text intValue];
        [delegate menuviewMoveStop:currentY];
        [MenuViewContr reloadMapInfo];
        rightSlip = leftSlip = NO;
    }
    else
    {
        if (translation.x > 2)
            leftSlip = YES;
        else if(translation.x < -2)
            rightSlip = YES;
        else ;
        slipAllGap += translation.x;
        
        [AllMenuScrollV setContentOffset:CGPointMake(offsetX, 0)];
        if (((int)offsetX%MenuViewWidth) == 0)
        {/////////边境处理
            [delegate menuViewMoveYearBorder:AllMenuScrollV.contentOffset.x];
        }
        else
        {
            [delegate menuViewMoveYears:AllMenuScrollV.contentOffset.x];
        }
    }
}

+ (void)scrollStopUpdaBgImage
{
    int offsetX = AllMenuScrollV.contentOffset.x;
    if (offsetX < 0)
        offsetX = 0;
    if (offsetX > AllMenuScrollV.contentSize.width - MenuViewWidth)
        offsetX = AllMenuScrollV.contentSize.width - MenuViewWidth;
    
    SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:offsetX/MenuViewWidth + MenuStartTag];
    if (subMenuVMid)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
            @autoreleasepool {
                if (!isScrollAnim)
                {
                    int offsetX2 = AllMenuScrollV.contentOffset.x;
                    if (offsetX2 < 0)
                        offsetX2 = 0;
                    if (offsetX2 > AllMenuScrollV.contentSize.width - MenuViewWidth)
                        offsetX2 = AllMenuScrollV.contentSize.width - MenuViewWidth;
                    SubMenuView *subMenuVMid2 = (SubMenuView*)[AllMenuScrollV viewWithTag:offsetX2/MenuViewWidth + MenuStartTag];
                    
                    [AllTimeSVContr changLabelStatus:subMenuVMid2.years];
                    [subMenuVMid2 updageBgImage];
                    [subMenuVMid2 updateMapInfo];
//                    SimpMenuView *simpMview = (SimpMenuView*)[subMenuVMid2._scrollView viewWithTag:(subMenuVMid2._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
//                    
//                    [SubMenuView updageBgImage:simpMview.imageBg imageName:simpMview.imageName];
                }
            }
        });
    }
}

//// 当前前后总共加载五个
- (void)loadCurrentPagePreAfterFive:(int)currentPage count:(int)count
{
    int start = currentPage - count;
    int end   = currentPage + count;
    if (start < 0)
        start = 0;
    if (end > AllInfoArray.count - 1)
        end = AllInfoArray.count - 1;

    NSRange rang;
    rang.length = end - start + 1;
    rang.location = start;
    NSArray *tempAry = [AllInfoArray subarrayWithRange:rang];
    [self rebuiltMenuView:tempAry];
}

#pragma mark - scorllview delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (delegateScroll)
        return;
    if (menuViewEixstCount > 5)
    {
        [AllMenuViewContr deleteMenuView:1];
    }
    isScrollAnim = 0;
    [MenuViewContr scrollStopUpdaBgImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (delegateScroll)
    {
        [self fakeMenuView];
        return;
    }
    int page = (int)_scrollerView.contentOffset.x/MenuViewWidth;
    [self loadCurrentPagePreAfterFive:page count:2];

    if (scrollView.contentOffset.x < 0 && touchOver)
    {
        delegateScroll = YES;
        [scrollView setContentOffset:CGPointZero animated:YES];
        isScrollAnim = 0;  ///  最前面那张，进行bg图片变换，需要isScrollAnim为0
        [MenuViewContr scrollStopUpdaBgImage];
        return;
    }
    if (scrollView.contentOffset.x > scrollView.contentSize.width - MenuViewWidth && touchOver)
    {
        delegateScroll = YES;
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - MenuViewWidth, 0) animated:YES];
        isScrollAnim = 0;///  最后面那张，进行bg图片变换，需要isScrollAnim为0
        [MenuViewContr scrollStopUpdaBgImage];
        return;
    }
    isScrollAnim = 1;
}

//// 仅当地图打开时调用这个画线功能
+ (void)reloadMapInfo
{
    int page = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
    SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + page];
    [subMenuVMid updateMapInfo];
}

#pragma mark - Model
//// filter 后，界面重新布局
- (void)filterModel:(NSArray*)infoArray
{
    //// 清理工作
    _scrollerView.hidden = YES;
    _filterScrollerV.hidden = NO;
    AllMenuScrollV = _filterScrollerV;
    
    ///// 界面处理
    [AllTimeSVContr rebuildEventView:infoArray];
    [self rebuiltFilterMenuView:infoArray];
    
    int yearTag = [[AllMenuYear_PositionDict objectForKey:@"0"] intValue];
    [AllTimeScrolV setContentOffset:CGPointMake((yearTag - StartYear)*GapYear, 0) animated:YES];
}

- (void)customModel
{
    //// 清理工作
    for(UIView *view in [_filterScrollerV subviews])
        [view removeFromSuperview];
    for(UIView *view in [_scrollerView subviews])
    {
        if (view.tag > FakeStartTag)
            [view removeFromSuperview];
    }
    AllMenuScrollV = _scrollerView;
    _scrollerView.hidden    = NO;
    _filterScrollerV.hidden = YES;
}
    
+ (void)removeAllSubView:(UIView*)Sview
{
    for(UIView *view in [Sview subviews])
        [view removeFromSuperview];
}
@end
