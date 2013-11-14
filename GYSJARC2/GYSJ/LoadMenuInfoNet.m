//
//  LoadMenuInfoNet.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadMenuInfoNet.h"
#import "JSONKit.h"
#import "AllVarible.h"

@implementation LoadMenuInfoNet

@synthesize delegate;

- (void)loadMenuFromUrl
{
//    //// 192.168.1.18  ///lotusprize.com comdesignlab.com
    NSString *urlStr = nil;
    NSString *timestampLast = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"];
    if (timestampLast.length > 0 && !UpdateSQLColomn)
        urlStr = [NSString stringWithFormat:@"http://comdesignlab.com/hid/dataUpdate.json?lastUpdateDate=%@", timestampLast];
    else
        urlStr = [NSString stringWithFormat:@"http://comdesignlab.com/hid/dataUpdate.json?lastUpdateDate=0"];
    //urlStr = [NSString stringWithFormat:@"http://lotusprize.com/hid/dataUpdate.json?lastUpdateDate=0"];
   // urlStr = [NSString stringWithFormat:@"http://192.168.1.18/hid/dataUpdate.json?lastUpdateDate=0"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connect)
    {
        backData = [NSMutableData data];
    }
    else
    {
        backData = nil;
    }
}

- (void)reloadUrlData
{

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate didReceiveErrorCode:error];
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
