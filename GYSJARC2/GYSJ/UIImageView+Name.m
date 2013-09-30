//
//  UIImageView+Name.m
//  GYSJ
//
//  Created by sunyong on 13-9-13.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "UIImageView+Name.h"

@implementation UIImageView (Name)

static __strong NSString *_myImageName;

- (void)setMyImageName:(NSString*)myImageName
{
    _myImageName = nil;
    _myImageName = myImageName;
}

- (NSString*)getImageName
{
    return _myImageName;
}
@end
