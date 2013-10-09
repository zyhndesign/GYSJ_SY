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

    UITextView *titleTextV;
    UILabel *midLineLB;
    UIImageView *imageVFu1;
    UILabel *lbFu1;
    UIImageView *imageVFu2;
    UILabel *lbFu2;
    UIImageView *imageVOne;
    UILabel *lbOne;
    UIImageView *imageVTwo;
    UILabel *lbTwo;
    UIImageView *imageVThr;
    UILabel *lbThr;
}

- (id)initWithDict:(NSDictionary*)infoDict;
- (void)addDataToView:(NSDictionary*)infoDict;

@property(nonatomic, strong)NSDictionary *_infoDict;
@property(nonatomic, assign)CGPoint positionP;
@property(nonatomic, strong)NSString *imageName;
@property(nonatomic, strong)UIImage *imageBg;
@property(nonatomic, strong)NSString *_idStr;

/////  两张图片全部下载完才显示profile图
@property(nonatomic, assign)BOOL isProImage;
@property(nonatomic, assign)BOOL isBgImage;
@end
