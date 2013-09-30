//
//  TimeChangeDelegate.h
//  GYSJ
//
//  Created by sunyong on 13-7-29.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimeChangeDelegate <NSObject>

@optional
- (void)TimeViewArriveYear:(int)year;
- (void)TimeViewMoveStop;

- (void)menuViewMoveYears:(float)posX;
- (void)menuviewMoveStop:(int)years;
- (void)menuViewMoveYearBorder:(float)posX;
@end

///
@protocol MapRuleFilterDelegate <NSObject>

- (void)MapRuleFilterShow;

@end


@protocol FilterChangeDelegate <NSObject>

@optional
- (void)FilterSelectInfo:(int)type Title:(NSString*)title;
- (void)dismisFilterView;

@end

