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
#import "MBXMapKit.h"
#import "JPSThumbnailAnnotation.h"

@class SimpMenuView;

@interface MapRuleViewContr : UIViewController<MKMapViewDelegate>
{
    IBOutlet UIImageView *__weak bgImageV;
    IBOutlet UIScrollView *scrllView;
    
    IBOutlet UIView *contentView;
    IBOutlet UIView *mapView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextView *detailTextV;
    IBOutlet BriefImageV *briefImageV;
    
    JPSThumbnailAnnotation *jpsThumbnailAnnt;
    
    float pointX;
    float pointY;
    SimpMenuView *_simpleMenuV;
    MBXMapView *mbXMapview;
    
    NSMutableData *backData;
}

@property(nonatomic, weak)IBOutlet UIImageView *bgImageV;
@property(nonatomic, weak)id<MapRuleFilterDelegate>delegate;

- (void)showMapDetail:(SimpMenuView*)simpleMenuV;
- (void)hiddenMapDetail;
- (void)updateMapImage;
- (void)contentShow;
@end
