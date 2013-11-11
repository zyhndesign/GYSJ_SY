//
//  LocalSQL.h
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>



@interface LocalSQL : NSObject


+ (BOOL)openDataBase;
+ (BOOL)closeDataBase;
+ (BOOL)createLocalTable;

+ (NSArray*)getAllID;
+ (BOOL)getIsExistDataFromID:(NSString*)idstr;

+ (NSMutableArray *)getInfoDictFromYears:(int)year;

+ (BOOL)insertData:(NSDictionary*)infoDict;

+ (NSMutableArray*)getAll;
+ (NSMutableArray*)getAllGener;
+ (NSMutableArray*)getAllPerson;
+ (NSMutableArray*)getAllCompany;
+ (NSArray*)getAllGenrePersonCompany;
+ (NSDictionary*)getNewestArticle;
+ (NSArray*)getALlYear;

+ (NSArray*)getGenerFromArtistsCondition:(NSString*)artists;
+ (NSArray*)getArtistsFromArtistsCondition:(NSString*)Gener;
+ (NSArray*)getAllDateFromConditionType:(int)type condition:(NSString*)conditionStr;




@end
