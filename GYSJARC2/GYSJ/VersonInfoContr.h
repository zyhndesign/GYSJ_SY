//
//  VersonInfoContr.h
//  GYSJ
//
//  Created by sunyong on 13-9-12.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersonInfoContr : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *_webView;
    UIButton *senderBt; 
}

- (id)initWithButton:(UIButton*)sender;

- (IBAction)back:(UIButton*)sender;
@end
