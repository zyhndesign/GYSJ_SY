//
//  QueueZipHandle.h
//  GYSJ
//
//  Created by sunyong on 13-9-24.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueZipHandle : NSObject
{
    
}
+ (void)init;
+ (void)addTarget:(id)target;
+ (void)taskFinish:(id)target;
@end
