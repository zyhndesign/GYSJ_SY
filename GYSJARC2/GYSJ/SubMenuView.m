//
//  subMenuView.m
//  GYSJ
//
//  Created by sunyong on 13-7-29.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#define RectOne   CGRectMake(100, 10, 236, 315)
#define RectTwo   CGRectMake(82, 33, 236, 315)
#define RectThree CGRectMake(64, 56, 236, 315)

#define BottomPositionY 371


#define SimpMenuGapWidth 18
#define SimpMenuGapHeigh 23

#define ImageVLotWidth 13



#import "SubMenuView.h"
#import "SimpMenuView.h"
#import "ContentViewContr.h"
#import "ViewController.h"
#import "MapRuleViewContr.h"
#import <QuartzCore/QuartzCore.h>
#import "AllVarible.h"
#import "MenuViewContr.h"


@implementation SubMenuView
@synthesize years;
@synthesize infoArray;
@synthesize _scrollView;
@synthesize pageIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, MenuViewWidth, MenuViewHeigh); //为阴影留空间
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        infoArray = [[NSMutableArray alloc] init];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 6;
        self.layer.shadowOpacity = 0.4;
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews
{
    pageIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 60, SimpMenuHeigh)];
    pageIndicatorView.backgroundColor = [UIColor clearColor];
    [self addSubview:pageIndicatorView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 50, SimpMenuWidth, SimpMenuHeigh)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.decelerationRate = 0.1;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.hidden = YES;
    [self addSubview:_scrollView];
    
    ///点击手势  展示详细信息
    UITapGestureRecognizer *tapGetstureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGest:)];
    [_scrollView addGestureRecognizer:tapGetstureR];
}

////  绘制Submenu界面
- (void)setInfoArray:(NSMutableArray *)_infoArray
{
    if (_infoArray.count == 0)
        return;
    [infoArray removeAllObjects];
    [infoArray addObjectsFromArray:_infoArray];
    [self builtView];
}

- (void)clearView
{
    for(UIView *view in [pageIndicatorView subviews])
        [view removeFromSuperview];
    for(UIView *view in [_scrollView subviews])
        [view removeFromSuperview];
}

///// 重建view
- (void)builtView
{
    [self clearView];
    _scrollView.hidden  = NO;
    [pageIndicatorView setFrame:CGRectMake(0, 0, ImageVLotWidth + 2, (ImageVLotWidth + 1)*infoArray.count)];
    pageIndicatorView.center = CGPointMake(41, MenuViewHeigh/2 + 5);
    //  绘制旁边的点
    for (int i = 0; i < infoArray.count; i++)
    {
        if(i == 0)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_dot_full.png"]];
            [imageView setFrame:CGRectMake(0, i*ImageVLotWidth + i, ImageVLotWidth, ImageVLotWidth)];
            imageView.tag = 1;
            [pageIndicatorView addSubview:imageView];
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_dot_empty.png"]];
            [imageView setFrame:CGRectMake(0, i*ImageVLotWidth + i, ImageVLotWidth, ImageVLotWidth)];
            imageView.tag = i+1;
            [pageIndicatorView addSubview:imageView];
        }
    }
    //  绘制内容
    [_scrollView setContentSize:CGSizeMake(SimpMenuWidth, SimpMenuHeigh*infoArray.count)];
    for (int i = 0; i < infoArray.count; i++)
    {
        SimpMenuView *simpleView = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:i]];
        [simpleView setFrame:CGRectMake(0, i*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
        simpleView.tag = (i+1)*10;
        [_scrollView addSubview:simpleView];
        break;
    }
}

//// 更改背景图
//static BOOL onlySyn;  //// 只能一张图相互切换
//+ (void)updageBgImage:(UIImage *)newImage imageName:(NSString*)imageName
//{
////    if(imageName.length < 1 || [[AllBgImageView getImageName] isEqualToString:imageName] || !newImage)
////        return;
//    onlySyn = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
//    {
//        onlySyn = NO;
//        int offsetx = AllMenuScrollV.contentOffset.x/MenuViewWidth;
//        int Tag     = MenuStartTag;
//        if ( offsetx >= 1)
//            Tag += offsetx;
//        SubMenuView *subMenuVMid2 = (SubMenuView*)[AllMenuScrollV viewWithTag:Tag];
//        SimpMenuView *simpMview2  = (SimpMenuView*)[subMenuVMid2._scrollView viewWithTag:(subMenuVMid2._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
//        if(([[AllBgImageView getImageName] isEqualToString:simpMview2.imageName] || AllBgImageView.image == simpMview2.imageBg) && AllBgImageView.alpha > 0.9)
//        {
//            return ;
//        }
//        if (onlySyn)
//        {
//            return;
//        }
//        float timess = 0.5;// AllBgImageView.alpha/2.0;
//        [UIView animateWithDuration:timess/2 animations:^(void){AllBgImageView.alpha = AllBgImageView.alpha/2.0;} completion:^(BOOL finish){
//                if (onlySyn) return ;
//            [UIView animateWithDuration:timess/2 animations:^(void){AllBgImageView.alpha = 0;} completion:^(BOOL finish){
//                [AllBgImageView setMyImageName:imageName];
//                AllBgImageView.image = newImage;
//                [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.2;} completion:^(BOOL finish){
//                    if (isScrollAnim || onlySyn)
//                    {
//                        return ;
//                    }
//                    [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.4;} completion:^(BOOL finish){
//                        if (isScrollAnim || onlySyn)
//                        {
//                            return ;
//                        }
//                        [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.6;} completion:^(BOOL finish){
//                            if (isScrollAnim || onlySyn)
//                            {
//                                return ;
//                            }
//                            [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.8;} completion:^(BOOL finish){
//                                if (isScrollAnim || onlySyn )
//                                {
//                                    return ;
//                                }
//                            }];
//                            [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 1.0; } completion:^(BOOL finish){
//                                
//                            }];
//                        }];
//                    }];
//                }];
//
//            }];
//        }];
//    });
//}

//// 更改背景图

static NSString *beferoImage;
- (void)initBgImage
{
    SimpMenuView *simpMview = (SimpMenuView*)[_scrollView viewWithTag:(_scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
    if(simpMview)
    {
        if(simpMview.imageName == nil || simpMview.imageName.length < 1)
        {
        }
        else
        {
            if(AllBgImageView.image == simpMview.imageBg)
                return;
            if(simpMview.imageName.length > 0)
            {
                if(!simpMview.imageBg || AllBgImageView.image == simpMview.imageBg)
                    return;
                if ([beferoImage isEqualToString:simpMview.imageName])  // 同一张图片只能不干扰
                    return;
                beferoImage = simpMview.imageName;
                float timess = 0.25;
                
                [UIView animateWithDuration:timess animations:^(void){AllBgImageView.alpha = 0.5;} completion:^(BOOL finish){
                    [UIView animateWithDuration:timess animations:^(void){AllBgImageView.alpha = 0;} completion:^(BOOL finish){
                        AllBgImageView.image = simpMview.imageBg;
                        [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.2;} completion:^(BOOL finish){
                            if (isScrollAnim)
                            {
                                [self bgImageDisapper];
                                beferoImage = nil;
                                return ;
                            }
                            [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.4;} completion:^(BOOL finish){
                                if (isScrollAnim)
                                {
                                    beferoImage = nil;
                                    [self bgImageDisapper];
                                    return ;
                                }
                                [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.6;} completion:^(BOOL finish){
                                    if (isScrollAnim)
                                    {
                                        beferoImage = nil;
                                        [self bgImageDisapper];
                                        return ;
                                    }
                                    [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.8;} completion:^(BOOL finish){
                                        if (isScrollAnim)
                                        {
                                            beferoImage = nil;
                                            [self bgImageDisapper];
                                            return ;
                                        }
                                    }];
                                    [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 1.0; } completion:^(BOOL finish){
                                        
                                    }];
                                }];
                            }];
                        }];
                        
                    }];
                }];
                
                
            }
            
        }
    }
}


- (void)updageBgImage
{
    SimpMenuView *simpMview = (SimpMenuView*)[_scrollView viewWithTag:(_scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
    if(simpMview)
    {
        if(simpMview.imageName == nil || simpMview.imageName.length < 1)
        {
            
            
        }
        else
        {
            if(AllBgImageView.image == simpMview.imageBg)
            {
                return;
            }
            float delay = 0.3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                
                if (!isScrollAnim)
                {
                    int offsetx = AllMenuScrollV.contentOffset.x/MenuViewWidth;
                    int Tag = MenuStartTag;
                    if ( offsetx >= 1)
                        Tag += offsetx;
                    SubMenuView *subMenuVMid2 = (SubMenuView*)[AllMenuScrollV viewWithTag:Tag];
                    SimpMenuView *simpMview2 = (SimpMenuView*)[subMenuVMid2._scrollView viewWithTag:(subMenuVMid2._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
                    
                    if(simpMview2.imageName.length > 0)
                    {
                        if([[AllBgImageView getImageName] isEqualToString:simpMview2.imageName])
                        {
                            return;
                        }
                        beferoImage = simpMview2.imageName;
                        float timess = AllBgImageView.alpha/2.0;
                        
                        [UIView commitAnimations];
                        [UIView animateWithDuration:timess/2 animations:^(void){AllBgImageView.alpha = AllBgImageView.alpha/2;} completion:^(BOOL finish){
                            [UIView animateWithDuration:timess/2 animations:^(void){AllBgImageView.alpha = 0;} completion:^(BOOL finish){
                                AllBgImageView.image = simpMview2.imageBg;
                                [AllBgImageView setMyImageName:simpMview2.imageName];
                                [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.2;} completion:^(BOOL finish){
                                    if (isScrollAnim)
                                    {
                                        [self bgImageDisapper];
                                        beferoImage = nil;
                                        return ;
                                    }
                                    [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.4;} completion:^(BOOL finish){
                                        if (isScrollAnim)
                                        {
                                            beferoImage = nil;
                                            [self bgImageDisapper];
                                            return ;
                                        }
                                        [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.6;} completion:^(BOOL finish){
                                            if (isScrollAnim)
                                            {
                                                beferoImage = nil;
                                                [self bgImageDisapper];
                                                return ;
                                            }
                                            [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 0.8;} completion:^(BOOL finish){
                                                if (isScrollAnim)
                                                {
                                                    beferoImage = nil;
                                                    [self bgImageDisapper];
                                                    return ;
                                                }
                                            }];
                                            [UIView animateWithDuration:0.1 animations:^(void){AllBgImageView.alpha = 1.0; } completion:^(BOOL finish){
                                                
                                            }];
                                        }];
                                    }];
                                }];
                                
                            }];
                        }];
                        
                        
                    }
                    
                }
                
            });
        }
    }
    
}

static int bgTimeCount;

- (void)bgImageDisapper
{
    float times = AllBgImageView.alpha/2;
    [UIView animateWithDuration:times animations:^(void){AllBgImageView.alpha = 0.0; } completion:^(BOOL finish){
        AllBgImageView.image = nil;
        [AllBgImageView setMyImageName:@""];
    }];
}


- (void)bgImageViewHidden:(int)count
{
    bgTimeCount = count;
    if (count < 0)
        return;
    [UIView animateWithDuration:0.2 animations:^(void){AllBgImageView.alpha = bgTimeCount*2/10.0;} completion:^(BOOL finish){
        bgTimeCount--;
        [self bgImageViewHidden:bgTimeCount];
     }];
}
//////  touch
- (void)moveStartStatus
{
    if([self updatePageIndiView])
    {
        isScrollAnim = 0;
        SimpMenuView *simpMview2  = (SimpMenuView*)[_scrollView viewWithTag:((_scrollView.contentOffset.y+ 50)/SimpMenuHeigh+1)*10];
        if (!simpMview2)
        {
            int Tag = _scrollView.contentOffset.y/SimpMenuHeigh;
            simpMview2 = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:Tag]];
            [simpMview2 setFrame:CGRectMake(0, Tag*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
            simpMview2.tag = (Tag+1)*10;
            [_scrollView addSubview:simpMview2];
        }
        for(UIView *view in [_scrollView subviews])
        {
            if (view == simpMview2)
                continue;
            [view removeFromSuperview];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int tagV = _scrollView.contentOffset.y/SimpMenuHeigh;
    if (tagV >= 0 && tagV < infoArray.count)
    {
        int preTag = tagV - 1;
        int aftTag = tagV + 1;
        if (preTag < 0)
            preTag = 0;
        if (aftTag > infoArray.count -1)
            aftTag = infoArray.count - 1;
        
        if(![_scrollView viewWithTag:(preTag+1)*10])
        {
            SimpMenuView *simpleView = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:preTag]];
            [simpleView setFrame:CGRectMake(0, preTag*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
            simpleView.tag = (preTag+1)*10;
            [_scrollView addSubview:simpleView];
        }
        if(![_scrollView viewWithTag:(aftTag+1)*10])
        {
            SimpMenuView *simpleView = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:aftTag]];
            [simpleView setFrame:CGRectMake(0, aftTag*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
            simpleView.tag = (aftTag+1)*10;
            [_scrollView addSubview:simpleView];
        }
    }
}

///// 设置减速度
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if([self updatePageIndiView])
        {
            isScrollAnim = 0;
            SimpMenuView *simpMview2  = (SimpMenuView*)[_scrollView viewWithTag:((_scrollView.contentOffset.y+ 50)/SimpMenuHeigh+1)*10];
            if (!simpMview2)
            {
                int Tag = _scrollView.contentOffset.y/SimpMenuHeigh;
                simpMview2 = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:Tag]];
                [simpMview2 setFrame:CGRectMake(0, Tag*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
                simpMview2.tag = (Tag+1)*10;
                [_scrollView addSubview:simpMview2];
            }
            for(UIView *view in [scrollView subviews])
            {
                if (view == simpMview2)
                    continue;
                [view removeFromSuperview];
            }
            [MenuViewContr scrollStopUpdaBgImage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self updatePageIndiView])
    {
        isScrollAnim = 0;
        SimpMenuView *simpMview2  = (SimpMenuView*)[_scrollView viewWithTag:((_scrollView.contentOffset.y+ 50)/SimpMenuHeigh+1)*10];
        if (!simpMview2)
        {
            int Tag = _scrollView.contentOffset.y/SimpMenuHeigh;
            simpMview2 = [[SimpMenuView alloc] initWithDict:[infoArray objectAtIndex:Tag]];
            [simpMview2 setFrame:CGRectMake(0, Tag*SimpMenuHeigh, SimpMenuWidth, SimpMenuHeigh)];
            simpMview2.tag = (Tag+1)*10;
            [_scrollView addSubview:simpMview2];
        }
        for(UIView *view in [scrollView subviews])
        {
            if (view == simpMview2)
                continue;
            [view removeFromSuperview];
        }
        [MenuViewContr scrollStopUpdaBgImage];
    }
}

- (BOOL)updatePageIndiView
{
    float offsetY = _scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= _scrollView.contentSize.height)
    {
        int imagVTag = offsetY/SimpMenuHeigh;
        
        UIImageView *imageV = (UIImageView*)[pageIndicatorView viewWithTag:imagVTag+1];
        if (!imageV)
            return NO;
        [self updateMapInfo];
        for(UIImageView* imageVTemp in [pageIndicatorView subviews])
        {
            if (imageV == imageVTemp)
            {
                [imageV setImage:[UIImage imageNamed:@"white_dot_full.png"]];
            }
            else
            {
                [imageVTemp setImage:[UIImage imageNamed:@"white_dot_empty.png"]];
            }
        }
        
        return YES;
    }
    return NO;
}

////  更新地图信息
- (void)updateMapInfo
{
    if (!isOpenMap)
        return;
    SimpMenuView *simpMview = (SimpMenuView*)[_scrollView viewWithTag:(_scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
    if (simpMview)
    {
        [AllMapRuleViewContr showMapDetail:simpMview];
    }
}


///点击手势  展示详细信息界面
- (void)tapGest:(UITapGestureRecognizer*)gesture
{
    SimpMenuView *simpMview = (SimpMenuView*)[_scrollView viewWithTag:(_scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
    if (!simpMview)
        return;
    ContentViewContr *contentView = [[ContentViewContr alloc] initWithSimMenuV:simpMview];
    contentView.modalPresentationStyle = UIModalPresentationPageSheet;
    [RootViewContr presentViewController:contentView animated:YES completion:nil];
}

///// google

- (void)dealloc
{
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    [pageIndicatorView removeFromSuperview];
    pageIndicatorView = nil;
    
    [infoArray removeAllObjects];
    infoArray = nil;
    

}
@end
