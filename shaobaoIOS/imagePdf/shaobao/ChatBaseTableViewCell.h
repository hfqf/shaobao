//
//  ChatBaseTableViewCell.h
//  JZH_BASE
//
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTChatMessage.h"
#import "TimeHeaderView.h"
#import "ClassIconImageView.h"

@protocol ChatBaseTableViewCellDelegate;
@interface ChatBaseTableViewCell : UITableViewCell
{
    ClassIconImageView               *m_headView;//头像
    UIImageView                     *m_sendFailedIcon;
    TimeHeaderView                  *m_timeLab;
    UILabel                         *m_nameLab;
    
    NSTimer                         *m_timeOutTimer;
    
}
@property (nonatomic,assign) ENUM_TIMELAB_STATE m_stateTimeLab;
@property(nonatomic,copy)ADTChatMessage *m_currentMsg;
@property (nonatomic, weak) id<ChatBaseTableViewCellDelegate> delegate;

- (void)setValueDataWithMsg:(ADTChatMessage *)msg;
//重新发送成功,刷新界面
- (void)reSendSucceed;

//如果是文件类型,发送后设置消息状态
- (void)setMessageStatus:(ENUM_MESSAGESTATUS)staue;
@end


@protocol ChatBaseTableViewCellDelegate<NSObject>
@required
- (void) chatBaseTableViewCell:(ChatBaseTableViewCell *)cell selectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) chatBaseTableViewCell:(ChatBaseTableViewCell *)cell deselectCellAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *) chatBaseTableViewCell:(ChatBaseTableViewCell *)cell emailAddressForCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) chatBaseTableViewCell:(ChatBaseTableViewCell *)cell didPressSendEmailOnCellAtIndexPath:(NSIndexPath *)indexPath;
-(void) headClicked:(NSString *)strUserId;
@end
