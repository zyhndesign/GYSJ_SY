//
//  SimpMenuView.m
//  GYSJ
//
//  Created by sunyong on 13-8-1.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "SimpMenuView.h"
#import "ViewController.h"
#import "MapRuleViewContr.h"
#import "AllVarible.h"
#import "MenuViewContr.h"

#import "SubMenuView.h"
#import "BGImageLoadNet.h"
#import "ProImageLoadNet.h"

#import "QueueProHanle.h"
#import "QueueBgImHandle.h"

#define ImageWidth 360
#define ImageHeigh 360

@implementation SimpMenuView
@synthesize positionP;
@synthesize _infoDict;
@synthesize imageName;
@synthesize imageBg;
@synthesize _idStr;
@synthesize isBgImage;
@synthesize isProImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self addSubviews];
    }
    return self;
}
- (id)initWithDict:(NSDictionary*)infoDict
{
    CGRect frame = frame = CGRectMake(0, 0, SimpMenuWidth, SimpMenuHeigh);
    self = [super initWithFrame:frame];
    if (self)
    {
        _infoDict = infoDict;
        _idStr    = [_infoDict objectForKey:@"id"];
        imageBg   = nil;
        imageName = nil;
        self.backgroundColor = [UIColor whiteColor];
        NSString *coordStr = [_infoDict objectForKey:@"coordinate"];
        NSArray *coordAry  = [coordStr componentsSeparatedByString:@","];
        if (coordAry.count == 2)
        {
            positionP.x = [[coordAry objectAtIndex:0] floatValue];
            positionP.y = [[coordAry lastObject] floatValue];
        }
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    imageViewPro = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ImageWidth, ImageHeigh)];
    [self addSubview:imageViewPro];
    [self addProInfoView];
    [self addImageV];
}

#define startImVX 0
#define startLbX 27
- (void)addProInfoView
{
    UITextView *titleTextV = [[UITextView alloc] initWithFrame:CGRectMake(SimpMenuWidth - 200, 6, 190, 300)];
    titleTextV.textColor = LabelBgColor;
    titleTextV.font = [UIFont boldSystemFontOfSize:37];
    titleTextV.text = [_infoDict objectForKey:@"name"];
    titleTextV.backgroundColor = [UIColor clearColor];
    titleTextV.scrollEnabled   = NO;
    titleTextV.editable        = NO;
    [self addSubview:titleTextV];
    titleTextV = nil;
    
    NSString *artitStr = [_infoDict objectForKey:@"artists"];
    NSString *cityStr  = [_infoDict objectForKey:@"city"];
    NSString *genreStr = [_infoDict objectForKey:@"genre"];
    NSString *organStr = [_infoDict objectForKey:@"organizations"];
    NSString *yearStr  = [_infoDict objectForKey:@"year"];
    
    int count = 0;
    if (yearStr.length > 0)
    {
        if ([yearStr isEqualToString:@"0000"])
            yearStr = @"工业革命前";
        count++;
    }
    if (genreStr.length > 0)
        count++;
    if(cityStr.length > 0)
        count++;
    if(artitStr.length > 0)
        count++;
    if(organStr.length > 0)
        count++;
    /////// 计算出开始位置
    int startX = SimpMenuWidth - 200;
    int startY = 404 - count*30 - 20 - 10;
    
    UILabel *midLineLB = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY+5, 180, 1)];
    midLineLB.backgroundColor = LabelBgTwoColor;
    [self addSubview:midLineLB];
    midLineLB = nil;
    
    int position = 0;
    if (yearStr.length > 0)
    {
        UIImageView *imageVFu2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_date_gray.png.png"]];
        imageVFu2.frame = CGRectMake(startX + startImVX,startY + 20+position*30, 20, 20);
        UILabel *lbFu2 = [[UILabel alloc] initWithFrame:CGRectMake(startX+startLbX, startY+20+position*30 - 1, 162, 20)];
        lbFu2.text = yearStr;
        lbFu2.font = [UIFont systemFontOfSize:15];
        lbFu2.textColor = LabelFontColor;
        lbFu2.backgroundColor = [UIColor clearColor];
        [self addSubview:imageVFu2];
        [self addSubview:lbFu2];
        imageVFu2 = nil;
        lbFu2 = nil;
        
        position++;
    }
    if (genreStr.length > 0)
    {
        UIImageView *imageVFu1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_genre_gray.png"]];
        imageVFu1.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        UILabel *lbFu1 = [[UILabel alloc] initWithFrame:CGRectMake(startX + startLbX,startY+20+position*30 - 1, 162, 20)];
        lbFu1.text = genreStr;
        lbFu1.font = [UIFont systemFontOfSize:15];
        lbFu1.textColor = LabelFontColor;
        lbFu1.backgroundColor = [UIColor clearColor];
        [self addSubview:imageVFu1];
        [self addSubview:lbFu1];
        imageVFu1 = nil;
        lbFu1 = nil;
        
        position++;
    }
    
    if (cityStr.length > 0)
    {
        UIImageView *imageVOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location_gray.png"]];
        imageVOne.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        UILabel *lbOne = [[UILabel alloc] initWithFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbOne.text = cityStr;
        lbOne.font = [UIFont systemFontOfSize:15];
        lbOne.textColor = LabelFontColor;
        lbOne.backgroundColor = [UIColor clearColor];
        [self addSubview:imageVOne];
        [self addSubview:lbOne];
        imageVOne = nil;
        lbOne = nil;
        
        position++;
    }
    
    if (artitStr.length > 0)
    {
        UIImageView *imageVTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_people_gray.png"]];
        imageVTwo.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        UILabel *lbTwo = [[UILabel alloc] initWithFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbTwo.text = artitStr;
        lbTwo.font = [UIFont systemFontOfSize:15];
        lbTwo.backgroundColor = [UIColor clearColor];
        lbTwo.textColor = LabelFontColor;
        [self addSubview:imageVTwo];
        [self addSubview:lbTwo];
        imageVTwo = nil;
        lbTwo = nil;
        
        position++;
    }
    if (organStr.length > 0)
    {
        UIImageView *imageVThr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_orgnization_gray.png"]];
        imageVThr.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        UILabel *lbThr = [[UILabel alloc] initWithFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbThr.text = organStr;
        lbThr.font = [UIFont systemFontOfSize:15];
        lbThr.textColor = LabelFontColor;
        lbThr.backgroundColor = [UIColor clearColor];
        [self addSubview:imageVThr];
        [self addSubview:lbThr];
        imageVThr = nil;
        lbThr = nil;
    }
}


- (void)addImageV
{
    // rect = CGRectMake(20, 20, ImageWidth, ImageHeigh);
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    NSString *BgUrlStr = [_infoDict objectForKey:@"background"];
    NSString *BgImgeFormat = [[BgUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",_idStr, proImgeFormat]];
    NSString *pathBgFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"BgImage/%@.%@",_idStr, BgImgeFormat]];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:pathBgFile])
    {
        isBgImage = YES;
        imageBg   = [UIImage imageWithContentsOfFile:pathBgFile];
        imageName = pathBgFile;
    }
    else
    {
        imageBg  = nil;
        imageName = nil;
        if ([[_infoDict objectForKey:@"background"] length] > 0)
            [self startLoadBgImageData];
    }
    if ([fileManage fileExistsAtPath:pathProFile])
    {
        isProImage = YES;
        imageViewPro.image = [UIImage imageWithContentsOfFile:pathProFile];
    }
    else
    {
        imageViewPro.image = [UIImage imageNamed:@"default_event_poster.png"];
        if ([[_infoDict objectForKey:@"profile"] length] > 0)
            [self startLoadProImageData];
    }
}

- (void)startLoadBgImageData
{
    BGImageLoadNet *bgImageLNet = [[BGImageLoadNet alloc] initWithDict:_infoDict];
    bgImageLNet.delegate = self;
    [QueueBgImHandle addTarget:bgImageLNet];
}

- (void)startLoadProImageData
{
    ProImageLoadNet *proImageLNet = [[ProImageLoadNet alloc] initWithDict:_infoDict];
    proImageLNet.delegate = self;
    [QueueProHanle addTarget:proImageLNet];
}
#pragma mark - network delegate

- (void)didReceiveErrorCode:(NSError *)Error
{
   
}

- (void)didReciveImage:(UIImage *)backImage
{
    
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    NSString *BgUrlStr = [_infoDict objectForKey:@"background"];
    NSString *BgImgeFormat = [[BgUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",_idStr, proImgeFormat]];
    NSString *pathBgFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"BgImage/%@.%@",_idStr, BgImgeFormat]];
    
    imageBg = [UIImage imageWithContentsOfFile:pathBgFile];
    imageName = pathBgFile;
    imageViewPro.image = [UIImage imageWithContentsOfFile:pathProFile];
    
    SubMenuView *subMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:AllMenuScrollV.contentOffset.x/MenuViewWidth + MenuStartTag];
    if (subMenuVMid.years == [[_infoDict objectForKey:@"year"] integerValue])
    {
        [AllMapRuleViewContr updateMapImage];
        [MenuViewContr scrollStopUpdaBgImage];
    }
}

- (void)dealloc
{
    [imageViewPro removeFromSuperview];
    imageViewPro = nil;
    _infoDict = nil;
    imageName = nil;
    imageBg   = nil;
    _idStr    = nil;
}

@end
