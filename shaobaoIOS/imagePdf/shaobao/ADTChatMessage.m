//
//  ADTChatMessage.m
//  JZH_Test
//
//  Created by Points on 13-10-15.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "ADTChatMessage.h"
#import "LocalTimeUtil.h"
@implementation ADTChatMessage
@synthesize m_chatId,m_chatType,m_contentType,m_isFromSelf,m_messageStatus,m_oppositeChaterId,m_strMessageBody,m_strOppositeSideName,m_strTime,m_strMediaPath,m_idInDB,m_duration,m_timeLabState,m_strBelongToDuration,m_image;

- (id)copyWithZone:(NSZone *)zone;
{
    ADTChatMessage *copy = [[[self class] allocWithZone: zone]
                            init];
    copy.m_idInDB               = self.m_idInDB;
    copy.m_chatId               = self.m_chatId ;
    copy.m_strMessageBody        =  self.m_strMessageBody;
    copy.m_oppositeChaterId       = self.m_oppositeChaterId;
    copy.m_strOppositeSideName    = self.m_strOppositeSideName;
    copy.m_strTime               = [LocalTimeUtil getCurrentTime];
    copy.m_isFromSelf            =self.m_isFromSelf;
    copy.m_contentType           = self.m_contentType;
    copy.m_messageStatus         = self.m_messageStatus;
    copy.m_strMediaPath         = self.m_strMediaPath;
    copy.m_duration             =self.m_duration;
    copy.m_timeLabState          =self.m_timeLabState;
    copy.m_strBelongToDuration     =self.m_strBelongToDuration;
    copy.m_chatType                = self.m_chatType;
    copy.m_strShiftedMsg         =self.m_strShiftedMsg;
    copy.m_groupId              = self.m_groupId;
    copy.m_childId              = self.m_childId;
    copy.m_bIsOfflineMsg        = self.m_bIsOfflineMsg;
    copy.m_strMsgId             = self.m_strMsgId;
    copy.m_strGroupName          = self.m_strGroupName;
    copy.m_strGroupCount          = self.m_strGroupCount;
    copy.m_strGroupAvatar       = self.m_strGroupAvatar;
    copy.unreadCount             = self.unreadCount;
    copy.m_strSmallPicUrl         = self.m_strSmallPicUrl;
    copy.m_strCellTimeStamp    = self.m_strCellTimeStamp;
    copy.m_friendType = self.m_friendType;
    copy.m_image                = self.m_image;
    copy.m_msgid                = self.m_msgid;
    copy.m_strTimestamp          = self.m_strTimestamp;
    copy.locationInfoStr          = self.locationInfoStr;
    return copy;
}


- (id)init
{
    if(self = [super init])
    {
        self.m_strOppositeSideName = @"";
        self.m_strMessageBody = @"";
        self.m_strShiftedMsg = @"";
        self.m_strTime = @"";
        self.m_strMediaPath = @"";
        self.m_strBelongToDuration = @"";
        self.m_strMsgId = @"";
        self.m_strGroupName = @"";
        self.m_strGroupCount = @"";
        self.m_strGroupAvatar = @"";
        self.unreadCount = @"";
        self.m_strSmallPicUrl = @"";
        self.m_strCellTimeStamp = @"";
        
        return self;
    }
    return nil;
}

//收到消息的初始化函数
- (id)initWithDic:(NSDictionary *)dic;
{
    if(self = [super init])
    {
        NSString *type = [dic objectForKey:@"content_type"];
        if([type isEqualToString:@"txt"])
        {
            self.m_contentType = ENUM_MSG_TYPE_TEXT;
            NSString *content = [dic objectForKey:@"content"];
            if([content rangeOfString:@"position_yn_msg"].length > 0)
            {
                self.m_contentType = ENUM_MSG_TYPE_LOCATION;
                NSArray *arr = [content componentsSeparatedByString:@":"];
                if(arr.count != 0)
                {
                    NSArray *latiArr = [(NSString *)[arr objectAtIndex:2] componentsSeparatedByString:@"\""];
                    NSArray *longiArr = [(NSString *)[arr objectAtIndex:3] componentsSeparatedByString:@"\""];
                    NSString *latitude =  [latiArr objectAtIndex:1];
                    NSString *longitude = [longiArr objectAtIndex:1];
                    self.m_strMediaPath = BAIDUMAP_STATIC_SNAP(longitude, latitude);
                }
            }
            
            
            
        }
        else if ([type isEqualToString:@"picture"])
        {
            self.m_contentType = ENUM_MSG_TYPE_PIC;
        }
        else if ([type isEqualToString:@"audio"])
        {
            self.m_contentType = ENUM_MSG_TYPE_AUDIO;
        }
        else if ([type isEqualToString:@"homework"])
        {
            self.m_contentType = ENUM_MSG_TYPE_HOMEWORK;
            
        }
        else
        {
            SpeLog(@"暂时不处理此种消息");
            self.m_contentType = ENUM_MSG_TYPE_UNKNOWN;
        }
        
        NSString * groupId = [dic objectForKey:@"group_id"];
        if( groupId == nil)
        {
            self.m_chatType = ENUM_CHAT_TYPE_SINGLE;
            NSNumber *uid = [[dic objectForKey:@"from"]objectForKey:@"id"];
            self.m_chatId = [NSString stringWithFormat:@"%lld",[uid longLongValue]];
            
        }
        else
        {
            self.m_chatType = ENUM_CHAT_TYPE_GROUP;
            self.m_chatId =  [NSString stringWithFormat:@"%lld",[groupId longLongValue]];
            
        }
        
        self.m_strMessageBody = [dic objectForKey:@"content"];
        self.m_strShiftedMsg = self.m_strMessageBody;
        if(self.m_contentType == ENUM_MSG_TYPE_AUDIO)
        {
            NSArray *arr = [self.m_strMessageBody componentsSeparatedByString:@","];
            //分割,返回的字典中包括音频时长,音频的url
            if(arr.count > 1)
            {
                self.m_duration = [[arr objectAtIndex:0]integerValue];
                self.m_strMessageBody = [arr objectAtIndex:1];
            }
        }
        NSNumber *uid = [[dic objectForKey:@"from"]objectForKey:@"id"];
        self.m_oppositeChaterId = [NSString stringWithFormat:@"%lld",[uid longLongValue]];
        self.m_strOppositeSideName = [[dic objectForKey:@"from"]objectForKey:@"name"];
        self.m_strTime = [LocalTimeUtil getCurrentTime];
        self.m_isFromSelf = ENUM_MESSAGEFROM_OPPOSITE;
        self.m_messageStatus = ENUM_MESSAGESTATUS_UNREAD;
        self.m_timeLabState = ENUM_TIMELAB_STATE_HIDDEN;
        self.m_childId = [[[dic objectForKey:@"from"]objectForKey:@"childid"] longLongValue];
        self.m_groupId = [[dic objectForKey:@"from"]objectForKey:@"clazzid"];
        
        return self;
    }
    return nil;
}

- (void)setContentTypeWithMsgType:(NSString *)msgtype
{
    if ([msgtype isEqualToString:@"1"])
    {
        self.m_contentType = ENUM_MSG_TYPE_TEXT;
        return;
    }
    
    if ([msgtype isEqualToString:@"2"])
    {
        self.m_contentType = ENUM_MSG_TYPE_PIC;
        return;
    }
    
    if ([msgtype isEqualToString:@"3"])
    {
        self.m_contentType = ENUM_MSG_TYPE_AUDIO;
        return;
    }
    
    self.m_contentType = ENUM_MSG_TYPE_UNKNOWN;
}

- (void)setContentTypeWithAlertMsg:(NSString *)alertMsg
{
    if ([alertMsg isEqualToString:@"您收到一条消息!"])
    {
        self.m_contentType = ENUM_MSG_TYPE_TEXT;
        return;
    }
    
    if ([alertMsg isEqualToString:@"您收到一条语音消息!"])
    {
        self.m_contentType = ENUM_MSG_TYPE_AUDIO;
        return;
    }
    
    if ([alertMsg isEqualToString:@"您收到一条图片消息!"])
    {
        self.m_contentType = ENUM_MSG_TYPE_PIC;
        return;
    }
    
    if ([alertMsg isEqualToString:@"您收到一条图片消息!"])
    {
        self.m_contentType = ENUM_MSG_TYPE_HOMEWORK;
        return;
    }
    
    self.m_contentType = ENUM_MSG_TYPE_UNKNOWN;
}

@end
