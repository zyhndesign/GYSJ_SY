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
    [_scrollView setDecelerationRate:0.7f];
    [self addLowwerLabel];
    [self addTimeLabel];
    
    int years = [self calculateYears:0];
    
    [self changLabelStatus:years];
    
}

- (void)addLowwerLabel
{
    int j = 0;
    for (j = 0; j < (AllNowYears-StartYear+1)/10 + 1;j++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(StartX + j*GapX, StartLowY-LabelHeigh, 1, LabelHeigh)];
        label.backgroundColor = LabelBgColor;
        [_scrollView addSubview:label];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(StartX + j*GapX, StartLowY-LabelHeigh, 1, LabelHeigh)];
    label.backgroundColor = LabelBgColor;
    [_scrollView addSubview:label];
}

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
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_scrollView addSubview:label];
        startYear += 10;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i-20, StartLowY-LabelHeigh-20, 40, 20)];
    label.textColor = LabelBgColor;
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%d", startYear];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:label];
}

#pragma mark - scorllview delegate
/// 滑动menuview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (delegateScroll)
    {
        if (scrollView.contentOffset.x < 0)
           [scrollView setContentOffset:CGPointZero];
        return;
    }
    
    isScrollAnim = 1;
    int years = StartYear + scrollView.contentOffset.x/GapYear;
    
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
        [delegate TimeViewMoveStop];
        [MenuViewContr scrollStopUpdaBgImage];
        [AllMenuViewContr removeFakeMenuView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (delegateScroll)
        return; 
    isScrollAnim = 0;
    [delegate TimeViewMoveStop];
    [MenuViewContr scrollStopUpdaBgImage];
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
    int yearStartPointx = (years - StartYear)*GapYear;
    delegateScroll = YES;
    if (yearStartPointx < 0)
        yearStartPointx = 0;
    if (yearStartPointx > AllTimeScrolV.contentSize.width - GapYear)
        yearStartPointx = AllMenuScrollV.contentSize.width - GapYear;
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
    int yearStartPointx = (years - StartYear)*GapYear;
    delegateScroll = YES;
    if (yearStartPointx < 0)
        yearStartPointx = 0;
    if (yearStartPointx > AllTimeScrolV.contentSize.width - GapYear)
        yearStartPointx = AllMenuScrollV.contentSize.width - GapYear;
    [_scrollView setContentOffset:CGPointMake(yearStartPointx , 0) animated:YES];
    [self changLabelStatus:years];
}


- (void)menuviewMoveStop:(int)years
{
    int yearStartPointx = (years - StartYear)*GapYear;
    delegateScroll = YES;
    [_scrollView setContentOffset:CGPointMake(yearStartPointx, 0) animated:YES];
}

- (int)calculateYears:(int)offsetX
{
    return (StartYear + offsetX/GapYear);
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
            [imageView setFrame:CGRectMake(StartX + (years - (StartYear + 1))*GapYear - 5, StartTopY + j*14 - j*5, 14, 14)];
            [AllTimeScrolV addSubview:imageView];
            imageView = nil;
        }
    }
}

@end
