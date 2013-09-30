//
//  UIImageView+Name.h
//  GYSJ
//
//  Created by sunyong on 13-9-13.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonDigest.h>

@interface UIImageView (Name)

- (void)setMyImageName:(NSString*)myImageName;
- (NSString*)getImageName;

@end
