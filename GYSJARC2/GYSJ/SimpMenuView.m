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
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
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
    [self addBaseView];
    [self addDataToView:_infoDict];
    [self addImageV];
}

#define startImVX 0
#define startLbX 27

- (void)addBaseView
{
    imageViewPro = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, ImageWidth, ImageHeigh)];
    [self addSubview:imageViewPro];
    titleTextV = [[UITextView alloc] initWithFrame:CGRectMake(SimpMenuWidth - 200, 6, 190, 300)];
    titleTextV.textColor = LabelBgColor;
    titleTextV.font = [UIFont boldSystemFontOfSize:37];
    titleTextV.backgroundColor = [UIColor clearColor];
    titleTextV.scrollEnabled   = NO;
    titleTextV.editable        = NO;
    [self addSubview:titleTextV];
    
    midLineLB = [[UILabel alloc] init];
    midLineLB.backgroundColor = LabelBgTwoColor;
    [self addSubview:midLineLB];
    
    imageVFu2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_date_gray.png.png"]];
    lbFu2 = [[UILabel alloc] init];
    lbFu2.font = [UIFont systemFontOfSize:15];
    lbFu2.textColor = LabelFontColor;
    lbFu2.backgroundColor = [UIColor clearColor];
    [self addSubview:imageVFu2];
    [self addSubview:lbFu2];
    
    imageVFu1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_genre_gray.png"]];
    lbFu1 = [[UILabel alloc] init];
    lbFu1.font = [UIFont systemFontOfSize:15];
    lbFu1.textColor = LabelFontColor;
    lbFu1.backgroundColor = [UIColor clearColor];
    [self addSubview:imageVFu1];
    [self addSubview:lbFu1];
    
    imageVOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location_gray.png"]];
    lbOne = [[UILabel alloc] init];
    lbOne.font = [UIFont systemFontOfSize:15];
    lbOne.textColor = LabelFontColor;
    lbOne.backgroundColor = [UIColor clearColor];
    [self addSubview:imageVOne];
    [self addSubview:lbOne];
    
    imageVTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_people_gray.png"]];
    lbTwo = [[UILabel alloc] init];
    lbTwo.font = [UIFont systemFontOfSize:15];
    lbTwo.backgroundColor = [UIColor clearColor];
    lbTwo.textColor = LabelFontColor;
    [self addSubview:imageVTwo];
    [self addSubview:lbTwo];
    
    imageVThr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_orgnization_gray.png"]];
    lbThr = [[UILabel alloc] init];
    lbThr.font = [UIFont systemFontOfSize:15];
    lbThr.textColor = LabelFontColor;
    lbThr.backgroundColor = [UIColor clearColor];
    [self addSubview:imageVThr];
    [self addSubview:lbThr];
}

- (void)addDataToView:(NSDictionary*)infoDict
{
    _infoDict = infoDict;

    imageVFu1.hidden = YES;
    lbFu1.hidden     = YES;
    imageVFu2.hidden = YES;
    lbFu2.hidden     = YES;
    imageVOne.hidden = YES;
    lbOne.hidden     = YES;
    imageVTwo.hidden = YES;
    lbTwo.hidden     = YES;
    imageVThr.hidden = YES;
    lbThr.hidden     = YES;
    
    titleTextV.text = [_infoDict objectForKey:@"name"];
    
    NSString *artitStr = [infoDict objectForKey:@"artists"];
    NSString *cityStr  = [infoDict objectForKey:@"city"];
    NSString *genreStr = [infoDict objectForKey:@"genre"];
    NSString *organStr = [infoDict objectForKey:@"organizations"];
    NSString *yearStr  = [infoDict objectForKey:@"year"];

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
    
    [midLineLB setFrame:CGRectMake(startX, startY+5, 180, 1)];
    
    int position = 0;
    if (yearStr.length > 0)
    {
        imageVFu2.hidden = NO;
        lbFu2.hidden     = NO;
        [imageVFu2 setFrame:CGRectMake(startX + startImVX,startY + 20+position*30, 20, 20)];
        [lbFu2 setFrame:CGRectMake(startX+startLbX, startY+20+position*30 - 1, 162, 20)];
        lbFu2.text = yearStr;
        position++;
    }
    if (genreStr.length > 0)
    {
        imageVFu1.hidden = NO;
        lbFu1.hidden     = NO;
        imageVFu1.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        [lbFu1 setFrame:CGRectMake(startX + startLbX,startY+20+position*30 - 1, 162, 20)];
        lbFu1.text = genreStr;
        position++;
    }
    
    if (cityStr.length > 0)
    {
        imageVOne.hidden = NO;
        lbOne.hidden     = NO;
        imageVOne.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        [lbOne setFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbOne.text = cityStr;
        position++;
    }
    
    if (artitStr.length > 0)
    {
        imageVTwo.hidden = NO;
        lbTwo.hidden     = NO;
        imageVTwo.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        [lbTwo setFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbTwo.text = artitStr;
        position++;
    }
    if (organStr.length > 0)
    {
        imageVThr.hidden = NO;
        lbThr.hidden     = NO;
        imageVThr.frame = CGRectMake(startX + startImVX, startY + 20+position*30, 20, 20);
        [lbThr setFrame:CGRectMake(startX + startLbX, startY + 20+position*30 - 1, 162, 20)];
        lbThr.text = organStr;
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
        UIImage *image = [UIImage imageWithContentsOfFile:pathProFile];
        if (image)
        {
            imageViewPro.image = image;
        }
        else
        {
            imageViewPro.image = [UIImage imageNamed:@"default_event_poster.png"];
        }
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
    NSLog(@"imageError:%@", [Error debugDescription]);
}

- (void)didReciveImage:(UIImage *)backImage
{
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    NSString *BgUrlStr = [_infoDict objectForKey:@"background"];
    NSString *BgImgeFormat = [[BgUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",_idStr, proImgeFormat]];
    NSString *pathBgFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"BgImage/%@.%@",_idStr, BgImgeFormat]];
    
    if (backImage)
        imageViewPro.image = backImage;
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:pathProFile error:nil];
        imageViewPro.image = [UIImage imageNamed:@"default_event_poster.png"];
    }
    
    imageBg = [UIImage imageWithContentsOfFile:pathBgFile];
    imageName = pathBgFile;
    
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
