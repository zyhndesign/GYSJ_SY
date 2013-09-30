//
//  ImageLoadNet.h
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface ImageLoadNet : NSObject
{
    NSMutableData *backData;
}
@property(nonatomic, weak)id<NetworkDelegate>delegate;

- (void)loadImageFromUrl:(NSString*)imageURLStr;
@end
