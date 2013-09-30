//
//  QueueHanle.m
//  GYSJ
//
//  Created by sunyong on 13-9-24.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueProHanle.h"
#import "ProImageLoadNet.h"
///  NSOperationQueue *test;

@implementation QueueProHanle

static int  finishTaskCount = 0;
static NSMutableArray *allTaskAry;
+ (void)init
{
    if (!allTaskAry)
    {
        allTaskAry = [[NSMutableArray alloc] init];
    }
    
}

+ (void)addTarget:(id)target
{
    if (allTaskAry.count == finishTaskCount)
    {
        [allTaskAry addObject:target];
        ProImageLoadNet *tempProNet = (ProImageLoadNet*)target;
        [tempProNet loadImageFromUrl];
    }
    else
        [allTaskAry addObject:target];
}

+ (void)taskFinish
{
    finishTaskCount++;
    if (allTaskAry.count > finishTaskCount)
    {
        ProImageLoadNet *tempProNet = (ProImageLoadNet*)[allTaskAry objectAtIndex:finishTaskCount];
        [tempProNet loadImageFromUrl];
        [allTaskAry removeObjectAtIndex:finishTaskCount-1];
        finishTaskCount--;
    }
    else if (allTaskAry.count == finishTaskCount)
    {
        [allTaskAry removeObjectAtIndex:finishTaskCount-1];
        finishTaskCount--;
    }
    else;
    NSLog(@"pro:%d", allTaskAry.count);
}

@end
