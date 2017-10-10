//
//  ChatBaseTableViewCell.m
//  JZH_BASE
//
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

const NSInteger   SEND_TIMEOUT = 10;

#import "ChatBaseTableViewCell.h"
#import "sqliteADO.h"
#import "UIImageView+AFNetworking.h"

static const CFTimeInterval kLongPressMinimumDurationSeconds = 0.3;

@interface ChatBaseTableViewCell()<ClassIconImageViewDelegate>
- (void) menuWillHide:(NSNotification *)notification;
- (void) menuWillShow:(NSNotification *)notification;
- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer;
//- (void) sendEmailMenuItemPressed:(UIMenuController *)menuController;
@end


@implementation ChatBaseTableViewCell
@synthesize m_currentMsg,m_stateTimeLab;
- (void)dealloc
{
    [m_timeOutTimer invalidate];
    m_timeOutTimer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.m_currentMsg = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_headView = [[ClassIconImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        m_headView.userInteractionEnabled = YES;
        [self addSubview:m_headView];
        
        m_sendFailedIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"msg_state_fail_resend.png"]];
        [self addSubview:m_sendFailedIcon];
        m_sendFailedIcon.hidden = YES;

        
        m_timeLab = [[TimeHeaderView alloc]initWithFrame:CGRectMake(0, 10, MAIN_WIDTH, 15)];
        [self addSubview:m_timeLab];
        
        m_nameLab = [[UILabel alloc]init];
        [m_nameLab setBackgroundColor:[UIColor clearColor]];
        [m_nameLab setTextAlignment:NSTextAlignmentLeft];
        [m_nameLab setTextColor:[UIColor blackColor]];
        [m_nameLab setFont:[UIFont systemFontOfSize:11]];
        [self addSubview:m_nameLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setValueDataWithMsg:(ADTChatMessage *)msg;
{
    self.m_stateTimeLab = msg.m_timeLabState;

    self.m_currentMsg = msg;
    m_headView.hidden = NO;
    
    if(msg.m_isFromSelf !=  ENUM_MESSAGEFROM_SELF)
    {
        [m_headView setBackgroundColor:[UIColor clearColor]];
        [m_headView setFrame:CGRectMake(15,CGRectGetMaxY(m_timeLab.frame)+5, 40, 40)];
        [m_headView setNewImage:[NSURL URLWithString:msg.m_strGroupAvatar] WithSpeWith:1 withDefaultImg:@"logo"];
        
        CGSize size = [FontSizeUtil sizeOfString:msg.m_strOppositeSideName withFont:m_nameLab.font];
        [m_nameLab setText:msg.m_strOppositeSideName];
        [m_nameLab setFrame:CGRectMake(CGRectGetMaxX(m_headView.frame)+10, m_headView.frame.origin.y, size.width, self.m_currentMsg.m_chatType != ENUM_CHAT_TYPE_SINGLE  ?size.height : 0)];
    }
    else
    {
        [m_headView setFrame:CGRectMake(MAIN_WIDTH-45, CGRectGetMaxY(m_timeLab.frame)+5 , 40, 40)];
        
        [m_headView setNewImage:[LoginUserUtil headUrl] WithSpeWith:1 withDefaultImg:@"logo"];
        
        CGSize size = [FontSizeUtil sizeOfString:@"  " withFont:m_nameLab.font];
        [m_nameLab setText:@"  "];
        [m_nameLab setFrame:CGRectMake(CGRectGetMinX(m_headView.frame)-size.width-18, m_headView.frame.origin.y, size.width, self.m_currentMsg.m_chatType != ENUM_CHAT_TYPE_SINGLE  ?size.height : 0)];
    }
    [m_timeLab setTime:msg.m_strTime isHidden:NO];
}

- (void)reSendSucceed
{
    
}

//如果是文件类型,发送后设置消息状态
- (void)setMessageStatus:(ENUM_MESSAGESTATUS)staue
{
    
}

#pragma mark - 收到发送消息的回执

- (void)receiverReciption:(NSNotification *)noti
{
    NSArray * arr = [noti.object componentsSeparatedByString:@"_"];
    NSString*  dbId =  [arr lastObject];
    if([dbId isEqualToString:self.m_currentMsg.m_idInDB])
    {
        self.m_currentMsg.m_messageStatus = ENUM_MESSAGESTATUS_SUCCEED;
        m_sendFailedIcon.hidden = YES;
        [m_timeOutTimer invalidate];
        m_timeOutTimer = nil;
    }
}

#pragma mark - 超过 SEND_TIMEOUT 秒没有收到算是发送失败
- (void)sendFailed
{
    if(self.m_currentMsg.m_messageStatus == ENUM_MESSAGESTATUS_SUCCEED)
    {
        return;
    }
    self.m_currentMsg.m_messageStatus = ENUM_MESSAGESTATUS_FAILED;
    m_sendFailedIcon.hidden = NO;
    
    [m_timeOutTimer invalidate];
    m_timeOutTimer = nil;
}


- (void) menuWillHide:(NSNotification *)notification
{
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:deselectCellAtIndexPath:)]) {
        //[self.delegate emailableCell:self deselectCellAtIndexPath:self.indexPath];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void) menuWillShow:(NSNotification *)notification
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:selectCellAtIndexPath:)]) {
        //[self.delegate emailableCell:self selectCellAtIndexPath:self.indexPath];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

- (void) sendEmailMenuItemPressed:(UIMenuController *)menuController
{
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:didPressSendEmailOnCellAtIndexPath:)]) {
        //[self.delegate emailableCell:self didPressSendEmailOnCellAtIndexPath:self.indexPath];
    }
    [self resignFirstResponder];
}


#pragma mark -
#pragma mark UILongPressGestureRecognizer Handler Methods
- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ([self becomeFirstResponder] == NO) {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                  action:@selector(sendEmailMenuItemPressed:)];
    menu.menuItems = [NSArray arrayWithObject:item];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillShow:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

-(BOOL)becomeFirstResponder{
    return YES;
}

-(void)headBeClicked{
    // 群聊中非自己的消息，则打开单聊界面
    if (self.m_currentMsg.m_chatType == ENUM_CHAT_TYPE_GROUP && self.m_currentMsg.m_isFromSelf == ENUM_MESSAGEFROM_OPPOSITE) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(headClicked:)])
        {
            [self.delegate headClicked:self.m_currentMsg.m_oppositeChaterId];
        }
    }
}

@end
