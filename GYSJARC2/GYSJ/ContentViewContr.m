//
//  ContentViewContr.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ContentViewContr.h"
#import "AppDelegate.h"
#import "MoviePlayViewContr.h"
#import "ImageViewShowContr.h"
#import "SubMenuView.h"
#import "QueueZipHandle.h"
#import "MenuViewContr.h"
#import "AllVarible.h"

@interface ContentViewContr ()

@end

@implementation ContentViewContr
@synthesize progressV;
@synthesize proMarkLb;
@synthesize proValueLb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithSimMenuV:(SimpMenuView*)simMenuView
{
    self = [super init];
    if (self)
    {
        initDict = simMenuView._infoDict;
    }
    return self;
}

- (void)viewDidLoad
{
    self.trackedViewName = @"content";
    [super viewDidLoad];
    
    progressV.progressTintColor = LabelBgColor;
    progressV.progress = 0.0f;
    
    infoDict = [[NSMutableDictionary alloc] init];
    
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
    _webView.scrollView.scrollsToTop = NO;
    _webView.scrollView.scrollEnabled = NO;
    NSString *doctPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *documentPath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [initDict objectForKey:@"id"]]];
    BOOL dirBOOL = YES;
    if([[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&dirBOOL])
    {
        [self webViewLoadLocalData];
        progressV.hidden  = YES;
        proValueLb.hidden = YES;
        proMarkLb.hidden  = YES;
    }
    else
    {
        [self startLoadSimpleZipData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)dealloc
{
    [_webView removeFromSuperview];
    _webView   = nil;
    [progressV removeFromSuperview];
    progressV  = nil;
    [proValueLb removeFromSuperview];
    proValueLb = nil;
    [proMarkLb removeFromSuperview];
    proMarkLb = nil;
    
    [infoDict removeAllObjects];
    infoDict = nil;
    initDict = nil;
    loadZipNet = nil;
    keyStr = nil;
}

- (void)startLoadSimpleZipData
{
    if ([[initDict objectForKey:@"url"] length] > 5)
    {
        loadZipNet = [[LoadZipFileNet alloc] init];
        loadZipNet.delegate = self;
        loadZipNet.urlStr   = [initDict  objectForKey:@"url"];
        loadZipNet.md5Str   = [[initDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        loadZipNet.zipStr   = [initDict  objectForKey:@"id"];
        loadZipNet.zipSize  = [[initDict objectForKey:@"size"] floatValue];
        [QueueZipHandle addTarget:loadZipNet];
    }
}

- (void)webViewLoadLocalData
{
    NSString *doctPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *filePath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc/main.pad.html", [initDict objectForKey:@"id"]]];
    NSString *baseUrl = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc", [initDict objectForKey:@"id"]]];
    
    BOOL doctm = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:baseUrl isDirectory:&doctm])
    {
        NSURLRequest *requestHttp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
        [_webView loadRequest:requestHttp];
        
        NSString *docXmlPath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc.xml", [initDict objectForKey:@"id"]]];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:docXmlPath]];
        xmlParser.delegate = self;
        [xmlParser parse];
    }
    
}

- (void)didReceiveResult:(BOOL)success
{
    progressV.hidden  = YES;
    proValueLb.hidden = YES;
    proMarkLb.hidden  = YES;
    [self webViewLoadLocalData];
}

- (void)didReceiveErrorCode:(NSError *)Error
{
    progressV.hidden  = YES;
    proValueLb.hidden = YES;
    proMarkLb.hidden  = YES;

    if ([Error code] == -1009)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

#pragma mark - xmlParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"showUrl"])
    {
        StartKey = YES;
    }
    else if([elementName isEqualToString:@"videoUrl"])
    {
        StartValue = YES;
    }
    else ;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (StartKey)
    {
        keyStr = [[NSString alloc] initWithString:string];
    }
    if (StartValue && string.length > 0)
    {
        [infoDict setObject:string forKey:keyStr];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    StartKey = NO;
    StartValue = NO;
}


- (IBAction)close:(UIButton*)sender
{
    if (loadZipNet)
    {
        [loadZipNet setDelegate:nil];
    }
    [_webView stopLoading];
    [_webView setDelegate:nil];
    [self clearAllUIWebViewData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearAllUIWebViewData
{
	// Clear the webview cache...
	[self removeApplicationLibraryDirectoryWithDirectory:@"Caches"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)removeApplicationLibraryDirectoryWithDirectory:(NSString *)dirName
{
	NSString *dir = [[[[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:dirName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:dir])
    {
		[[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
	}
}

- (void)moviePlayOver:(NSNotification*)notification
{
    self.view.hidden = NO;
}

#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [[request URL] description];
    if ([urlStr componentsSeparatedByString:@"show_image"].count > 1 || [urlStr componentsSeparatedByString:@"wp-content"].count > 1)
    {
        ImageViewShowContr *imageViewSContr = [[ImageViewShowContr alloc] initwithURL:urlStr];
        imageViewSContr.idStr = [initDict  objectForKey:@"id"];
        [self presentViewController:imageViewSContr animated:YES completion:nil];
        return NO;
    }
    else if ([urlStr componentsSeparatedByString:@"show_media"].count > 1)
    {
//        NSString *replaceStr = @"192.168.1.18";
//        NSString *testStr = @"lotusprize.com";
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:testStr withString:replaceStr];
        NSString *movieUrlStr = [infoDict objectForKey:urlStr];
        if (movieUrlStr.length < 1)
            return NO;
        ///http://lotusprize.com/travel/wp-content/uploads/211/dddd.mp4
        MoviePlayViewContr *moviePlayVCtr = [[MoviePlayViewContr alloc] initwithURL:movieUrlStr];
        [self presentViewController:moviePlayVCtr animated:YES completion:nil];
        return NO;
    }
    else if([urlStr componentsSeparatedByString:@"file:"].count > 1)
    {
        return YES;
    }
    else if([urlStr componentsSeparatedByString:@"http:"].count > 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        return NO;
    }
    else ;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webView.scrollView.scrollEnabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.scrollView.scrollEnabled = YES;
}

@end
