//
//  QueueZipHandle.m
//  GYSJ
//
//  Created by sunyong on 13-9-24.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "QueueZipHandle.h"
#import "LoadZipFileNet.h"

@implementation QueueZipHandle
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
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)target;
        [tempProNet loadMenuFromUrl];
    }
    else
    {
        if (![QueueZipHandle isEixstInAry:allTaskAry zipNet:target])
        {
            [allTaskAry addObject:target];
        }
    }
}

+ (BOOL)isEixstInAry:(NSArray*)initAry zipNet:(LoadZipFileNet*)target
{
    NSArray *array = [NSArray arrayWithArray:initAry];
    for (int i = 0; i < array.count; i++)
    {
        LoadZipFileNet *zipNet = [array objectAtIndex:i];
        if ([zipNet.urlStr isEqualToString:target.urlStr])
        {
            return YES;
        }
    }
    return NO;
}


+ (void)taskFinish
{
    finishTaskCount++;
    if (allTaskAry.count > finishTaskCount)
    {
        LoadZipFileNet *tempProNet = (LoadZipFileNet*)[allTaskAry objectAtIndex:finishTaskCount];
        [tempProNet loadMenuFromUrl];
        [allTaskAry removeObjectAtIndex:finishTaskCount-1];
        finishTaskCount--;
    }
    else if (allTaskAry.count == finishTaskCount)
    {
        [allTaskAry removeObjectAtIndex:finishTaskCount-1];
        finishTaskCount--;
    }
    else;
    NSLog(@"zip:%d", allTaskAry.count);
}

@end
