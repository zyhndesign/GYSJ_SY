//
//  LoadZipFileNet.h
//  GYSJ
//
//  Created by sunyong on 13-8-2.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDelegate.h"

@interface LoadZipFileNet : NSObject
{
    NSMutableData *backData;
    NSString *zipStr;
    NSURLConnection *connect;
    int connectNum;
}
@property(nonatomic, weak)id<NetworkDelegate>delegate;
@property(nonatomic, strong)NSString *md5Str;
@property(nonatomic, strong)NSString *urlStr;
@property(nonatomic, strong)NSString *zipStr;
@property(nonatomic, assign)float zipSize;

- (void)loadMenuFromUrl;
- (void)cancelLoad;
@end
