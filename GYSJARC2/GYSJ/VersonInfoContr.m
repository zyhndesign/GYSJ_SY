//
//  VersonInfoContr.m
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "VersonInfoContr.h"

@interface VersonInfoContr ()

@end

@implementation VersonInfoContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithButton:(UIButton*)sender
{
    self = [super init];
    if (self)
    {
        senderBt = sender;
    }
    return self;
}
- (void)viewDidLoad
{
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"about_info" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [_webView loadRequest:request];
    
//    NSURL *baseURL = [NSURL URLWithString:filePath relativeToURL:[NSURL fileURLWithPath:[filePath stringByDeletingLastPathComponent] isDirectory:YES]];
//    [_webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    
    id scroller = [_webView.subviews objectAtIndex:0];
    for(UIView *subView in [scroller subviews])
    {
        if ([[[subView class] description] isEqualToString:@"UIImageView"])
        {
            subView.hidden = YES;
        }
    }
    _webView.scrollView.showsVerticalScrollIndicator   = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (IBAction)back:(UIButton*)sender
{
    [senderBt setBackgroundImage:[UIImage imageNamed:@"btn_info_gray.png"] forState:UIControlStateNormal];
    [self clearAllUIWebViewData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearAllUIWebViewData {
	// Clear the webview cache...
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[self removeApplicationLibraryDirectoryWithDirectory:@"Caches"];
	[self removeApplicationLibraryDirectoryWithDirectory:@"WebKit"];
    [self removeApplicationLibraryDirectoryWithDirectory:@"Cookies"];
	// Empty the cookie jar...
	for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)removeApplicationLibraryDirectoryWithDirectory:(NSString *)dirName {
	NSString *dir = [[[[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:dirName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:dir]){
		[[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
	}
}

- (void)dealloc
{
    senderBt = nil;
    [_webView removeFromSuperview];
    _webView = nil;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

@end
