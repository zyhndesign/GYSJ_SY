//
//  ContentViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
#import "LoadZipFileNet.h"

@class SimpMenuView;

@interface ContentViewContr : UIViewController<UIWebViewDelegate, NSStreamDelegate, NSXMLParserDelegate, NetworkDelegate>
{
    IBOutlet UIActivityIndicatorView *activeView;
    IBOutlet UIWebView *_webView;
    NSDictionary *initDict;
    NSMutableDictionary *infoDict;
    
    NSString *keyStr;
    BOOL StartKey;
    BOOL StartValue;
    LoadZipFileNet *loadZipNet;
    
}
- (id)initWithSimMenuV:(SimpMenuView*)simMenuView;
- (IBAction)close:(UIButton*)sender;
@end
