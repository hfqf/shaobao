//
//  SqliteDataManager.m
//  JZH_Test
//
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#define DBNAME                          @"XXT_XJ_db.db"
#define MESSAGE_TABLE                   @"messageTable"
#define CONTACT_GROUP_TABLE             @"contactGroupTable"
#define  CONTACT_GROUP_MEMBER_TABLE     @"contactGroupMemeberTable"
#define EDUCATION_PROTALS_FIELD_TABLE   @"educationProtalsTable"

#import "SqliteDataManager.h"
#import "LoginUserUtil.h"
@implementation SqliteDataManager

- (void)dealloc
{
    sqlite3_close(m_db);
}

- (id)init

{
    if(self = [super init])
    {
        
        
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
        SpeLog(@"数据库路径%@",database_path);
        if (sqlite3_open([database_path UTF8String], &m_db) != SQLITE_OK)
        {
            sqlite3_close(m_db);
            SpeLog(@"创建数据库失败");
            return nil;
        }
        else
        {
            SpeLog(@"创建数据库成功");

        }
        return self;
    }
    return nil;
}

SINGLETON_FOR_CLASS(SqliteDataManager)

- (BOOL)createTable:(NSString *)sql
{
    return [self execSql:sql];
}


-(BOOL)execSql:(NSString *)sql
{
    char *err = NULL;
    if (sqlite3_exec(m_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        SpeLog(@"数据库操作:%@失败!====%s",sql,err);
        return NO;
    }
    else
    {
        SpeLog(@"操作数据成功==sql:%@",sql);
    }
    return YES;
}


@end