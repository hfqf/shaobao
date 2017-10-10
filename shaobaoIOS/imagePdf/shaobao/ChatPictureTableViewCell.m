//
//  ChatPictureTableViewCell.m
//  JZH_BASE
//
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "ChatPictureTableViewCell.h"
#import "LocalImageHelper.h"
#import "UIImage+STExt.h"

@implementation ChatPictureTableViewCell
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
        m_imageView = [[ReceivedImageview alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        m_imageView.m_delegate = self;
        m_imageView.userInteractionEnabled = YES;
        [m_bubbleBackGroundView addSubview:m_imageView];
        
        m_imageView.layer.masksToBounds = YES;
        m_imageView.layer.cornerRadius = 3;
        m_imageView.layer.borderColor = [UIColor clearColor].CGColor;
        m_imageView.layer.borderWidth = 1;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updatePicUrl:(NSString *)url
{
    m_imageView.m_strImageUrl = url;
    self.m_currentMsg.m_strMediaPath = url;
}

- (void)setValueDataWithMsg:(ADTChatMessage *)msg
{
    [super setValueDataWithMsg:msg];

    
    // 先判断路径
    NSString *urlStr = [NSString stringWithFormat:@"%@/upload/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],msg.m_isFromSelf == ENUM_MESSAGEFROM_SELF ?  msg.m_strMediaPath :  msg.m_strMessageBody];
    //NSString *urlStr = msg.m_strMessageBody;//[LocalImageHelper getFinalPath:msg.m_strMediaPath With:YES];
    
    //UIImage *image = [UIImage imageNamed:urlStr];
    UIImage *image = [self getImageWithUrl:urlStr];
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:urlStr];
    
    if (exist) {
        CGSize bubbleSize;
        m_imageView.isLocationSnap = NO;
        
        CGSize size = image.size;//[image imageConstrainedToSize:CGSizeMake(MAIN_WIDTH - 120, MAIN_HEIGHT/2.0)];
        bubbleSize = size;
        
        
        [m_imageView setImage:image];
        m_imageView.m_origianPicturePath = urlStr;
//        m_imageView.m_origianPicturePath = [LocalImageHelper getFinalPath:msg.m_strMediaPath With:YES];
        
        if(msg.m_isFromSelf != ENUM_MESSAGEFROM_SELF)
        {
            [m_bubbleBackGroundView setImage:[[UIImage imageNamed:@"chat_sx_in"]stretchableImageWithLeftCapWidth:17 topCapHeight:26]];
            [m_bubbleBackGroundView setFrame:CGRectMake(60,msg.m_chatType == ENUM_CHAT_TYPE_GROUP ?CGRectGetMaxY(m_nameLab.frame) : m_headView.frame.origin.y, bubbleSize.width+10+4, bubbleSize.height+8)];
            
            [m_imageView setNewFrame:CGRectMake(9.5,4, bubbleSize.width, bubbleSize.height)];
                        
        }
        else
        {
            [m_bubbleBackGroundView setImage:[[UIImage imageNamed:@"chat_sx_out"] stretchableImageWithLeftCapWidth:13 topCapHeight:26]];
            [m_bubbleBackGroundView setFrame:CGRectMake(MAIN_WIDTH-bubbleSize.width-75,m_headView.frame.origin.y, bubbleSize.width+10+10, bubbleSize.height+10)];
            [m_imageView setNewFrame:CGRectMake(3.5,4, bubbleSize.width+6.5, bubbleSize.height+2)];
            
            //如果发送失败
            [m_sendFailedIcon setFrame:CGRectMake(CGRectGetMinX(m_bubbleBackGroundView.frame)-22, CGRectGetMaxY(m_nameLab.frame)+3, 20, 20)];
            if(msg.m_messageStatus == ENUM_MESSAGESTATUS_SENDING)
            {
                m_sendFailedIcon.hidden = YES;
                
            }
            if (msg.m_messageStatus == ENUM_MESSAGESTATUS_FAILED )
            {
                m_sendFailedIcon.hidden = NO;
            }
            if (msg.m_messageStatus == ENUM_MESSAGESTATUS_SUCCEED )
            {
                m_sendFailedIcon.hidden = YES;
            }
            
        }
    }
}

- (UIImage *)getImageWithUrl:(NSString *)path
{
    //UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    //UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImage *image = [LocalImageHelper getImageWithPath:path];
    if( image == nil)
    {
        image = [UIImage imageNamed:@"app_fail_image"];
    }
    return image;
}


//继承父类
- (void)reSendSucceed
{
    m_sendFailedIcon.hidden = YES;
}

//转圈圈
- (void)startResend
{

}

//如果是文件类型,发送后设置消息状态
- (void)setMessageStatus:(ENUM_MESSAGESTATUS)staue
{

    self.m_currentMsg.m_messageStatus = staue;
    if(staue == ENUM_MESSAGESTATUS_SUCCEED)
    {
        m_sendFailedIcon.hidden = YES;
    }
    if(staue == ENUM_MESSAGESTATUS_FAILED)
    {
        m_sendFailedIcon.hidden = NO;
    }
}

#pragma mark - 长按bubble中的图片
- (void)longPressedInReceivedImageview
{
    [self.m_delegate ChatPictureTableViewCellLongPressed:self];
}


//全屏查看地图
- (void)OnWatchFullScreenMap
{
    [self.m_delegate OnWatchFullScreenMap:self];
}

- (void)hideKeyboard
{
    [self.m_delegate hideKeyBoard];
}

- (void)onSeeCurrentImageIdBigPic:(NSString *)iamgeId
{
    [self.m_delegate onSeeCurrentImageIdBigPic:iamgeId];
}
@end