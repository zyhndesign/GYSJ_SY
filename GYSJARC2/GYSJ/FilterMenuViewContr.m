//
//  FilterMenuViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-7-30.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#define ButtonHeigh 60

#import "FilterMenuViewContr.h"
#import "LocalSQL.h"
#import "DataHandle.h"
#import "MenuViewContr.h"
#import "ViewController.h"
#import "MapRuleViewContr.h"
#import <QuartzCore/QuartzCore.h>
#import "AllVarible.h"
#import "SubMenuView.h"


@interface FilterMenuViewContr ()

@end

@implementation FilterMenuViewContr
@synthesize delegate;
@synthesize currentFilterStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        filterType = GenerType;
    }
    return self;
}

- (void)viewDidLoad
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [touchView addGestureRecognizer:tapGesture];

    menuTitleAry = [[NSMutableArray alloc] init];
    [LocalSQL openDataBase];
    NSMutableArray *infoGenerArray = [LocalSQL getAllGener];
    NSString *allGenerStr = [infoGenerArray objectAtIndex:0];
    for (int i = 1; i < infoGenerArray.count; i++)
        allGenerStr = [NSString stringWithFormat:@"%@，%@", allGenerStr, [infoGenerArray objectAtIndex:i]];
    infoGenerArray = [DataHandle DHdeleteRepeatFromAry:[allGenerStr componentsSeparatedByString:@"，"]];
    
    NSMutableArray *tempAry = [NSMutableArray arrayWithArray:infoGenerArray];
    [DataHandle sortArray:tempAry indexUniqueID:infoGenerArray];
    [menuTitleAry addObject:infoGenerArray];
    
    NSMutableArray *infoPersonArray = [LocalSQL getAllPerson];
    NSString *allPersonStr = [infoPersonArray objectAtIndex:0];
    for (int i = 1; i < infoPersonArray.count; i++)
        allPersonStr = [NSString stringWithFormat:@"%@，%@", allPersonStr, [infoPersonArray objectAtIndex:i]];
    infoPersonArray = [DataHandle DHdeleteRepeatFromAry:[allPersonStr componentsSeparatedByString:@"，"]];
    tempAry = [NSMutableArray arrayWithArray:infoPersonArray];
    [DataHandle sortArray:tempAry indexUniqueID:infoPersonArray];
    [menuTitleAry addObject:infoPersonArray];
    
    
    NSMutableArray *infoCompanyArray = [LocalSQL getAllCompany];
    NSString *allCompanyStr = [infoCompanyArray objectAtIndex:0];
    for (int i = 1; i < infoCompanyArray.count; i++)
        allCompanyStr = [NSString stringWithFormat:@"%@，%@", allCompanyStr, [infoCompanyArray objectAtIndex:i]];
    infoCompanyArray = [DataHandle DHdeleteRepeatFromAry:[allCompanyStr componentsSeparatedByString:@"，"]];
    tempAry = [NSMutableArray arrayWithArray:infoCompanyArray];
    [DataHandle sortArray:tempAry indexUniqueID:infoCompanyArray];
    [menuTitleAry addObject:infoCompanyArray];
    
    [LocalSQL closeDataBase];
    
    [super viewDidLoad];

    separateLb.backgroundColor = LabelBgColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.shadowOpacity = 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tapView:(UITapGestureRecognizer*)gesture
{
    [delegate dismisFilterView];
}

- (void)loadMenuType:(int)type
{
    
}

- (IBAction)filterBt:(UIButton*)sender
{
    if (sender.tag == GenerType)
    {
        filterType = GenerType;
        [generBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_genre_gold.png"] forState:UIControlStateNormal];
        [personBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_people_gray.png"] forState:UIControlStateNormal];
        [companyBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_company_gray.png"] forState:UIControlStateNormal];
    }
    else if(sender.tag == PeopleType)
    {
        filterType = PeopleType;
        [generBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_genre_gray.png"] forState:UIControlStateNormal];
        [personBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_people_gold.png"] forState:UIControlStateNormal];
        [companyBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_company_gray.png"] forState:UIControlStateNormal];
    }
    else
    {
        filterType = CompaynType;
        [generBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_genre_gray.png"] forState:UIControlStateNormal];
        [personBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_people_gray.png"] forState:UIControlStateNormal];
        [companyBt setBackgroundImage:[UIImage imageNamed:@"filter_tab_company_gold.png"] forState:UIControlStateNormal];
    }
    [filterTableV reloadData];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentCell)
        currentCell.textLabel.textColor = [UIColor blackColor];
    if (filterType == GenerType)
        return [[menuTitleAry objectAtIndex:0] count];
    else if(filterType == PeopleType)
        return [[menuTitleAry objectAtIndex:1] count];
    else
        return [[menuTitleAry lastObject] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellS";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (filterType == GenerType)
    {
        cell.textLabel.text = [[menuTitleAry objectAtIndex:0] objectAtIndex:indexPath.row];
    }
    else if(filterType == PeopleType)
    {
        cell.textLabel.text = [[menuTitleAry objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [[menuTitleAry lastObject] objectAtIndex:indexPath.row];
    }
    if (currentFilterStr && [currentFilterStr isEqualToString:cell.textLabel.text])
    {
        cell.textLabel.textColor = LabelBgColor;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCell)
        currentCell.textLabel.textColor = [UIColor blackColor];
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    tempCell.textLabel.textColor = LabelBgColor;
    currentCell = tempCell;
    currentFilterStr = tempCell.textLabel.text;
    [self filterTitle:tempCell.textLabel.text];
}

/////  选择条件
- (void)filterTitle:(NSString*)conditionStr
{
    UIView *view = [self.view superview];
    view.hidden = YES;  // 筛选器隐藏 shai
   
    [delegate FilterSelectInfo:filterType Title:conditionStr]; //修改viewControl界面

    [NSThread detachNewThreadSelector:@selector(datahanle:) toTarget:self withObject:conditionStr];
    
    RootViewContr.stopAllView.hidden = NO;
   
}

//// 关闭条件
- (void)setCurrentFilterStr:(NSString *)_currentFilterStr
{
    if (currentFilterStr)
    {
        currentFilterStr = nil;
    }
    if (_currentFilterStr.length == 0 && currentCell)
    {
        currentCell.textLabel.textColor = [UIColor blackColor];
        currentCell = nil;
    }
}

#pragma mark - thread
- (void)datahanle:(NSString*)title
{
    @autoreleasepool {
        NSArray *tempArray = nil;
        [LocalSQL openDataBase];
        tempArray = [LocalSQL getAllDateFromConditionType:filterType condition:title];
        [LocalSQL closeDataBase];
        [self performSelector:@selector(viewUpdate:) onThread:[NSThread mainThread] withObject:tempArray waitUntilDone:NO];
    }
}

///// 过滤view更新
- (void)viewUpdate:(NSArray*)tempArray
{
    @autoreleasepool {
        isScrollAnim = 0;
        [AllMapRuleViewContr hiddenMapDetail];
        
        /// 更改背景图   先缓存过滤模式前的数据，在替换模式
        int cusmPage = (int)AllMenuScrollV.contentOffset.x/MenuViewWidth;
        SubMenuView  *cusmSubMenuVMid = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag + cusmPage];
        SimpMenuView *cusmSimpMview = (SimpMenuView*)[cusmSubMenuVMid._scrollView viewWithTag:(cusmSubMenuVMid._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
        ////// 删除操作 开启过滤模式，并修改相关内容
        [AllMenuViewContr filterModel:tempArray];
        SubMenuView  *filterCurrentSubmenuV = (SubMenuView*)[AllMenuScrollV viewWithTag:MenuStartTag];
        SimpMenuView *filterSimpView = (SimpMenuView*)[filterCurrentSubmenuV._scrollView viewWithTag:(filterCurrentSubmenuV._scrollView.contentOffset.y/SimpMenuHeigh+1)*10];
        if (filterCurrentSubmenuV && ![cusmSimpMview._idStr isEqualToString:filterSimpView._idStr])  // 同一张不换
        {
            [MenuViewContr scrollStopUpdaBgImage];
        }
        [AllTimeSVContr changLabelStatus:filterCurrentSubmenuV.years];
        [MenuViewContr reloadMapInfo];
        RootViewContr.stopAllView.hidden = YES;
    }
}

- (void)dealloc
{
    [separateLb removeFromSuperview];
    separateLb = nil;
    [generBt removeFromSuperview];
    generBt = nil;
    [personBt removeFromSuperview];
    personBt = nil;
    [companyBt removeFromSuperview];
    companyBt = nil;
    
    
    
}



@end
