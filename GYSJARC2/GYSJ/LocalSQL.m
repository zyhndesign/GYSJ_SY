//
//  LocalSQL.m
//  GYSJ
//
//  Created by sunyong on 13-7-23.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//
#define TagSqlId      0
#define TagSqlName    1
#define TagSqlMd5     2
#define TagSqlTimeStamp 3
#define TagSqlUrl   4
#define TagSqlCity  5
#define TagSqlCoordinate 6
#define TagSqlGenre   7
#define TagSqlSummary 8
#define TagSqlYear    9
#define TagSqlArtists 10
#define TagSqlOrganizations 11

#import "LocalSQL.h"

__strong sqlite3 *dataBase;

@implementation LocalSQL

+ (BOOL)openDataBase
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"Data.db"];
    if (sqlite3_open([fileName UTF8String], &dataBase) == SQLITE_OK)
        return YES;
    return NO;
}

+ (BOOL)closeDataBase
{
    if (sqlite3_close(dataBase) == SQLITE_OK)
        return YES;
    return NO;
}

+ (BOOL)createLocalTable
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists myTable(id char primary key,name char,md5 char, timestamp char, url char,city char,coordinate char,genre char, summary char,year char, artists char, organizations char, postDate char,background char,profile char)"];
//     NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists myTable(id char,name char,md5 char, timestamp char, url char,city char,coordinate char,genre char, summary char,year char, artists char, organizations char, postDate char,background char,profile char)"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (NSArray*)getAll
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from mytable order by year"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSMutableArray *tempAry = [NSMutableArray array];
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *nameStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *md5Str  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *cityStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *coordStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *genreStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *summaryStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *yearStr    = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *artiStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *organStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *postDateStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
            NSString *profileStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nameStr, @"name",md5Str, @"md5", timeStampStr,@"timestamp", urlStr,@"url",cityStr,@"city",coordStr,@"coordinate", genreStr,@"genre",summaryStr,@"summary",yearStr,@"year",artiStr,@"artists",organStr,@"organizations", postDateStr, @"postDate", backgroundStr, @"background", profileStr, @"profile", nil];
            
            if (backAry.count == 0)
            {
                [tempAry addObject:subDict];
                [backAry addObject:tempAry];
            }
            else
            {
                if ([[[[backAry lastObject] objectAtIndex:0] objectForKey:@"year"] isEqualToString:yearStr])
                {
                    
                    tempAry = [backAry lastObject];
                    [tempAry addObject:subDict];
                }
                else
                {
                    [tempAry addObject:subDict];
                    [backAry addObject:tempAry];
                }
            }
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}
+ (NSArray*)getALlYear
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from mytable order by year"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            
            NSString *yearStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            [backAry addObject:yearStr];
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}

+ (NSDictionary*)getNewestArticle
{
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    NSString *sqlStr = [NSString stringWithFormat:@"select id, year,max(postDate) from myTable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *yearStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *postDateStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
            [infoDict setObject:idStr       forKey:@"id"];
            [infoDict setObject:yearStr     forKey:@"year"];
            [infoDict setObject:postDateStr forKey:@"postDate"];
        }
        sqlite3_finalize(stmt);
        return infoDict;
    }
    return nil;

}
+ (NSMutableArray *)getInfoDictFromYears:(int)year
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select *from mytable where year = '%04d'", year];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *nameStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *md5Str  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *cityStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *coordStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *genreStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *summaryStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *yearStr    = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *artiStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *organStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *postDateStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
            NSString *profileStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nameStr, @"name",md5Str, @"md5", timeStampStr,@"timestamp", urlStr,@"url",cityStr,@"city",coordStr,@"coordinate", genreStr,@"genre",summaryStr,@"summary",yearStr,@"year",artiStr,@"artists",organStr,@"organizations", postDateStr, @"postDate", backgroundStr, @"background", profileStr, @"profile", nil];
            [backAry addObject:subDict];
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}


+ (NSArray*)getAllID
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select id from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            [arry addObject:idStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSArray*)getAllName
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select name from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *nameStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            [arry addObject:nameStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSMutableArray*)getAllGener
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select genre from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *generStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            if(generStr.length > 0)
                [arry addObject:generStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSMutableArray*)getAllPerson
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select artists from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *personStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            if(personStr.length > 0)
                [arry addObject:personStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSMutableArray*)getAllCompany
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select organizations from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *companyStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            if(companyStr.length > 0)
                [arry addObject:companyStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSArray*)getAllGenrePersonCompany
{
    NSMutableArray *arry    = [NSMutableArray array];
    NSMutableArray *arryOne = [NSMutableArray array];
    NSMutableArray *arryTwo = [NSMutableArray array];
    NSMutableArray *arryThr = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select artists organizations genre from mytable"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *personStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            NSString *companyStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *generStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            [arryOne addObject:personStr];
            [arryTwo addObject:companyStr];
            [arryThr addObject:generStr];
        }
        sqlite3_finalize(stmt);
        [arry addObject:arryOne];
        [arry addObject:arryTwo];
        [arry addObject:arryThr];
        return arry;
    }
    return nil;
}
+ (NSArray*)getGenerFromArtistsCondition:(NSString*)artists
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select genre from mytable where artists like '%%%@%%'", artists];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *genreStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            [arry addObject:genreStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}

+ (NSArray*)getArtistsFromArtistsCondition:(NSString*)Gener
{
    NSMutableArray *arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"select artists from mytable where genre = '%@'", Gener];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *artistsStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            [arry addObject:artistsStr];
        }
        sqlite3_finalize(stmt);
        return arry;
    }
    return nil;
}
+ (NSArray*)getAllDataFromGener:(NSString*)gener artists:(NSString*)artists organizations:(NSString*)organizations;
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *sqlStr = @"select *from mytable";
    if (gener.length > 0)
    {
        if (artists.length > 0)
        {
            if (organizations.length >0)
            {
                sqlStr = [NSString stringWithFormat:@"%@ where genre like '%%%@%%' and artists like '%%%@%%' and organizations like '%%%@%%'", sqlStr, gener, artists, organizations];
            }
            else
            {
                sqlStr = [NSString stringWithFormat:@"%@ where genre like '%%%@%%' and artists like '%%%@%%'", sqlStr, gener, artists];
            }
        }
        else
        {
            if (organizations.length >0)
            {
                sqlStr = [NSString stringWithFormat:@"%@ where genre like '%%%@%%'  and organizations like '%%%@%%'", sqlStr, gener, organizations];
            }
            else
            {
                sqlStr = [NSString stringWithFormat:@"%@ where genre like '%%%@%%'", sqlStr, gener];
            }
        }
        
    }
    else
    {
        if (artists.length > 0)
        {
            if (organizations.length >0)
            {
                sqlStr = [NSString stringWithFormat:@"%@ where artists like '%%%@%%' and organizations like '%%%@%%'", sqlStr, artists, organizations];
            }
            else
            {
                sqlStr = [NSString stringWithFormat:@"%@ where  artists like '%%%@%%' ", sqlStr, artists];
            }
        }
        else
        {
            if (organizations.length >0)
            {
                sqlStr = [NSString stringWithFormat:@"%@ where organizations like '%%%@%%'", sqlStr, organizations];
            }
            else
            {
                
            }
        }
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *nameStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *md5Str  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *cityStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *coordStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *genreStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *summaryStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *yearStr    = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *artiStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *organStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *postDateStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
            NSString *profileStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nameStr, @"name",md5Str, @"md5", timeStampStr,@"timestamp", urlStr,@"url",cityStr,@"city",coordStr,@"coordinate", genreStr,@"genre",summaryStr,@"summary",yearStr,@"year",artiStr,@"artists",organStr,@"organizations", postDateStr, @"postDate", backgroundStr, @"background", profileStr, @"profile", nil];
            [backAry addObject:subDict];
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}

+ (NSArray*)getAllDateFromConditionType:(int)type condition:(NSString*)conditionStr
{
    NSMutableArray *backAry = [NSMutableArray array];
    NSString *typeStr = nil;
    if (type == GenerType)
        typeStr = @"genre";
    else if(type == PeopleType)
        typeStr = @"artists";
    else
        typeStr = @"organizations";
    
    NSString *sqlStr = [NSString stringWithFormat:@"select *from mytable where %@ like '%%%@%%' order by year", typeStr,conditionStr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSMutableArray *tempAry = [NSMutableArray array];
            NSString *idStr   = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 0)];
            NSString *nameStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            NSString *md5Str  = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
            NSString *timeStampStr = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
            NSString *urlStr       = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 4)];
            NSString *cityStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            NSString *coordStr     = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 6)];
            NSString *genreStr     = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            NSString *summaryStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
            NSString *yearStr    = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 9)];
            NSString *artiStr    = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            NSString *organStr   = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            NSString *postDateStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
            NSString *backgroundStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
            NSString *profileStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
            NSDictionary *subDict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nameStr, @"name",md5Str, @"md5", timeStampStr,@"timestamp", urlStr,@"url",cityStr,@"city",coordStr,@"coordinate", genreStr,@"genre",summaryStr,@"summary",yearStr,@"year",artiStr,@"artists",organStr,@"organizations", postDateStr, @"postDate", backgroundStr, @"background", profileStr, @"profile", nil];
            
            if (backAry.count == 0)
            {
                [tempAry addObject:subDict];
                [backAry addObject:tempAry];
            }
            else
            {
                if ([[[[backAry lastObject] objectAtIndex:0] objectForKey:@"year"] isEqualToString:yearStr])
                {
                    
                    tempAry = [backAry lastObject];
                    [tempAry addObject:subDict];
                }
                else
                {
                    [tempAry addObject:subDict];
                    [backAry addObject:tempAry];
                }
            }
        }
        sqlite3_finalize(stmt);
        return backAry;
    }
    return nil;
}

+ (BOOL)getIsExistDataFromID:(NSString*)idstr
{
    NSString *sqlStr = [NSString stringWithFormat:@"select id from mytable where id = '%@'", idstr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            sqlite3_finalize(stmt);
            return YES;
        }
        sqlite3_finalize(stmt);
    }
    return NO;
}

+ (BOOL)insertData:(NSDictionary*)infoDict
{
    if ([[infoDict objectForKey:@"op"] isEqual:@"d"]) // 删除操作
    {
        NSString *idStr = [infoDict objectForKey:@"id"];
        [LocalSQL deleteData:idStr];
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:idStr];
        [[NSFileManager defaultManager] removeItemAtPath:docPath error:nil];
        return YES;
    }
    NSDictionary *subInfoDict = [infoDict objectForKey:@"info"];
    NSString *idStr     = [infoDict objectForKey:@"id"];
    NSString *nameStr   = [infoDict objectForKey:@"name"];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSString *md5Str    = [infoDict objectForKey:@"md5"];
    NSString *timestamp = [infoDict objectForKey:@"timestamp"];
    NSString *urlStr    = [infoDict objectForKey:@"url"];
    NSString *yearStr   = [subInfoDict objectForKey:@"year"];
    if ([yearStr integerValue] <= StartYear)
        yearStr = [NSString stringWithFormat:@"0000"];
    NSString *postDateS = [subInfoDict objectForKey:@"postDate"];
    
    NSString *cityStr = [subInfoDict objectForKey:@"city"];
    if ([cityStr isEqual:[NSNull null]] || cityStr == nil)
        cityStr = @"";
    
    NSString *coordStr = [subInfoDict objectForKey:@"coordinate"];
    
    NSString *summaryStr = [subInfoDict objectForKey:@"summary"];
    if([summaryStr isEqual:[NSNull null]] || summaryStr == nil)
        summaryStr = @"";
    summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    summaryStr = [summaryStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *backgroundStr = [subInfoDict objectForKey:@"background"];
    if([backgroundStr isEqual:[NSNull null]] || backgroundStr == nil)
        backgroundStr = @"";
    
    NSString *profileStr = [subInfoDict objectForKey:@"profile"];
    if([profileStr isEqual:[NSNull null]] || profileStr == nil)
        profileStr = @"";
    
    
    NSArray *genreAry = [subInfoDict objectForKey:@"genre"];
    NSString *genreStr = nil;
    if (genreAry.count == 0)
        genreStr = @"";
    else
    {
        genreStr = [genreAry objectAtIndex:0];
        for (int i = 1; i < genreAry.count; i++)
            genreStr = [NSString stringWithFormat:@"%@，%@", genreStr, [genreAry objectAtIndex:i]];
        genreStr = [genreStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        genreStr = [genreStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        genreStr = [genreStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    
    NSArray *artistsAry = [subInfoDict objectForKey:@"artists"];
    NSString *artistStr = nil;
    if (artistsAry.count == 0)
        artistStr = @"";
    else
    {
        artistStr = [artistsAry objectAtIndex:0];
        for (int i = 1; i < artistsAry.count; i++)
            artistStr = [NSString stringWithFormat:@"%@，%@", artistStr, [artistsAry objectAtIndex:i]];
        artistStr = [artistStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        artistStr = [artistStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        artistStr = [artistStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    NSArray *organAry = [subInfoDict objectForKey:@"organizations"];
    NSString *organStr = nil;
    if (organAry.count == 0)
        organStr = @"";
    else
    {
        organStr = [organAry objectAtIndex:0];
        for (int i = 1; i < organAry.count; i++)
            organStr = [NSString stringWithFormat:@"%@，%@", organStr, [organAry objectAtIndex:i]];
        organStr = [organStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        organStr = [organStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        organStr = [organStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    NSString *sqlStr = nil;
    if ([LocalSQL getIsExistDataFromID:idStr])
    {
        if (![profileStr isEqualToString:[LocalSQL getProImageUrl:idStr]])
        {
            NSString *ProImgeFormat = [[profileStr componentsSeparatedByString:@"."] lastObject];
            
            NSString *pathProFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"ProImage/%@.%@",idStr, ProImgeFormat]];
            [[NSFileManager defaultManager] removeItemAtPath:pathProFile error:nil];
        }
        if (![backgroundStr isEqualToString:[LocalSQL getBgImageUrl:idStr]])
        {
            NSString *BgImgeFormat = [[backgroundStr componentsSeparatedByString:@"."] lastObject];
            
            NSString *pathBgFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"BgImage/%@.%@",idStr, BgImgeFormat]];
            [[NSFileManager defaultManager] removeItemAtPath:pathBgFile error:nil];
        }
        sqlStr = [NSString stringWithFormat:@"update mytable set name='%@',md5='%@',timestamp='%@',url='%@',city='%@',coordinate='%@',genre='%@',summary='%@',year='%@',artists='%@',organizations='%@', postDate='%@', background='%@',profile='%@' where id = '%@'",nameStr, md5Str, timestamp, urlStr, cityStr, coordStr, genreStr, summaryStr, yearStr, artistStr, organStr, postDateS,backgroundStr, profileStr,idStr];
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:idStr];
        [[NSFileManager defaultManager] removeItemAtPath:docPath error:nil];
    }
    else
    {
        sqlStr = [NSString stringWithFormat:@"insert into mytable values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '%@', '%@')", idStr,nameStr, md5Str, timestamp, urlStr, cityStr, coordStr, genreStr, summaryStr, yearStr, artistStr, organStr, postDateS, backgroundStr, profileStr];
    }
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (NSString*)getProImageUrl:(NSString*)idstr
{
    NSString *sqlStr = [NSString stringWithFormat:@"select background from mytable where id = '%@'", idstr];
    sqlite3_stmt *stmt;
    NSString *backStr = nil;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            backStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            sqlite3_finalize(stmt);
        }
        sqlite3_finalize(stmt);
    }
    return backStr;
}

+ (NSString*)getBgImageUrl:(NSString*)idstr
{
    NSString *sqlStr = [NSString stringWithFormat:@"select profile from mytable where id = '%@'", idstr];
    sqlite3_stmt *stmt;
    NSString *backStr = nil;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            backStr = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
            sqlite3_finalize(stmt);
        }
        sqlite3_finalize(stmt);
    }
    return backStr;
}


+ (BOOL)deleteData:(NSString*)idStr
{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from mytable where id = '%@'", idStr];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, 0) != SQLITE_OK)
    {
        sqlite3_finalize(stmt);
        return NO;
    }
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return YES;
    }
    sqlite3_finalize(stmt);
    return NO;
}

+ (BOOL)updateData:(NSDictionary*)infoDict
{
  
    return YES;
}

@end
