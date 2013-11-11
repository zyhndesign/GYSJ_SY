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
#import "GAI.h"

@class SimpMenuView;

@interface ContentViewContr : GAITrackedViewController<UIWebViewDelegate, NSStreamDelegate, NSXMLParserDelegate, NetworkDelegate>
{
    IBOutlet UIWebView *_webView;
    NSDictionary *initDict;
    NSMutableDictionary *infoDict;
    
    NSString *keyStr;
    BOOL StartKey;
    BOOL StartValue;
    LoadZipFileNet *loadZipNet;
}
@property(nonatomic, strong)IBOutlet UIProgressView *progressV;
@property(nonatomic, strong)IBOutlet UILabel *proValueLb;
@property(nonatomic, strong)IBOutlet UILabel *proMarkLb;
- (id)initWithSimMenuV:(SimpMenuView*)simMenuView;
- (IBAction)close:(UIButton*)sender;
@end
