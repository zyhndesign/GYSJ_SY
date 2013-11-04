//
//  TimeSViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "TimeSViewContr.h"
#import "SimpMenuView.h"
#import "MapRuleViewContr.h"
#import <QuartzCore/QuartzCore.h>
#import "SubMenuView.h"
#import "AllVarible.h"
#import "MenuViewContr.h"
#import "FilterMenuViewContr.h"
#import "DataHandle.h"

@interface TimeSViewContr ()

@end

@implementation TimeSViewContr
@synthesize delegate;
@synthesize delegateScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    scalePram = 1.0f;
    
    UIImage *_maskImage = [UIImage imageNamed:@"timeline_mask"];
    CALayer *_makkLayer = [CALayer layer];
    _makkLayer.frame = CGRectMake(155, 20, 868, 90);
    [_makkLayer setContents:(id)_maskImage.CGImage];
    [maskView.layer setMask:_makkLayer];
    
    [super viewDidLoad];
    timeLabel.textColor = LabelBgColor;
    
    AllTimeScrolV = _scrollView;
    [_scrollView setContentSize:CGSizeMake((AllNowYears - StartYear)*GapYear + 1024, _scrollView.frame.size.height)];
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.multipleTouchEnabled = NO;
    [_scrollView setDecelerationRate:0.7f];
    [self addLowwerLabel];
    [self addTimeLabel];
    
    int years = [self calculateYears:0];
    
    [self changLabelStatus:years];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
}

//  lowwerLabel的Tag小于1000
- (void)addLowwerLabel
{
    for (int j = 0; j < (AllNowYears-StartYear+1)/10 + 2;j++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(StartX + j*GapX, StartLowY-LabelHeigh, 1, LabelHeigh)];
        label.backgroundColor = LabelBgColor;
        label.tag = j+1;
        [_scrollView addSubview:label];
    }
}

//timeLabel的Tag 大于1770 小于2100
- (void)addTimeLabel
{
    int startYear = StartYear + 1;
    int i = StartX;
    for (i = StartX; i <= _scrollView.contentSize.width && startYear <= AllNowYears; i+= GapX)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i-20, StartLowY-LabelHeigh-20, 40, 20)];
        label.textColor = LabelBgColor;
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%d", startYear];
        label.tag  = startYear;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_scrollView addSubview:label];
        startYear += 10;
    }
}

#pragma mark - scorllview delegate
/// 滑动menuview
#define MaxScale 1
#define MinScale 0.5
static float beforeScale;
static float currentScorllCenter;

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    if (AllFilterMenuVCtr.currentFilterStr.length > 0)  /// fitler Mode
        return;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        currentScorllCenter = (_scrollView.contentOffset.x + 512)/scalePram;
        beforeScale = recognizer.scale - 1;
        scalePram += (recognizer.scale-1);
        isScaling = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        if (scalePram > 1.5)
            scalePram = 1.5;
        if (scalePram < 0.5)
            scalePram = 0.5;
        float currentGap = scalePram*GapX;
        if (scalePram*currentScorllCenter - 512 < 0)
        {
            [UIView animateWithDuration:0.5
                             animations:^(void){
                                 for(UIView *view in [_scrollView subviews])
                                 {
                                     int TTag = view.tag;
                                     if(TTag > 0 && TTag < StartYear) /// 竖条
                                     {
                                         [view setFrame:CGRectMake(StartX + (TTag-1)*currentGap, 99, 1, 10)];
                                     }
                                     else if(TTag < StartYear*10 && TTag >= StartYear) /// 字
                                     {
                                         [view setFrame:CGRectMake(StartX + (TTag-StartYear)/10*currentGap - 20, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                                     }
                                     else if(TTag >= StartYear*10)  /// 点
                                     {
                                         int years = TTag/10;
                                         if (scalePram > 1)
                                         {
                                             [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14, 14)];
                                         }
                                         else
                                         {
                                             [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14*scalePram, 14*scalePram)];
                                         }
                                     }
                                     else ;
                                     [_scrollView setContentSize:CGSizeMake((AllNowYears - StartYear)*GapYear*scalePram + 1024, _scrollView.frame.size.height)];
                                     [_scrollView setContentOffset:CGPointMake(0, 0)];
                                 }
                             }
                             completion:^(BOOL finish){
                                 [delegate TimeViewArriveYear:StartYear];
                                 isScaling = NO;
                                 [AllMenuViewContr removeFakeMenuView];
                             }];
        }
        else
        {
            [UIView animateWithDuration:0.5
                             animations:^(void){
                                 for(UIView *view in [_scrollView subviews])
                                 {
                                     int TTag = view.tag;
                                     if(TTag > 0 && TTag < StartYear) /// 竖条
                                     {
                                         [view setFrame:CGRectMake(StartX + (TTag-1)*currentGap, 99, 1, 10)];
                                     }
                                     else if(TTag < StartYear*10 && TTag >= StartYear) /// 字
                                     {
                                         [view setFrame:CGRectMake(StartX + (TTag-StartYear)/10*currentGap - 20, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
                                     }
                                     else if(TTag >= StartYear*10)  /// 点
                                     {
                                         int years = TTag/10;
                                         if (scalePram > 1)
                                         {
                                             [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14, 14)];
                                         }
                                         else
                                         {
                                             [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14*scalePram, 14*scalePram)];
                                         }
                                     }
                                     else ;
                                     [_scrollView setContentOffset:CGPointMake(scalePram*currentScorllCenter - 512, 0)];
                                 }
                             }
                             completion:^(BOOL finish){
                                 [_scrollView setContentSize:CGSizeMake((AllNowYears - StartYear)*GapYear*scalePram + 1024, _scrollView.frame.size.height)];
                                 int offsetx = scalePram*currentScorllCenter - 512;
                                 int year = StartYear;
                                 int beforeYear = StartYear;
                                 if (![timeLabel.text isEqualToString:@"革命前"])
                                     beforeYear = timeLabel.text.intValue;
                
                                 if (offsetx < 0)
                                 {
                                     [_scrollView setContentOffset:CGPointMake(0, 0)];
                                 }
                                 else if (offsetx > (AllNowYears - StartYear)*GapYear*scalePram)
                                 {
                                     [_scrollView setContentOffset:CGPointMake((AllNowYears - StartYear)*GapYear*scalePram, 0)];
                                     year = maxYear;
                                 }
                                 else
                                 {
                                     year = offsetx/(GapYear*scalePram) + StartYear;
                                 }
                                 int timePos = [DataHandle backTimePositionScrolCurrentYear:year];
                                 int currentYearPos = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", beforeYear]] intValue];
                                 int posGap = currentYearPos - timePos;
                                 if (posGap >= -1 && posGap <= 1)
                                 {
                                     
                                 }
                                 else
                                 {
                                    [delegate TimeViewArriveYear:[[AllMenuYear_PositionDict objectForKey:[NSString stringWithFormat:@"%d", timePos]] intValue]];
                                 }
                                 [AllMenuViewContr removeFakeMenuView];
                                 isScaling = NO;
                             }];
        }
        return;
    }
    else
    {
        scalePram -= beforeScale;
        scalePram += (recognizer.scale-1);
        beforeScale = recognizer.scale-1;
    }

    scalePram = scalePram < 0.2?0.2:scalePram;
    
    float currentGap = scalePram*GapX;
    for(UIView *view in [_scrollView subviews])
    {
        int TTag = view.tag;
        if(TTag > 0 && TTag < StartYear) /// 竖条
        {
            [view setFrame:CGRectMake(StartX + (TTag-1)*currentGap, 99, 1, 10)];
        }
        else if(TTag < StartYear*10 && TTag >= StartYear) /// 字
        {
            [view setFrame:CGRectMake(StartX + (TTag-StartYear)/10*currentGap - 20, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        }
        else if(TTag >= StartYear*10)  /// 点
        {
            int years = TTag/10;
            if (scalePram > 1)
            {
                [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14, 14)];
            }
            else
            {
                [view setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5*scalePram, view.frame.origin.y, 14*scalePram, 14*scalePram)];
            }
        }
        else ;
    }
    [_scrollView setContentSize:CGSizeMake((AllNowYears - StartYear)*GapYear*scalePram + 1024, _scrollView.frame.size.height)];
    [_scrollView setContentOffset:CGPointMake(scalePram*currentScorllCenter - 512, 0)];

 //   NSLog(@"捏合, %f", scalePram);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isScaling)
        return;
    if (delegateScroll)
    {
        if (scrollView.contentOffset.x < 0)
           [scrollView setContentOffset:CGPointZero];
        return;
    }
    
    isScrollAnim = 1;
    int years = StartYear + scrollView.contentOffset.x/(scalePram*GapYear);
    
    if (years >= maxYear )
    {
        [self changLabelStatus:maxYear];
        [delegate TimeViewArriveYear:maxYear];
    }
    else if([AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", years]])
    {
        [self changLabelStatus:years];
        [delegate TimeViewArriveYear:years];
    }
    else if([AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", years + 1]])
    {
        [self changLabelStatus:years + 1];
        [delegate TimeViewArriveYear:years + 1];
    }
    else if([AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", years - 1]])
    {
        [self changLabelStatus:years - 1];
        [delegate TimeViewArriveYear:years - 1];
    }
    else ;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    ScrollSysncLock = YES;
    delegateScroll = NO;
    isScrollAnim = 1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        isScrollAnim = 1;
    }
    else
    {
        isScrollAnim = 0;
        ScrollSysncLock = NO;
        [delegate TimeViewMoveStop];
        [MenuViewContr scrollStopUpdaBgImage];
        [AllMenuViewContr removeFakeMenuView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ScrollSysncLock = NO;
    if (delegateScroll)
        return; 
    isScrollAnim = 0;
    [delegate         TimeViewMoveStop];
    [MenuViewContr    scrollStopUpdaBgImage];
    [AllMenuViewContr removeFakeMenuView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (delegateScroll)
        return;
    isScrollAnim = 0;
    [delegate TimeViewMoveStop];
    [MenuViewContr scrollStopUpdaBgImage];
}

#pragma mark - TimeChangeDelegate

- (void)menuViewMoveYearBorder:(float)posX
{
    if (posX < 0 )
        posX = 0;
    else if (posX > AllMenuScrollV.contentSize.width - MenuViewWidth)
        posX = AllMenuScrollV.contentSize.width - MenuViewWidth;
    else;
//    SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:posX/MenuViewWidth + MenuStartTag];
//    int years = subMenuVMid.years;
    int years = [((UILabel*)[AllMenuScrollV viewWithTag:(posX/MenuViewWidth + TimeLabelStartTag)]).text intValue];
   // NSLog(@"Border-----%d", years);
    float yearStartPointx = (years - StartYear)*GapYear*scalePram;
  
    yearStartPointx += (1-scalePram)*2*GapX/20;
  
    delegateScroll = YES;
    if (yearStartPointx < 0)
        yearStartPointx = 0;
    if (yearStartPointx > AllTimeScrolV.contentSize.width - GapYear*scalePram)
        yearStartPointx = AllMenuScrollV.contentSize.width - GapYear*scalePram;
    [_scrollView setContentOffset:CGPointMake(yearStartPointx, 0) animated:YES];
}

- (void)menuViewMoveYears:(float)offSx
{
    if (offSx < 0 ) 
        offSx = 0;
    else if (offSx > AllMenuScrollV.contentSize.width - MenuViewWidth)
        offSx = AllMenuScrollV.contentSize.width - MenuViewWidth;
    else;
    int years = [((UILabel*)[AllMenuScrollV viewWithTag:(offSx/MenuViewWidth + TimeLabelStartTag)]).text intValue];
    float yearStartPointx = (years - StartYear)*GapYear*scalePram;

    yearStartPointx += (1-scalePram)*2*GapX/20;
   
    delegateScroll = YES;
    if (yearStartPointx < 0)
        yearStartPointx = 0;
    if (yearStartPointx > AllTimeScrolV.contentSize.width - GapYear*scalePram)
        yearStartPointx = AllMenuScrollV.contentSize.width - GapYear*scalePram;
    [_scrollView setContentOffset:CGPointMake(yearStartPointx , 0) animated:YES];
    [self changLabelStatus:years];
}


- (void)menuviewMoveStop:(int)years
{
    float yearStartPointx = (years - StartYear)*GapYear*scalePram;
    
    yearStartPointx += (1-scalePram)*2*GapX/20;
   
    delegateScroll = YES;
    [_scrollView setContentOffset:CGPointMake(yearStartPointx, 0) animated:YES];
}

- (int)calculateYears:(int)offsetX
{
    return (StartYear + offsetX/(GapYear*scalePram));
}

///// 改变label数据
- (void)changLabelStatus:(int)years
{
    if (years <= StartYear)
    {
        preTimeLb.text = [NSString stringWithFormat:@"工业"];
        preTimeLb.textColor = LabelBgColor;
        timeLabel.text = [NSString stringWithFormat:@"革命前"];
        timeLabel.font = [UIFont boldSystemFontOfSize:22];
        timeLabel.frame = CGRectMake(113, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height);
    }
    else
    {
        preTimeLb.text = [NSString stringWithFormat:@"公元"];
        preTimeLb.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:26];
        timeLabel.text = [NSString stringWithFormat:@"%d", years];
        timeLabel.frame = CGRectMake(111, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)rebuildEventView:(NSArray*)eventAry
{
    for(UIView *view in [AllTimeScrolV subviews])
    {
        if (view.tag >= StartYear*10)
            [view removeFromSuperview];
    }
    [AllMenuYear_PositionDict removeAllObjects];
    [AllMenuPosition_YearDict removeAllObjects];
    
    MinYear = [[[[eventAry objectAtIndex:0] objectAtIndex:0] objectForKey:@"year"] integerValue];
    if (MinYear == 0)
        MinYear = StartYear;
    maxYear = [[[[eventAry lastObject] objectAtIndex:0] objectForKey:@"year"] intValue];
    for (int i = 0; i < eventAry.count; i++)
    {
        NSArray *everyYearEventAry = [eventAry objectAtIndex:i];
        int years = [[[everyYearEventAry objectAtIndex:0] objectForKey:@"year"] intValue];
        if (years == 0)
            years = StartYear;
        [AllMenuYear_PositionDict setObject:[NSString stringWithFormat:@"%d", years] forKey:[NSString stringWithFormat:@"%d", i]];
        [AllMenuPosition_YearDict setObject:[NSString stringWithFormat:@"%d", i] forKey:[NSString stringWithFormat:@"%d", years]];
        /////// build view
        for (int j = 0; j < everyYearEventAry.count; j++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"event_dot_bg.png"]];
            imageView.tag = years*10 + j;
            [imageView setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear*scalePram - 5, StartTopY + j*14 - j*5, 14, 14)];
            [AllTimeScrolV addSubview:imageView];
            imageView = nil;
        }
    }
}

@end
