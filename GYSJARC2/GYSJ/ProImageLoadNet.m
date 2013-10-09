//
//  ProImageLoadNet.m
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ProImageLoadNet.h"
#import "SimpMenuView.h"
#import "QueueProHanle.h"

@implementation ProImageLoadNet
@synthesize delegate;
@synthesize _infoDict;


- (id)initWithDict:(NSDictionary*)infoDict
{
    self = [super init];
    if (self) {
        _infoDict = infoDict;
    }
    return self;
}

- (void)loadImageFromUrl
{
    NSString *urlStr = [[_infoDict objectForKey:@"profile"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [NSString stringWithFormat:@"%@-300x300%@", [urlStr substringToIndex:urlStr.length-4], [urlStr substringFromIndex:urlStr.length-4]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        backData = nil;
        [delegate didReceiveErrorCode:nil];
    }
}

- (void)reloadUrlData
{
    [self loadImageFromUrl];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connectNum == 3)
    {
        SimpMenuView *tempSimMeV = (SimpMenuView*)delegate;
        tempSimMeV.isProImage = YES;
        if (tempSimMeV.isBgImage)
            [delegate didReceiveErrorCode:error];
        [QueueProHanle taskFinish];
    }
    else
    {
        connectNum++;
        [self reloadUrlData];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SimpMenuView *tempSimMeV = (SimpMenuView*)delegate;
    if (!tempSimMeV)
    {
        [QueueProHanle taskFinish];
        return;
    }
    tempSimMeV.isProImage = YES;
    [connection cancel];
    NSString *proUrlStr = [_infoDict objectForKey:@"profile"];
    NSString *proImgeFormat = [[proUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@", [_infoDict objectForKey:@"id"], proImgeFormat]];
    [backData writeToFile:pathProFile atomically:YES];
    
    if ([delegate respondsToSelector:@selector(didReciveImage:)])
    {
        if (tempSimMeV.isBgImage)
            [delegate didReciveImage:[UIImage imageWithData:backData]];
    }
    [QueueProHanle taskFinish];
}

- (void)dealloc
{
    delegate = nil;
    _infoDict = nil;
}

@end
