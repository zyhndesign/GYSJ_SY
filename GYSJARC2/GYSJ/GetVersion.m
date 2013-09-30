//
//  GetVersion.m
//  GYSJ
//
//  Created by sunyong on 13-9-16.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "GetVersion.h"
#import "JSONKit.h"

@implementation GetVersion
@synthesize delegate;

- (void)getVersonFromItunes
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=702715271"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:nil];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (connect)
    {
        backData = [NSMutableData data];
    }
    else
    {
        backData = nil;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(didReceiveErrorCode:)]) {
        [delegate didReceiveErrorCode:error];
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
    NSDictionary *backDict = [backData objectFromJSONDataWithParseOptions:JKParseOptionValidFlags error:nil];
    [delegate didReceiveData:backDict];
}

@end
