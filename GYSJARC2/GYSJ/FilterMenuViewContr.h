//
//  FilterMenuViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-30.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeChangeDelegate.h"

@interface FilterMenuViewContr : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIView *shadowView;/// 设置投影
    IBOutlet UIView *touchView;
    IBOutlet UILabel *separateLb;
    IBOutlet UIButton *generBt;
    IBOutlet UIButton *personBt;
    IBOutlet UIButton *companyBt;

    NSMutableArray *menuTitleAry;
    
    int filterType; // 当前条件类型
    
    NSString *currentFilterStr;// 当前条件内容
    
    IBOutlet UITableView *filterTableV;
    UITableViewCell *currentCell;
}

@property(nonatomic, weak)id<FilterChangeDelegate>delegate;
@property(nonatomic)NSString *currentFilterStr;
- (void)loadMenuType:(int)type;

- (IBAction)filterBt:(UIButton*)sender;

@end
