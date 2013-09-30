//
//  DataHandle.h
//  GYSJ
//
//  Created by sunyong on 13-8-8.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandle : NSObject

+ (NSMutableArray*)DHdeleteRepeatFromAry:(NSArray*)initArray;
+ (void)sortArray:(NSMutableArray *)initArray indexUniqueID:(NSMutableArray*)uniqueID;
@end
