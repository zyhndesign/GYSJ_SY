//
//  MFSP_MD5.h
//  TestKeyBoard
//
//  Created by hongmei zhu on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import<CommonCrypto/CommonDigest.h>
@interface MFSP_MD5 : NSObject

+(NSString*) md5:(NSString*) str;
+(NSString *)file_md5:(NSString*) path;

@end
