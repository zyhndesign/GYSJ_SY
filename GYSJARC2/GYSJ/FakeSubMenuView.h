//
//  FakeSubMenuView.h
//  GYSJ
//
//  Created by sunyong on 13-9-30.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SimpMenuView;

@interface FakeSubMenuView : UIView
{
    UILabel *timeLabel;
  
    SimpMenuView *simpleMenuV;
    NSMutableArray *infoArray;
}
@property(nonatomic)NSMutableArray *infoArray;//动态数据
@property(nonatomic)NSDictionary *infoDict;
@end
