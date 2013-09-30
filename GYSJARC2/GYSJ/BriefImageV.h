//
//  ImageV.h
//  GYSJ
//
//  Created by sunyong on 13-9-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BriefImageV : UIView
{
   __strong UIImage *image;
}
@property(nonatomic)UIImage *image;
- (id)initWIthImage:(UIImage*)imageV;


@end
