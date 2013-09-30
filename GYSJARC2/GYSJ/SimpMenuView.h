//
//  SimpMenuView.h
//  GYSJ
//
//  Created by sunyong on 13-8-1.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
@interface SimpMenuView : UIView<NetworkDelegate>
{
    UIImageView *imageViewPro;
}

- (id)initWithDict:(NSDictionary*)infoDict;

@property(nonatomic, strong)NSDictionary *_infoDict;
@property(nonatomic, assign)CGPoint positionP;
@property(nonatomic, strong)NSString *imageName;
@property(nonatomic, strong)UIImage *imageBg;
@property(nonatomic, strong)NSString *_idStr;

/////  两张图片全部下载完才显示profile图
@property(nonatomic, assign)BOOL isProImage;
@property(nonatomic, assign)BOOL isBgImage;
@end
