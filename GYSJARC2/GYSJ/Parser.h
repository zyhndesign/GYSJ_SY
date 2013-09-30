//
//  Parser.h
//  HttpAndJson
//
//  Created by user on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"

@interface Parser : NSObject {
    
}

+(NSMutableDictionary *) getDictionaryWithJsonString: (NSString *) jsonString;

+(NSDictionary *)getTaskTypeCount:(NSData *)data; //第三方
@end
