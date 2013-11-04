//
//  ViewController.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//
#define mapViewOrigY 188

#import "ViewController.h"
#import "LoadMenuInfoNet.h"
#import "LocalSQL.h"
#import "SimpMenuView.h"
#import "SubMenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "AllVarible.h"
#import "VersonInfoContr.h"

#import "QueueProHanle.h"
#import "QueueBgImHandle.h"
#import "QueueZipHandle.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize stopAllView;

- (void)viewDidLoad
{
    [self goolTrack];
    
    [QueueProHanle   init];
    [QueueBgImHandle init];
    [QueueZipHandle  init];
    
    AllBgImageView = bgImageView;
    [AllBgImageView setMyImageName:@""];
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    
    timeSViewContr = [[TimeSViewContr alloc] init];
    [timeSelectView addSubview:timeSViewContr.view];
    AllTimeSVContr = timeSViewContr;
    
    menuViewContr = [[MenuViewContr alloc] init];
    [menuView addSubview:menuViewContr.view];
    AllMenuViewContr = menuViewContr;
    
    mapRuleViewContr = [[MapRuleViewContr alloc] init];
    [mapView addSubview:mapRuleViewContr.view];
    AllMapRuleViewContr = mapRuleViewContr;
    
    menuViewContr.delegate       = timeSViewContr;
    timeSViewContr.delegate      = menuViewContr;

    [super viewDidLoad];
    
    ///// 缓冲器
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView setCenter:CGPointMake(512, 360)];
    [activeView startAnimating];
    activeView.layer.shadowOffset  = CGSizeMake(0, 0);
    activeView.layer.shadowRadius  = 5;
    activeView.layer.shadowOpacity = 1;
    [stopAllView addSubview:activeView];
    
    UIActivityIndicatorView *activeView2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activeView2 setCenter:CGPointMake(512, 573)];
    [activeView2 startAnimating];
    activeView2.layer.shadowOffset  = CGSizeMake(0, 0);
    activeView2.layer.shadowRadius  = 5;
    activeView2.layer.shadowOpacity = 1;
    [launchView addSubview:activeView2];
    
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.shadowOpacity = 0.4;
    //// data

    stopAllView.hidden = NO;
   
    LoadMenuInfoNet *loadMenuNet = [[LoadMenuInfoNet alloc] init];
    loadMenuNet.delegate = self;
    [loadMenuNet loadMenuFromUrl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

static NSString *const kTrackingId = @"UA-44083057-2";
- (void)goolTrack
{
    ///// googl track
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithName:@"工业设计史"
                               trackingId:kTrackingId];
}

- (void)addFilterView
{
    filterMenuViewContr = [[FilterMenuViewContr alloc] init];
    AllFilterMenuVCtr = filterMenuViewContr;
    filterMenuViewContr.delegate = self;
    [filterView addSubview:filterMenuViewContr.view];
    filterView.tag = FilterViewTag;
    filterView.hidden = YES;
}

- (void)rebulidStopView
{
    ///// 缓冲器
    if (stopAllView)
        return;
    
    stopAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [self.view addSubview:stopAllView];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView setCenter:CGPointMake(512, 360)];
    [activeView startAnimating];
    activeView.layer.shadowOffset = CGSizeMake(0, 0);
    activeView.layer.shadowRadius = 5;
    activeView.layer.shadowOpacity = 1;
    [stopAllView addSubview:activeView];
}

- (void)rebulidMapView
{
    mapRuleViewContr = [[MapRuleViewContr alloc] init];
    [mapView addSubview:mapRuleViewContr.view];
    AllMapRuleViewContr = mapRuleViewContr;
    
    int cusmPage = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
    SubMenuView *cusmSubMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + cusmPage];
    
    SimpMenuView *simpMview = (SimpMenuView*)[cusmSubMenuVMid._scrollView viewWithTag:(cusmSubMenuVMid._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
    if (simpMview)
    {
        [AllMapRuleViewContr showMapDetail:simpMview];
    }
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"rootView didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    @autoreleasepool {
        if (launchView != nil)
        {
            [launchView removeFromSuperview];
            launchView = nil;
        }
        
    }
}

#pragma mark - Event
- (IBAction)versionInfoShow:(UIButton*)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"btn_info_gold.png"] forState:UIControlStateNormal];
    VersonInfoContr *versonInfoContr = [[VersonInfoContr alloc] initWithButton:sender];
    versonInfoContr.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:versonInfoContr animated:YES completion:nil];
}

- (IBAction)mapShow:(UIButton*)sender
{
    if (mapRuleViewContr == nil)
    {
        [self rebulidMapView];
    }
    if (sender.frame.origin.x < 800)
    {
        isOpenMap = 0;
        [AllMapRuleViewContr hiddenMapDetail];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_map_gray.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void){
                             [menuView setFrame:CGRectMake(0, menuView.frame.origin.y, menuView.frame.size.width, menuView.frame.size.height)];
                             [mapView setFrame:CGRectMake(1024, 0, mapView.frame.size.width, mapView.frame.size.height)];
                             [sender setFrame:CGRectMake(sender.frame.origin.x + 360, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height)];
                             [versionInfoBt setFrame:CGRectMake(versionInfoBt.frame.origin.x + 360, versionInfoBt.frame.origin.y, versionInfoBt.frame.size.width, versionInfoBt.frame.size.height)];
                         }
                         completion:^(BOOL finish){
                             
                         }];
    }
    else
    {
        isOpenMap = 1;
        UIImage *imageBtBg = [UIImage imageNamed:@"btn_map_gold.png"];
        [sender setBackgroundImage:imageBtBg forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void){
                             [menuView setFrame:CGRectMake(0 - 177 - 10, menuView.frame.origin.y, menuView.frame.size.width, menuView.frame.size.height)];
                             [mapView setFrame:CGRectMake(1024 - 360, 0, mapView.frame.size.width, mapView.frame.size.height)];
                             [sender setFrame:CGRectMake(sender.frame.origin.x - 360, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height)];
                             [versionInfoBt setFrame:CGRectMake(versionInfoBt.frame.origin.x - 360, versionInfoBt.frame.origin.y, versionInfoBt.frame.size.width, versionInfoBt.frame.size.height)];
                         }
                         completion:^(BOOL finish){
                             [MenuViewContr reloadMapInfo];
                         }];
    }
}

- (IBAction)filterShow:(UIButton*)sender
{
    if (filterMenuViewContr == nil)
        [self addFilterView];
    filterView.hidden = NO;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^(void){
                         [selectConditionView setFrame:CGRectMake(270, selectConditionView.frame.origin.y, selectConditionView.frame.size.width, selectConditionView.frame.size.height)];
                         [filterView setFrame:CGRectMake(0, 0, filterView.frame.size.width, filterView.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                     }];
}

- (IBAction)closeCondition:(UIButton*)sender
{
    if (isScrollAnim)
    {
        isScrollAnim = NO;
        return;
    }

    UILabel *label = (UILabel*)[shadowView viewWithTag:30];
    label.text = @"";
    UIButton *btTwo = (UIButton*)[shadowView viewWithTag:20];
    UIButton *btOne = (UIButton*)[selectConditionView viewWithTag:10];
    [btOne setBackgroundImage:[UIImage imageNamed:@"btn_filter_gray.png"] forState:UIControlStateNormal];
    label.hidden = YES;
    btTwo.hidden = YES;
    
    if (filterMenuViewContr)
    {
        filterMenuViewContr.currentFilterStr = @"";
    }
    
    [NSThread detachNewThreadSelector:@selector(datahanle) toTarget:self withObject:nil];
    stopAllView.hidden = NO;
}

////
#pragma mark - thread
- (void)datahanle
{
    @autoreleasepool {
        [self performSelector:@selector(viewUpdate:) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
}

//////  customModel 更新view
- (void)viewUpdate:(NSArray*)tempArray
{
    @autoreleasepool {
    /// 找出filterScrV显示的year在customScrv中的位置，customScrv并显示该year
        int filterPage = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
        SubMenuView *filterSubMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + filterPage];
        SimpMenuView *filterSimpMview = (SimpMenuView*)[filterSubMenuVMid._scrollView viewWithTag:(filterSubMenuVMid._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
        NSString *filterCurrentIdStr = filterSimpMview._idStr;
        int year = [[AllMenuYear_PositionDict objectForKey:[NSString stringWithFormat:@"%d", filterPage]] intValue];
        
        ///// viewcontroll 界面变化 删除filter相关数据
        //// 先处理数据，在替换mode
        [timeSViewContr rebuildEventView:AllInfoArray];
        [AllMenuViewContr customModel];
        int cusmPage = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", year]] intValue];
        timeSViewContr.delegateScroll = YES;
        [AllTimeScrolV  setContentOffset:CGPointMake((year - StartYear)*GapYear, 0) animated:YES];
        [AllMenuScrollV setContentOffset:CGPointMake(cusmPage*MenuViewWidth, 0)];
        [menuViewContr loadCurrentPagePreAfterFive:cusmPage count:2];
        
        /////// 换地图
        [MenuViewContr reloadMapInfo];

        /// 换背景图
        SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + cusmPage];
        SimpMenuView *simpMview = (SimpMenuView*)[subMenuVMid._scrollView viewWithTag:(subMenuVMid._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
        if (subMenuVMid && ![filterCurrentIdStr isEqualToString:simpMview._idStr])  // 同一张图不换
        {
            isScrollAnim = NO;
            [MenuViewContr scrollStopUpdaBgImage];
        }
        stopAllView.hidden = YES;
    }
}


#pragma mark - filterDelegate
- (void)FilterSelectInfo:(int)type Title:(NSString*)title
{
    UILabel *label = (UILabel*)[shadowView viewWithTag:30];
    label.textColor = LabelBgColor;
    label.text = [NSString stringWithFormat:@"  %@", title];
    UIButton *btTwo = (UIButton*)[shadowView viewWithTag:20];
    UIButton *btOne = (UIButton*)[selectConditionView viewWithTag:10];
    [btOne setBackgroundImage:[UIImage imageNamed:@"btn_filter_gold.png"] forState:UIControlStateNormal];
    filterView.hidden = YES;
    label.hidden = NO;
    btTwo.hidden    = NO;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [selectConditionView setFrame:CGRectMake(20, selectConditionView.frame.origin.y, selectConditionView.frame.size.width, selectConditionView.frame.size.height)];
                         [filterView setFrame:CGRectMake(-250, 0, filterView.frame.size.width, filterView.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                         
                     }];
}

- (void)dismisFilterView
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^(void){
                         [selectConditionView setFrame:CGRectMake(20, selectConditionView.frame.origin.y, selectConditionView.frame.size.width, selectConditionView.frame.size.height)];
                         [filterView setFrame:CGRectMake(-250, 0, filterView.frame.size.width, filterView.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                         filterView.hidden = YES;
                     }];
}
#pragma mark - network delegate
- (void)didReceiveData:(NSDictionary *)dict
{
    [LocalSQL openDataBase];
    NSArray *backAry = (NSArray*)dict;
    for (int i = 0; i < backAry.count; i++)
    {
        [LocalSQL insertData:[backAry objectAtIndex:i]];
    }
    if (backAry.count > 0)  /// 更新最新时间抽
    {
        NSDictionary *tempDict  = [backAry lastObject];
        NSString *timestampLast = [tempDict objectForKey:@"timestamp"];
        if (timestampLast.length > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:timestampLast forKey:@"timestamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    [AllInfoArray removeAllObjects];
    [AllInfoArray addObjectsFromArray:[LocalSQL getAll]];
    if (AllInfoArray.count == 0 || AllInfoArray == nil)
    {
        [LocalSQL closeDataBase];
        stopAllView.hidden = NO;
        [launchView setHidden:YES];
        return;
    }
    __strong NSDictionary *newDict = [LocalSQL getNewestArticle];
    newChartYear = [[newDict objectForKey:@"year"] intValue];
    if (newChartYear == 0)
        newChartYear = StartYear;
    [LocalSQL closeDataBase];
    
    AllMenuCount = AllInfoArray.count;
    /// mainView built
    
    [timeSViewContr rebuildEventView:AllInfoArray];
    [menuViewContr  rebuiltBaseView];
    
    int newPosition = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", newChartYear]] integerValue];
    int start = newPosition - 7;
    int end  = newPosition + 1;
    if (start < 0)
        start = 0;
    if (end > AllInfoArray.count - 1)
        end = AllInfoArray.count - 1;
    NSRange rang;
    rang.length = end - start + 1;
    rang.location = start;
    AllStart = 1;
    [menuViewContr rebuiltMenuView:[AllInfoArray subarrayWithRange:rang]];
    [self addFilterView];
    
    /////// 从最新文章的前6个开始移动
    int newPage = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", newChartYear]] intValue];
    if (newPage > 6)
    {
        [AllMenuScrollV setContentOffset:CGPointMake((newPage-6)*MenuViewWidth, 0)];
    }
    //// 移动到最新文章位置
    [launchView setHidden:YES];
    [self performSelector:@selector(moveLastEssay:) withObject:newDict afterDelay:0.2];
    newDict = nil;
    
    [launchView removeFromSuperview];
    launchView = nil;
}


- (void)didReceiveErrorCode:(NSError*)Error
{
    [LocalSQL openDataBase];
    [AllInfoArray removeAllObjects];
    [AllInfoArray addObjectsFromArray:[LocalSQL getAll]];
    if (AllInfoArray.count == 0 || AllInfoArray == nil)
    {
        [LocalSQL closeDataBase];
        stopAllView.hidden = NO;
        [launchView setHidden:YES];
        if ([Error code] != -1009)
            [self alertView:@"网络数据有误"];
        return;
    }
    //// newestChart time
    __strong NSDictionary *newDict = [LocalSQL getNewestArticle];
    newChartYear = [[newDict objectForKey:@"year"] intValue];
    if (newChartYear == 0)
        newChartYear = StartYear;
    [LocalSQL closeDataBase];

    AllMenuCount = AllInfoArray.count;
    /// mainView built
    [timeSViewContr rebuildEventView:AllInfoArray];
    [menuViewContr rebuiltBaseView];
    AllStart = 1;
    [menuViewContr rebuiltMenuView:AllInfoArray];
    [self addFilterView];
    if ([Error code] == -1009)
    {
        [self alertView:@"网络连接失败，请检查网络设置。"];
    }

    /////// 从最新文章的前6个开始移动
    
    int newPage = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", newChartYear]] intValue];
    if (newPage > 6)
    {
        [AllMenuScrollV setContentOffset:CGPointMake((newPage-6)*MenuViewWidth, 0)];
    }
     //// 移动到最新文章位置
    [launchView setHidden:YES];
    [self performSelector:@selector(moveLastEssay:) withObject:newDict afterDelay:0.2];
    newDict = nil;
    
    [launchView removeFromSuperview];
    launchView = nil;
}

//// 移动到最新文章位置
- (void)moveLastEssay:(NSDictionary*)newDict
{
    int newYear = [[newDict objectForKey:@"year"] intValue];
    if (newYear == 0)
        newYear = StartYear;
    NSString *newIdStr = [newDict objectForKey:@"id"];
    
    int newPage = [[AllMenuPosition_YearDict objectForKey:[NSString stringWithFormat:@"%d", newYear]] intValue];
    AllTimeSVContr.delegateScroll = YES;
    AllMenuViewContr.delegateScroll = YES;
    
    float times = 1.8;
    if (newPage < 6)
        times = newPage*1.8/6;
    AllStart = -1;
    [UIView animateWithDuration:times
                     animations:^(void){
                         [AllTimeScrolV  setContentOffset:CGPointMake((newYear-StartYear)*GapYear, 0)];
                         [AllMenuScrollV setContentOffset:CGPointMake(newPage*MenuViewWidth, 0)];
                     }
                     completion:^(BOOL finish){
                         [AllTimeSVContr changLabelStatus:newYear];
                         SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + newPage];
                         for (int i = 0; i < subMenuVMid.infoArray.count; i++)
                         {
                             NSDictionary *infoDict = [subMenuVMid.infoArray objectAtIndex:i];
                             NSString *idStr = [infoDict objectForKey:@"id"];
                             if ([newIdStr isEqualToString:idStr])
                             {
                                 [subMenuVMid._scrollView setContentOffset:CGPointMake(0, i*SimpMenuHeigh)];
                                 [subMenuVMid moveStartStatus];
                             }
                         }
                         [subMenuVMid updatePageIndiView];
                         [subMenuVMid updateMapInfo];
                         isScrollAnim = 0;
                        // [MenuViewContr scrollStopUpdaBgImage];
                         [subMenuVMid initBgImage];
                         stopAllView.hidden = YES;
                         if (isNewVersion)
                         {
                             UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本，是否更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                             [alertV show];
                         }
                         AllStart = 1;
                     }];
}


- (void)alertView:(NSString*)infoStr
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:infoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"versionURL"]]];
    }
}

@end
