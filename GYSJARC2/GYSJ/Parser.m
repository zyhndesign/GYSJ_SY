//
//  Parser.m
//  HttpAndJson
//
//  Created by user on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Parser.h"


@implementation Parser

/*************************************************************************
 名   称：realQuotesRangeOfString: options: range:
 功   能：在给定的范围内查找“”“第一次出现的位置
 入口参数：NSString *aString，NSStringCompareOptions mask,NSRange searchRange
 出口参数：NSRange *resultRange
 编   写：
 修   改：
 *************************************************************************/
+ (NSRange)realQuotesRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
	NSString *strQuotesDelimeter = @"\"";
	
	NSRange resultRange = [aString rangeOfString: strQuotesDelimeter options: mask range: searchRange];
	
//	if((resultRange.length > 0) && (resultRange.location > 0))
//	{
//		while([[aString substringWithRange: NSMakeRange(resultRange.location - 1, 1)] isEqualToString: @"\\"])
//		{
//			if(mask & NSBackwardsSearch)
//			{
//				resultRange = [aString rangeOfString: strQuotesDelimeter options: mask range: NSMakeRange(searchRange.location, resultRange.location - searchRange.location - 1)];
//			}
//			else
//			{
//				resultRange = [aString rangeOfString: strQuotesDelimeter options: mask range: NSMakeRange(resultRange.location + 1, searchRange.location + searchRange.length - resultRange.location - 1)];
//			}
//		}
//	}
	
	return resultRange;
}

/********************************************************
 名   称：getDictionaryWithJsonString:
 功   能：解析Json格式数据
 入口参数：NSString *jsonString
 出口参数：NSMutableDictionary *jsonDictionary
 编   写：
 修   改：
 ********************************************************/
+ (NSMutableDictionary *) getDictionaryWithJsonString: (NSString *) jsonString
{
    id strValue;
	NSMutableDictionary *jsonDictionary = [[[NSMutableDictionary alloc] initWithCapacity: 3] autorelease];
	NSString *strCommaDelimeter = @",";
	NSString *strColonDelimeter = @":";
	NSString *strRightBraceDelimeter = @"}";
	NSString *strLeftBraceDelimeter = @"{";
	int iTotalLength = [jsonString length];
	NSRange toFindRange = NSMakeRange(0, iTotalLength);
	
	NSRange colonRange = [jsonString rangeOfString: strColonDelimeter options: NSCaseInsensitiveSearch range: toFindRange];
	while(colonRange.length > 0)
	{
		//获取：左边的数据
		NSRange keyRangeEnd = [self realQuotesRangeOfString: jsonString  options: NSBackwardsSearch range: NSMakeRange(0, colonRange.location)];
		NSRange keyRangeStart = [self realQuotesRangeOfString: jsonString options: NSBackwardsSearch range: NSMakeRange(0, keyRangeEnd.location -1)];
		NSRange keyRange = NSMakeRange(keyRangeStart.location + 1, keyRangeEnd.location - keyRangeStart.location - 1);
        
        //获取：右边的数据
        if ([[jsonString substringWithRange:NSMakeRange(colonRange.location +1, 1)] isEqualToString:strLeftBraceDelimeter]) { 
           //递归调用获取｛｝中的数据 
            NSRange valueRageEnd = [jsonString rangeOfString:strRightBraceDelimeter 
                                                     options:NSCaseInsensitiveSearch 
                                                       range:NSMakeRange(colonRange.location, toFindRange.length - colonRange.location)];
            NSString *string = [jsonString substringWithRange:NSMakeRange(colonRange.location +1, valueRageEnd.location -colonRange.location +1)];
            strValue = [self getDictionaryWithJsonString:string];
            toFindRange.location = colonRange.location + [string length] ;
            toFindRange.length = iTotalLength - toFindRange.location;
            colonRange = [jsonString rangeOfString: strColonDelimeter options: NSCaseInsensitiveSearch range: toFindRange];
        } else {
            
            NSRange valuePossibleRange = NSMakeRange(colonRange.location, iTotalLength - colonRange.location);

            NSRange rightDelimeterRange = [jsonString rangeOfString: strCommaDelimeter options: NSCaseInsensitiveSearch range: valuePossibleRange];
            
            if(rightDelimeterRange.length <= 0){ //如果没有，则数据在范围在｝前
                rightDelimeterRange = [jsonString rangeOfString: strRightBraceDelimeter options: NSCaseInsensitiveSearch range: valuePossibleRange];
            } else {
                //如果有，且有｝“｝，” 则数据在范围在｝前
                if ([[jsonString substringWithRange:NSMakeRange(rightDelimeterRange.location - 1, 1)] isEqualToString:strRightBraceDelimeter] ) {
                    rightDelimeterRange.location = rightDelimeterRange.location -1;
                }
            }
            if(rightDelimeterRange.length == 0) {
                break;
            }
            
            NSRange valueRangeStart = [self realQuotesRangeOfString: jsonString options: NSCaseInsensitiveSearch range: valuePossibleRange];
            NSRange valueRangeEnd;
            NSRange valueRange;
            
            if((valueRangeStart.location < rightDelimeterRange.location) && (0 != valueRangeStart.length)){
                valueRangeEnd = [self realQuotesRangeOfString: jsonString 
                                                      options: NSCaseInsensitiveSearch 
                                                        range: NSMakeRange(valueRangeStart.location + 1, iTotalLength - valueRangeStart.location - 1)];
                valueRange = NSMakeRange(valueRangeStart.location + 1, valueRangeEnd.location - valueRangeStart.location - 1);
            } else	{       // valueRangeStart.length == 0
                valueRange = NSMakeRange(colonRange.location + 1, rightDelimeterRange.location - colonRange.location - 1);
            }
            strValue = [jsonString substringWithRange: valueRange];  //截取“”之间的数据
            toFindRange.location = colonRange.location + 1;  //把查找的范围往后移 长度相应的改变
            toFindRange.length = iTotalLength - toFindRange.location;
            colonRange = [jsonString rangeOfString: strColonDelimeter options: NSCaseInsensitiveSearch range: toFindRange];
        }
		NSString *strKey = [jsonString substringWithRange: keyRange];
		//NSLog(@"%@ = %@", strKey, strValue);
		[jsonDictionary setObject: strValue	forKey: strKey];
    }
	return jsonDictionary;
}

/********************************************************
 名   称：getDictionaryWithJsonString:
 功   能：解析Json格式数据
 入口参数：NSData *data
 出口参数：NSDictionary *dictionary
 编   写：
 修   改：
 ********************************************************/
+(NSDictionary *)getTaskTypeCount:(NSData *)data {
    //NSDictionary *dictionary = [[NSDictionary alloc]init];
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:data error:nil];
    return dictionary;
}
@end
