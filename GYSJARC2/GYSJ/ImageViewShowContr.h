//
//  ImageViewShowContr.h
//  GYSJ
//
//  Created by sunyong on 13-9-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
@class ImageLoadNet;

@interface ImageViewShowContr : UIViewController<NetworkDelegate>
{
    
    IBOutlet UIImageView  *imageView;
	IBOutlet UIScrollView *scrllview;
    IBOutlet UIView *stopView;
	CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;
    
    NSString *urlStr;
	UIActivityIndicatorView *activeView;
    ImageLoadNet *imageLoadNet;
}

@property(nonatomic, strong)NSString *idStr;

- (id)initwithURL:(NSString*)URLStr;
@end
