//
//  ImageV.m
//  GYSJ
//
//  Created by sunyong on 13-9-10.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "BriefImageV.h"

@implementation BriefImageV
@synthesize  image;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 60, 60);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWIthImage:(UIImage*)imageV
{
    self = [super init];
    if (self) {
        image = imageV;
    }
    return self;
}

- (void)setImage:(UIImage *)_image
{
    if (!_image)
        return;
    image = _image;
    [self setNeedsDisplay];

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!image)
        return;
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //    //////  将Quartz坐标系转为系统坐标系
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -60);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, true);
    CGContextDrawImage(context, CGRectMake(0, 0, 60, 60), image.CGImage);
    //////
}


@end
