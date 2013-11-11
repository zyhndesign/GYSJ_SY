//
//  LoadZipFileNet.m
//  GYSJ
//
//  Created by sunyong on 13-8-2.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LoadZipFileNet.h"
#import "MFSP_MD5.h"
#import "ZipArchive.h"
#import "QueueZipHandle.h"
#import "ContentViewContr.h"

@implementation LoadZipFileNet

@synthesize delegate;
@synthesize md5Str;
@synthesize urlStr;
@synthesize zipStr;
@synthesize zipSize;

- (void)loadMenuFromUrl
{
    //http://lotusprize.com/travel/bundles/eae27d77ca20db309e056e3d2dcd7d69.zip
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (connect)
    {
        backData = [[NSMutableData alloc] init];
    }
}

- (void)cancelLoad
{
    if (connect)
        [connect cancel];
}

- (void)reloadUrlData
{    
    [self loadMenuFromUrl];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([error code] == -1009)
    {
        [QueueZipHandle taskFinish:self];
        if (!delegate&& [delegate respondsToSelector:@selector(didReceiveErrorCode:)])
        {
            [delegate didReceiveErrorCode:error];
        }
        
        return;
    }
    if (connectNum == 2)
    {
        [QueueZipHandle taskFinish:self];
        [delegate didReceiveErrorCode:error];
    }
    else
    {
        connectNum++;
       // NSLog(@"zip error:%d",connectNum);
        [self loadMenuFromUrl];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [backData appendData:data];
    ContentViewContr *contentVC = (ContentViewContr*)delegate;
    contentVC.progressV.progress = [backData length]/zipSize;
    int value = [backData length]/zipSize * 100;
    contentVC.proValueLb.text = [NSString stringWithFormat:@"%2d", value];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", zipStr]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:backData attributes:nil];
    
    if ([[MFSP_MD5 file_md5:filePath] isEqualToString:md5Str])
    {
        BOOL isResult = NO;
      //  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *unZipPath = path;
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        BOOL result;
        if ([zip UnzipOpenFile:filePath]) {
            result = [zip UnzipFileTo:unZipPath overWrite:YES];
            if (!result)
            {
                isResult = NO;
                [fileManager removeItemAtPath:filePath error:nil];
                [fileManager removeItemAtPath:unZipPath error:nil];
            }
            else
            {
                isResult = YES;
            }
            [zip UnzipCloseFile];
        }
        // 解压成功后，删除zip包
        if (isResult)
        {
            [fileManager removeItemAtPath:filePath error:nil];
            if (delegate != nil && [delegate respondsToSelector:@selector(didReceiveResult:)])
                [delegate didReceiveResult:isResult];
        }
        else
        {
            [delegate didReceiveErrorCode:nil];
        }
    }
    else
    {
        [fileManager removeItemAtPath:filePath error:nil];
        [delegate didReceiveErrorCode:nil];
    }
    [QueueZipHandle taskFinish:self];
}

- (void)dealloc
{
    md5Str = nil;
    urlStr = nil;
    zipStr = nil;
    connect = nil;
}

@end

