//
//  GetVersion.h
//  GYSJ
//
//  Created by sunyong on 13-9-16.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface GetVersion : NSObject
{
    NSMutableData *backData;
}
@property(nonatomic, weak)id<NetworkDelegate>delegate;

- (void)getVersonFromItunes;

@end
