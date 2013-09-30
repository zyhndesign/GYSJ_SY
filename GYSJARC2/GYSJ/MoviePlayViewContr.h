//
//  MoviePlayViewContr.h
//  GYSJ
//
//  Created by sunyong on 13-8-14.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayViewContr : UIViewController<UIAlertViewDelegate>
{
    NSString *urlStr;
    UIActivityIndicatorView *activeView;
    MPMoviePlayerController *movie;
    BOOL isShow;
}

- (id)initwithURL:(NSString*)URLStr;
@end
