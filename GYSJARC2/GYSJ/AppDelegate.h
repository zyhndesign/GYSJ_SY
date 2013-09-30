//
//  AppDelegate.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetVersion.h"

@class ViewController;
//@class TAGManager;
//@class TAGContainer;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NetworkDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;




@end
