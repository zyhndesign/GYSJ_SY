//
//  ImageLoadNet.m
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ImageLoadNet.h"

@implementation ImageLoadNet
@synthesize delegate;

- (void)loadImageFromUrl:(NSString*)imageURLStr
{
  //  imageURLStr = [imageURLStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    imageURLStr = [imageURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageURLStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connectNet = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connectNet)
    {
        backData = [[NSMutableData alloc] init];
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
    UIImage *image = [UIImage imageWithData:backData];
    if (image == nil)
        [delegate didReceiveErrorCode:nil];
    if (delegate && [delegate respondsToSelector:@selector(didReciveImage:)])
    {
        [delegate didReciveImage:image];
    }
}

- (void)dealloc
{
    backData = nil;
    
}

@end
