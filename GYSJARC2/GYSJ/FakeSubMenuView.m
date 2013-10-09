//
//  FakeSubMenuView.m
//  GYSJ
//
//  Created by sunyong on 13-9-30.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "FakeSubMenuView.h"
#import "SimpMenuView.h"

@implementation FakeSubMenuView
@synthesize infoArray;
@synthesize infoDict;
- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, MenuViewWidth, MenuViewHeigh); //为阴影留空间
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        infoArray = [[NSMutableArray alloc] init];
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowRadius = 6;
//        self.layer.shadowOpacity = 0.4;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 40)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    //timeLabel.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(3*M_PI/2));
    timeLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:32];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.alpha = 0.4;
    timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:timeLabel];
    
    simpleMenuV = [[SimpMenuView alloc] init];
    simpleMenuV.frame = CGRectMake(60, 50, SimpMenuWidth, SimpMenuHeigh);
    [self addSubview:simpleMenuV];
}

- (void)setInfoArray:(NSMutableArray *)_infoArray
{
    NSDictionary *tempInfoDict = [_infoArray objectAtIndex:0];
    [simpleMenuV addDataToView:tempInfoDict];
    
    int year = [[tempInfoDict objectForKey:@"year"] integerValue];
    if (year < StartYear)
        timeLabel.text = [NSString stringWithFormat:@"工业设计革命前"];
    else
        timeLabel.text = [NSString stringWithFormat:@"%d", year];
}


@end
