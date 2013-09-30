//
//  QueueBgImHandle.m
//  GYSJ
//
//  Created by sunyong on 13-9-24.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueBgImHandle.h"
#import "BGImageLoadNet.h"

@implementation QueueBgImHandle


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
        BGImageLoadNet *tempProNet = (BGImageLoadNet*)target;
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
        BGImageLoadNet *tempProNet = (BGImageLoadNet*)[allTaskAry objectAtIndex:finishTaskCount];
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
    NSLog(@"Bg:%d", allTaskAry.count);
}


@end
