//
//  ImageViewShowContr.m
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ImageViewShowContr.h"
#import "ImageLoadNet.h"

@interface ImageViewShowContr ()

@end

@implementation ImageViewShowContr
@synthesize idStr;

- (id)initwithURL:(NSString*)URLStr
{
    if ([super init])
    {
        urlStr = [[NSString alloc] initWithString:URLStr];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    UITapGestureRecognizer *tapGetstureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGest:)];
    [self.view addGestureRecognizer:tapGetstureR];

    scrllview.backgroundColor = [UIColor whiteColor];
    [scrllview setMaximumZoomScale:8];
    [scrllview setMinimumZoomScale:0.3];
    scrllview.scrollsToTop = NO;
    [imageView setCenter:CGPointMake(512, 384)];
    
    [scrllview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    NSString *fileName = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    NSString *doctPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *documentPath = [doctPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc/images", idStr]];
    NSString *filePath = [[documentPath stringByAppendingPathComponent:fileName] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL direc = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&direc])
    {
        [self didReciveImage:[UIImage imageWithContentsOfFile:filePath]];
        //[imageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    }
    else
    {
        imageLoadNet = [[ImageLoadNet alloc] init];
        imageLoadNet.delegate = self;
        [imageLoadNet loadImageFromUrl:urlStr];

        activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activeView.center = CGPointMake(512, 370);
        [activeView startAnimating];
        [stopView addSubview:activeView];
    }
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [scrllview removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    urlStr    = nil;
    imageView = nil;
    scrllview = nil;
    stopView  = nil;
    idStr     = nil;
    if (activeView)
        activeView = nil;
    if (imageLoadNet)
        imageLoadNet = nil;
}

- (void)tapGest:(UITapGestureRecognizer*)gesTesture
{
    CGPoint tapPoint = [gesTesture locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(1024-70, 0, 70, 70), tapPoint))
    {
        if (imageLoadNet)
        {
            [imageLoadNet setDelegate:nil];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"contentSize"])
    {
        if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, 384)];
        else if (scrllview.contentSize.height <= 748 && scrllview.contentSize.width >= 1024)
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, 374)];
        else if (scrllview.contentSize.height >= 748 && scrllview.contentSize.width <= 1024)
            [imageView setCenter:CGPointMake(512, scrllview.contentSize.height/2)];
        else
            [imageView setCenter:CGPointMake(scrllview.contentSize.width/2, scrllview.contentSize.height/2)];
	}
}

#pragma mark imageLoadDelegate

- (void)didReciveImage:(UIImage *)backImage
{
    stopView.hidden = YES;
    [imageView setImage:backImage];
    float W = CGImageGetWidth(backImage.CGImage);
    float H = CGImageGetHeight(backImage.CGImage);
    [imageView setFrame:CGRectMake(0, 0, W, H)];
    [imageView setCenter:CGPointMake(512, 384)];
}

- (void)didReceiveErrorCode:(NSError *)Error
{
    stopView.hidden = YES;
    if (Error != nil && [Error code] == -1009)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片读取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

@end
