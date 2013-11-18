//
//  AppDelegate.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalSQL.h"
#import "ViewController.h"
#import "SimpMenuView.h"
#import "AllVarible.h"
#import "Reachability.h"
#import "NetworkDelegate.h"
#import <sys/xattr.h>



/******* Set your tracking ID here *******/

// UA-44083057-2
static NSString *const kTrackingId = @"UA-44083057-2";

@implementation AppDelegate
@synthesize tracker = tracker_;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    [self preData];
    //////////////////
    AllMenuPosition_YearDict = [[NSMutableDictionary alloc] init];
    AllMenuYear_PositionDict = [[NSMutableDictionary alloc] init];
    AllInfoArray = [[NSMutableArray alloc] init];
    NSDate * senddate    = [NSDate date];
    NSCalendar * cal     = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
    AllNowYears = [conponent year];
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:windowRect];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    RootViewContr = self.viewController;
    [self.window makeKeyAndVisible];
    
    if (ios7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    GetVersion *getVision = [[GetVersion alloc] init];
    getVision.delegate = self;
    [getVision getVersonFromItunes];
    
    return YES;
}

- (float)getVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    return [currentVersion floatValue];
}

- (void)didReceiveData:(NSDictionary *)dict
{
    NSString *resultCount = [dict objectForKey:@"resultCount"];
    if ([resultCount intValue] > 0)
    {
        NSArray *infoArray = [dict objectForKey:@"results"];
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *latestVersion   = [releaseInfo objectForKey:@"version"];
        NSString *trackViewUrl    = [releaseInfo objectForKey:@"trackViewUrl"];
        if ([latestVersion floatValue] > [self getVersion])
        {
            [[NSUserDefaults standardUserDefaults] setObject:trackViewUrl forKey:@"versionURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.viewController performSelector:@selector(versionImply) withObject:nil afterDelay:1.0f];
        }
    }
}


- (void)didReceiveErrorCode:(NSError*)Error
{
    if ([Error code] == -1009)
    {
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据连接失败，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alerView show];
//        [alerView release];
    }
}


- (void)preData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    NSString *docProImagePath = [path stringByAppendingPathComponent:@"ProImage"];
    NSString *docBgImagePath  = [path stringByAppendingPathComponent:@"BgImage"];
    BOOL doct = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:docProImagePath isDirectory:&doct])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docProImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:docBgImagePath isDirectory:&doct])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docBgImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [LocalSQL openDataBase];
    [LocalSQL createLocalTable];
    if(![LocalSQL checkTableColomn])
    {
        UpdateSQLColomn = YES;
        [LocalSQL addColommToTable];
    }
    [LocalSQL closeDataBase];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
