//
//  ADTChatMessage.h
//  JZH_Test
//  聊天总纪录表
//  Created by Points on 13-10-15.
//  Copyright (c) 2013年 Points. All rights reserved.
//



#import <Foundation/Foundation.h>
#import"PublicADT.h"
#import "ClassIconImageView.h"
@interface ADTChatMessage : NSObject<NSCopying>
{
    
    
    
    // NSString            *m_strOppositeSideName ;//对方的名字
    
    //  NSString            *m_strMessageBody;//聊天内容
    
    ENUM_MESSAGEFROM   m_isFromSelf;//1代表消息时发出去的，0即是接受的
    
    /*
     -1 发送失， 0 未发送成功 ，  1成功未接受
     图片，语音上传失败的话，就直接显示失败
     如果socket未连接或者未登录成功，也是失败
     如果socket状态正常，因为没有回执,所以send之后就置为1
     */
    ENUM_MESSAGESTATUS   m_messageStatus;//消息的状态
    
    
    // NSString           *m_strTime;//发送/接受时间
    
    /*
     int TYPE_MSG_TEXT = 1;
     int TYPE_MSG_AUDIO = 2;
     int TYPE_MSG_PIC = 3;
     int TYPE_MSG_HOMEWORK = 4;
     int TYPE_MSG_NOTICE = 5;
     */
    ENUM_MSG_TYPE       m_contentType;//消息内容类型
    
    /*
     int CHAT_TYPE_SINGLE = 0;
     int CHAT_TYPE_GROUP = 1;
     */
    ENUM_CHAT_TYPE      m_chatType;//聊天类型,单聊和群聊
    
    //NSString            *m_strMediaPath;//多媒体类型信息的资源文件路径
    NSInteger                 m_duration;//音频长度
    ENUM_TIMELAB_STATE    m_timeLabState;//是否需要显示时间提示
    //NSString            *m_strBelongToDuration;//当前消息所属的时间段(格式:2011-01-02 12:39)
}
@property(nonatomic,strong)NSString             *m_idInDB;
@property(nonatomic,strong)NSString             *m_strOppositeSideName;
@property(nonatomic,strong)NSString             *m_chatId;
@property(nonatomic,strong)NSString             *m_strMessageBody;
@property(nonatomic,strong)NSString             *m_strSmallPicUrl;
@property(nonatomic,strong)NSString             *m_strShiftedMsg;
@property(nonatomic,assign)ENUM_MESSAGEFROM     m_isFromSelf;
@property(nonatomic,assign)ENUM_MESSAGESTATUS   m_messageStatus;
@property(nonatomic,strong)NSString             *m_strTime;
@property(nonatomic,strong)NSString             *m_oppositeChaterId;
@property(nonatomic,assign)ENUM_MSG_TYPE        m_contentType;
@property(nonatomic,assign)ENUM_CHAT_TYPE       m_chatType;
@property(nonatomic,strong)NSString            *m_strMediaPath;
@property(nonatomic,assign)NSInteger                  m_duration;
@property(nonatomic,assign)ENUM_TIMELAB_STATE    m_timeLabState;
@property(nonatomic,strong)NSString            *m_groupId;
@property(nonatomic,copy)NSString            *m_strBelongToDuration;
@property(nonatomic,assign)long long            m_childId;
@property(nonatomic,assign) BOOL m_bIsOfflineMsg;
@property(nonatomic,strong) NSString* m_strMsgId;
@property(nonatomic,strong) NSString* m_strGroupName;
@property(nonatomic,strong) NSString* m_strGroupCount;
@property(nonatomic,assign) BOOL m_bIsHistoryMsg;
@property(nonatomic,strong) NSString* unreadCount;
@property(nonatomic,strong) NSString* m_strGroupAvatar;
@property(nonatomic,strong) NSString* m_strCellTimeStamp;
@property(nonatomic,strong) NSString* m_friendType;
//im sdk
@property(nonatomic,strong)UIImage      *m_image;
@property(nonatomic,strong)NSString     *m_msgid;
@property(nonatomic,strong)NSString     *m_strTimestamp;
@property(nonatomic,assign)NSInteger            backid;
@property(nonatomic,strong)ClassIconImageView            *headimage;
//照片墙
@property(nonatomic,strong)NSString     *locationInfoStr;
@property(nonatomic,strong) UIImage *sendPhotoImage;

- (id)initWithDic:(NSDictionary *)dic;
- (void)setContentTypeWithMsgType:(NSString *)msgtype;
- (void)setContentTypeWithAlertMsg:(NSString *)alertMsg;

@end
