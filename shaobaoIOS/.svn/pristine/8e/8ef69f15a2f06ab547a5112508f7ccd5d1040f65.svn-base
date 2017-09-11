    //
//  sqliteADO.m
//  JZH_Test
//
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "sqliteADO.h"
#import "SqliteDataManager.h"
#import "LocalTimeUtil.h"
@implementation sqliteADO

+ (void)initDatabase
{
   SqliteDataManager *dbManager  = [SqliteDataManager sharedInstance];
    if(dbManager)
    {
        [self createTable];
    }
}

+(BOOL)createTable
{
    NSString *messageTable = @"CREATE TABLE IF NOT EXISTS 'messageTable' (ID INTEGER PRIMARY KEY AUTOINCREMENT, m_chatId LONG LONG, m_strOppositeSideName TEXT,m_strMessageBody TEXT,m_isFromSelf INTEGER,m_messageStatus INTEGER,m_strTime TEXT,m_oppositeChaterId LONG LONG,m_contentType INTEGER, m_chatType INTEGER ,mediaPath TEXT,loginUserId TEXT,duration  INTEGER,timeTitleState INTEGER,belongToDuration TEXT)";

    NSString *contactGroupTable = @"CREATE TABLE IF NOT EXISTS 'contactGroupTable' (ID INTEGER PRIMARY KEY AUTOINCREMENT, groupId INTEGER, groupName TEXT,membersCount INTEGER,role TEXT,type TEXT,loginUserId TEXT)";
    
    NSString *contactGroupMemeberTable = @"CREATE TABLE IF NOT EXISTS 'contactGroupMemeberTable' (ID INTEGER PRIMARY KEY AUTOINCREMENT, groupId INTEGER, userId INTEGER,name TEXT,provice TEXT,remoteId TEXT,type TEXT,attrs TEXT,loginUserId TEXT)";
    
    NSString *userTable = @"CREATE TABLE IF NOT EXISTS 'userTable' (ID INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT, passWord TEXT,userId TEXT)";
    
    NSString *educationPtotalsTable = @"CREATE TABLE IF NOT EXISTS 'educationProtalsTable' (fieldId INTEGER, fieldName TEXT)";
    
    NSString *unreadMsgTable = @"CREATE TABLE IF NOT EXISTS 'unreadMsgTable' (msgId KEY,userId LONG)";
    
    NSString *historyLocationsTable = @"CREATE TABLE IF NOT EXISTS 'historyLocationsTable' (latitude TEXT,longitude TEXT,address TEXT,timestamp TEXT,userId LONG)";
    NSString *selectedAppTable = @"CREATE TABLE IF NOT EXISTS 'selectedAppTable' (funId TEXT,name TEXT,isAdd TEXT,userId LONG)";
    
    NSString *videoPlayHistoryTable = @"CREATE TABLE IF NOT EXISTS 'videoPlayHistoryTable' (videoId TEXT,cover TEXT,videoTitle TEXT,playTime TEXT,userId LONG)";
    
     NSString *unCompletedHomeworkTable = @"CREATE TABLE IF NOT EXISTS 'unCompletedHomeworkTable' (questionId TEXT,studentId TEXT,content TEXT,userId LONG)";
    
    if([[SqliteDataManager sharedInstance]createTable:messageTable])
    {
        if([[SqliteDataManager sharedInstance]createTable:contactGroupTable])
        {
            if([[SqliteDataManager sharedInstance]createTable:contactGroupMemeberTable])
            {
                if([[SqliteDataManager sharedInstance]createTable:userTable])
                {
                    if([[SqliteDataManager sharedInstance]createTable:educationPtotalsTable])
                    {
                        if([[SqliteDataManager sharedInstance]createTable:unreadMsgTable])
                        {
                            if([[SqliteDataManager sharedInstance]createTable:historyLocationsTable])
                            {
                                if([[SqliteDataManager sharedInstance]createTable:selectedAppTable])
                                {
                                    if([[SqliteDataManager sharedInstance]createTable:videoPlayHistoryTable])
                                    {
                                        if([[SqliteDataManager sharedInstance]createTable:unCompletedHomeworkTable])
                                        {
                                            SpeLog(@"所有表创建成功");
                                            return YES;
 
                                        }
                                        else
                                        {
                                             SpeAssert(@"未完成作业表创建失败");
                                        }
                                    }
                                    else
                                    {
                                         SpeAssert(@"视频播放历史表创建失败");
                                    }
                                }
                                else
                                {
                                   SpeAssert(@"选择的特色应用表创建失败");
                                }
                            }
                            else
                            {
                                SpeAssert(@"历史位置表创建失败");
                            }

                        }
                        else
                        {
                            SpeAssert(@"未读消息表创建失败");
                        }
                      
                    }
                    else
                    {
                        SpeLog(@"教育门户栏位创建失败");
                        return NO;
                    }
    
                }
                else
                {
                    SpeLog(@"用户表创建失败");
                }
              
            }
            else
            {
                SpeLog(@"创建contactGroupMemeberTable失败");
                return  NO;
            }
        }
        else
        {
            SpeLog(@"创建contactGroupTable失败");
            return  NO;
        }
    }
    {
        SpeLog(@"创建messageTotalTable失败");
        return  NO;
    }
    return NO;

}


@end