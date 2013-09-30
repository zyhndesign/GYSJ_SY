//
//  BGImageLoadNet.m
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "BGImageLoadNet.h"
#import "SimpMenuView.h"
#import "QueueBgImHandle.h"

@implementation BGImageLoadNet
@synthesize delegate;

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
    NSString *urlStr = [[_infoDict objectForKey:@"background"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [NSString stringWithFormat:@"%@-800x600%@", [urlStr substringToIndex:urlStr.length-4], [urlStr substringFromIndex:urlStr.length-4]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:nil];
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        backData = [[NSMutableData alloc] init];
    }
    else
    {
        [delegate didReceiveErrorCode:nil];
        backData = nil;
    }
}

- (void)reloadUrlData
{
    [self loadImageFromUrl];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connectNum == 2)
    {
        SimpMenuView *tempSimMeV = (SimpMenuView*)delegate;
        tempSimMeV.isBgImage = YES;
        [QueueBgImHandle taskFinish];
        if (tempSimMeV.isProImage) 
            [delegate didReceiveErrorCode:error];
    }
    else
    {
        connectNum++;
        [self reloadUrlData];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SimpMenuView *tempSimMeV = (SimpMenuView*)delegate;
    if (!tempSimMeV)
        return;
    tempSimMeV.isBgImage = YES;
    [connection cancel];
    NSString *BgUrlStr = [_infoDict objectForKey:@"background"];
    NSString *BgImgeFormat = [[BgUrlStr componentsSeparatedByString:@"."] lastObject];
    
    NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"BgImage/%@.%@",[_infoDict objectForKey:@"id"], BgImgeFormat]];
    [backData writeToFile:pathProFile atomically:YES];
    
    if ([delegate respondsToSelector:@selector(didReciveImage:)])
    {
        if (tempSimMeV.isProImage)
            [delegate didReciveImage:nil];
    }
    [QueueBgImHandle taskFinish];
}


@end
