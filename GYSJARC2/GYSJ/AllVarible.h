//
//  AllVarible.h
//  GYSJ
//
//  Created by sunyong on 13-9-4.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#ifndef GYSJ_AllVarible_h
#define GYSJ_AllVarible_h

#import <Foundation/Foundation.h>
#import "UIImageView+Name.h"


@class ViewController;
@class MapRuleViewContr;
@class MenuViewContr;
@class TimeSViewContr;
@class FilterMenuViewContr;

ViewController *RootViewContr;   //
UIImageView *AllBgImageView;
UIScrollView *AllTimeScrolV;   // 时间抽上的scrollv
UIScrollView *AllMenuScrollV;  // 菜单上的scrollv
UIScrollView *AllFakeScrollV; //// 假象scrollview menu
MapRuleViewContr *AllMapRuleViewContr;
MenuViewContr *AllMenuViewContr;
TimeSViewContr *AllTimeSVContr;
FilterMenuViewContr *AllFilterMenuVCtr;
/* 刷选功能视图逻辑   
有条件选择时 timeScrollV上的点重新删除重新布局， menuViewContr上的替换 

*/
NSMutableArray *AllInfoArray; ///// 从数据库读出来的所有数据，为刷选功能服务，但关闭条件选择就直接用这个数组
NSMutableDictionary *AllMenuPosition_YearDict;  /// MenuView 上作品位置key，value-Tag的对应关系
NSMutableDictionary *AllMenuYear_PositionDict;  /// MenuView 上key-Tag,作品位置value，的对应关系


#endif

/*
过滤器
 
 timeSviewContr和menuViewContr有两种模式，一种是customModel即没有刷选数据的模式，一种是刷选模式
 
 ///// 为了优化，各个模块之间相互嵌套，导致模块都没有独立出来
 customModel进入刷选模式中: timeSviewContr相关的数据重组，视图重组
                          menuViewContr相关的数据重组， 视图从的scrollview替换，隐藏_scrollView,用_filterScrollerV来重组数据（全局dict在该fiterModel中刷新）
 
 刷选模式进入customModel中: timeSviewContr相关的数据重组，视图重组（全局dict在该customModel中刷新）
                          menuViewContr相关的数据重组， 视图从的scrollview替换，隐藏_scrollView,用_filterScrollerV来重组数据
*/

