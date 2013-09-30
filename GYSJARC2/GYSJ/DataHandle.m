//
//  DataHandle.m
//  GYSJ
//
//  Created by sunyong on 13-8-8.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "DataHandle.h"
#import "pinyin.h"

@implementation DataHandle

+ (NSMutableArray*)DHdeleteRepeatFromAry:(NSArray*)initArray
{
    if (initArray.count == 0)
        return nil;
    NSMutableArray *backAry = [NSMutableArray arrayWithObject:[initArray objectAtIndex:0]];
    for (int i = 1; i < initArray.count; i++)
    {
        NSString *dataStr = [initArray objectAtIndex:i];
        BOOL isEqual = NO;
        for (int j = 0; j < backAry.count; j++)
        {
            NSString *compareStr = [backAry objectAtIndex:j];
            if ([compareStr isEqualToString:dataStr])
            {
                isEqual = YES;
                break;
            }
        }
        if (!isEqual)
            [backAry addObject:dataStr];
    }
    return backAry;
}

// 数组排序
+ (void)sortArray:(NSMutableArray *)initArray indexUniqueID:(NSMutableArray*)uniqueID
{
    if (initArray == nil) return ;
    for (int i = 0; i < [initArray count]; i++)
    {
        for (int j = i + 1; j < [initArray count]; j++)
        {
            NSString *stringX = [initArray objectAtIndex:i];
            NSString *stringY = [initArray objectAtIndex:j];
            if ([stringY length] < 1 || [stringX length] < 1)
            {
                continue;
            }
            int length = [stringX length] > [stringY length] ? [stringY length] : [stringX length];
            for ( int k = 0; k < length; k++)
            {
                char x = [DataHandle hanziFirstLetter:stringX];
                char y = [DataHandle hanziFirstLetter:stringY];
                if (x > y)
                {
                    NSString *tempstr = [initArray objectAtIndex:i];
                    [initArray replaceObjectAtIndex:i withObject:[initArray objectAtIndex:j]];
                    [initArray replaceObjectAtIndex:j withObject:tempstr];
                    
                    if (uniqueID != nil)
                    {
                        NSString *tempID = [uniqueID objectAtIndex:i];
                        [uniqueID replaceObjectAtIndex:i withObject:[uniqueID objectAtIndex:j]];
                        [uniqueID replaceObjectAtIndex:j withObject:tempID];
                    }
                    break ;
                }
                else if (x < y)
                    break ;
                else
                    continue;
            }
        }
    }
}

+ (char)hanziFirstLetter:(NSString*)stringX
{
    if (stringX.length < 1)
    {
        return 0;
    }
    NSRange rang = NSMakeRange(0, 1);
    NSString *tempX = [stringX substringWithRange:rang];
    char X = 0;
    if([tempX isEqualToString:@"曾"])//多音字按姓氏发音分区
        X = 'z';
    else if([tempX isEqualToString:@"解"])
        X = 'x';
    else if([tempX isEqualToString:@"仇"])
        X = 'q';
    else if([tempX isEqualToString:@"朴"])
        X = 'p';
    else if([tempX isEqualToString:@"查"])
        X = 'z';
    else if([tempX isEqualToString:@"能"])
        X = 'n';
    else if([tempX isEqualToString:@"乐"])
        X = 'y';
    else if([tempX isEqualToString:@"单"])
        X = 's';
    else
        X = pinyinFirstLetter([[stringX lowercaseString] characterAtIndex:0]);
    return X;
}

@end
