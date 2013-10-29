//
//  MapRuleViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-30.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeChangeDelegate.h"
#import "BriefImageV.h"
@class SimpMenuView;
@class MBXMapView;
@interface MapRuleViewContr : UIViewController
{
    IBOutlet UIImageView *__weak bgImageV;
    IBOutlet UIScrollView *scrllView;
    
    IBOutlet UIView *contentView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextView *detailTextV;
    IBOutlet BriefImageV *briefImageV;
    
    float pointX;
    float pointY;
    SimpMenuView *_simpleMenuV;
    MBXMapView *mbXMapview;
}

@property(nonatomic, weak)IBOutlet UIImageView *bgImageV;
@property(nonatomic, weak)id<MapRuleFilterDelegate>delegate;

- (void)showMapDetail:(SimpMenuView*)simpleMenuV;
- (void)hiddenMapDetail;
- (void)updateMapImage;
@end
