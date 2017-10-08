//
//  ChatTextTableViewCell.m
//  JZH_BASE
//
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "ChatTextTableViewCell.h"
#import "RegexKitLite.h"
#import "JSONKit.h"
@implementation ChatTextTableViewCell
@synthesize m_delegate;
- (void)dealloc
{
    self.m_delegate = nil;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_bubbleBackGroundView = [[UIImageView alloc]init];
        m_bubbleBackGroundView.userInteractionEnabled = YES;
        [self addSubview:m_bubbleBackGroundView];
        m_content = [[UILabel alloc]init];
        [m_content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [m_content setBackgroundColor:[UIColor clearColor]];
        [m_bubbleBackGroundView addSubview:m_content];
        
        
        
        BGOtherGroundView = [[UIImageView alloc]init];
        BGOtherGroundView.userInteractionEnabled = YES;
        [self addSubview:BGOtherGroundView];
        
        titleViewBG=[[UIImageView alloc]init];
        [BGOtherGroundView addSubview:titleViewBG];
        
        
        titleName = [[UILabel alloc]init];
        titleName.font=[UIFont systemFontOfSize:13];
        [BGOtherGroundView addSubview:titleName];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setValueDataWithMsg:(ADTChatMessage *)msg
{

    [super setValueDataWithMsg:msg];
    SpeLog(@"%@",msg.m_strShiftedMsg);
        [m_content setText:msg.m_strMessageBody];
        CGSize bubbleSize = [self getSizeWithContent:m_content.text];
        bubbleSize = CGSizeMake(bubbleSize.width+(msg.m_isFromSelf != ENUM_MESSAGEFROM_SELF ?4:10), bubbleSize.height);
        [m_content setFrame:CGRectMake(8,5, bubbleSize.width, bubbleSize.height)];
        if(msg.m_isFromSelf != ENUM_MESSAGEFROM_SELF)
        {
            [m_content setFrame:CGRectMake(12,5, bubbleSize.width, bubbleSize.height)];

            [m_content setTextColor:UIColorFromRGB(0x323232)];

            [m_bubbleBackGroundView setImage:[[UIImage imageNamed:@"chat_in"]stretchableImageWithLeftCapWidth:17 topCapHeight:26]];
            [m_bubbleBackGroundView setFrame:CGRectMake(60,msg.m_chatType == ENUM_CHAT_TYPE_GROUP ?CGRectGetMaxY(m_nameLab.frame) : m_headView.frame.origin.y, bubbleSize.width+20, bubbleSize.height+12)];
            m_sendFailedIcon.hidden = YES;
        }
        else
        {
            [m_content setFrame:CGRectMake(8,5, bubbleSize.width, bubbleSize.height)];

            [m_content setTextColor:[UIColor whiteColor]];

            [m_bubbleBackGroundView setImage:[[UIImage imageNamed:@"chat_out"] stretchableImageWithLeftCapWidth:13 topCapHeight:26]];
            [m_bubbleBackGroundView setFrame:CGRectMake(MAIN_WIDTH-bubbleSize.width-70,m_headView.frame.origin.y, bubbleSize.width+10+8, bubbleSize.height+10)];
            
            //如果发送失败
            if (msg.m_messageStatus == ENUM_MESSAGESTATUS_FAILED)
            {
                [m_sendFailedIcon setFrame:CGRectMake(CGRectGetMinX(m_bubbleBackGroundView.frame)-22, CGRectGetMaxY(m_nameLab.frame)+3, 20, 20)
                 ];
                m_sendFailedIcon.hidden = NO;
            }
            else
            {
                m_sendFailedIcon.hidden = YES;
                
            }
            
            //如果发送失败
            [m_sendFailedIcon setFrame:CGRectMake(CGRectGetMinX(m_bubbleBackGroundView.frame)-22, CGRectGetMaxY(m_nameLab.frame)+3, 20, 20)];
            if(msg.m_messageStatus == ENUM_MESSAGESTATUS_SENDING)
            {
                m_sendFailedIcon.hidden = YES;
            }
        }
    }


//重新发送成功后,修改界面
- (void)reSendSucceed
{
    m_sendFailedIcon.hidden = YES;
}


- (CGSize)getSizeWithContent:(NSString *)str
{
    CGSize bubbleSize = [FontSizeUtil sizeOfString:str  withFont:[UIFont systemFontOfSize:FONT_SIZE] withWidth:MAX_LENGTH_CHAT_CELL];
    
    return bubbleSize;

}

@end
