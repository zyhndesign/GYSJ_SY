//
//  subMenuView.h
//  GYSJ
//
//  Created by sunyong on 13-7-29.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpMenuView.h"

@interface SubMenuView : UIView<UIScrollViewDelegate>
{    
    UIScrollView *_scrollView;
    UIView *pageIndicatorView;
    NSMutableArray *infoArray;
}
@property(nonatomic)NSMutableArray *infoArray;//动态数据
@property(nonatomic, assign)int years;
@property(nonatomic)UIScrollView *_scrollView;
@property(nonatomic)UIView *pageIndicatorView;

- (void)moveStartStatus;
- (void)updateMapInfo;
- (void)builtView;
- (void)updageBgImage:(BOOL)isFirstLast;
//+ (void)updageBgImage:(UIImage *)newImage imageName:(NSString*)imageName; //// 更改背景图
- (BOOL)updatePageIndiView;
- (void)initBgImage;
/*
绘制界面有两种方法，
第一种方法是initdataAry属性法（里面封装的是第二种方法），
第二种是完善infoArray信息，再调用builtView
 */
@end
