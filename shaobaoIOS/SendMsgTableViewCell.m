//
//  SendMsgTableViewCell.m
//  officeMobile
//
//  Created by Points on 15-3-15.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SendMsgTableViewCell.h"

@implementation SendMsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH-20, 17)];
        [m_titleLab setBackgroundColor:[UIColor clearColor]];
        [m_titleLab setFont:[UIFont boldSystemFontOfSize:15]];
        [m_titleLab setTextColor:[UIColor blackColor]];
        [self addSubview:m_titleLab];
        
        
        m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10,30, MAIN_WIDTH-20, 17)];
        [m_contentLab setBackgroundColor:[UIColor clearColor]];
        [m_contentLab setFont:[UIFont systemFontOfSize:13]];
        [m_contentLab setTextColor:[UIColor grayColor]];
        [self addSubview:m_contentLab];
        
        sep = [[UIView alloc]initWithFrame:CGRectMake(0,59.5,MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [self addSubview:sep];
    }
    return self;
}

- (void)setCurrentDic:(NSDictionary *)currentDic
{
    [m_titleLab setText:[NSString stringWithFormat:@"接收号码:%@",[currentDic stringWithFilted:@"dPhonenum"]]];
    [m_contentLab setText:[NSString stringWithFormat:@"发送时间:%@",currentDic[@"sendTime"]]];
}

@end
