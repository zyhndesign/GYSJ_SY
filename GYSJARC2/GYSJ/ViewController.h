//
//  ViewController.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSViewContr.h"
#import "MenuViewContr.h"
#import "MapRuleViewContr.h"
#import "FilterMenuViewContr.h"
#import "NetworkDelegate.h"
//#import "GAITrackedViewController.h"
//#import "GAI.h"

@interface ViewController : UIViewController<NetworkDelegate, FilterChangeDelegate, UIAlertViewDelegate>
{
    IBOutlet UIView *timeSelectView;
    IBOutlet UIView *menuView;
    IBOutlet UIView *mapView;
    IBOutlet UIView *filterView;
    IBOutlet UIView *stopAllView;   //阻隔一切的界面
    
    IBOutlet UIView *selectConditionView;  // 条件的选择内容 改子视图里的btTag为10,20，LbTag为30
    IBOutlet UIView *shadowView; // 筛选小标签内容的投影
    
    IBOutlet UIImageView *bgImageView;
    
    TimeSViewContr *timeSViewContr;
    MenuViewContr *menuViewContr;
    MapRuleViewContr *mapRuleViewContr;
    FilterMenuViewContr *filterMenuViewContr;
    
    IBOutlet UIButton *versionInfoBt;
    IBOutlet UIView *launchView;
}

@property(nonatomic) IBOutlet UIView *stopAllView;
- (IBAction)mapShow:(UIButton*)sender;
- (IBAction)filterShow:(UIButton*)sender;
- (IBAction)closeCondition:(UIButton*)sender;
- (IBAction)versionInfoShow:(UIButton*)sender;


- (void)rebulidStopView;

@end
