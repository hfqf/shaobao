//
//  SqliteDataManager.h
//  JZH_Test
//  数据库管理类
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqliteDataManager : NSObject
{
    sqlite3   *m_db;
}

SINGLETON_FOR_HEADER(SqliteDataManager)

- (BOOL)createTable:(NSString *)tableName;
@end