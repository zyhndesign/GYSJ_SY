//
//  BGImageLoadNet.h
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface BGImageLoadNet : NSObject
{
    NSMutableData *backData;
    int connectNum;
    NSDictionary *_infoDict;
}
@property(nonatomic, weak)id<NetworkDelegate>delegate;
- (id)initWithDict:(NSDictionary*)infoDict;
- (void)loadImageFromUrl;
@end
