//
//  EmailTableViewCell.m
//  officeMobile
//
//  Created by Points on 15/5/20.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "EmailTableViewCell.h"

@implementation EmailTableViewCell


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
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        m_titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, MAIN_WIDTH-20, 20)];
        [m_titleLab setBackgroundColor:[UIColor clearColor]];
        [m_titleLab setTextColor:[UIColor blackColor]];
        [m_titleLab setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:m_titleLab];
        
        
        m_important = [[UIImageView alloc]initWithFrame:CGRectMake(5,35,20,20)];
        [m_important setImage:[UIImage imageNamed:@"imp@2x"]];
        [self addSubview:m_important];
        
        m_icon= [[UIImageView alloc]initWithFrame:CGRectMake(30,35, 20, 20)];
        [m_icon setImage:[UIImage imageNamed:@"read"]];
        [self addSubview:m_icon];
        
        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(55,40,(MAIN_WIDTH/2+40), 16)];
        [m_timeLab setBackgroundColor:[UIColor clearColor]];
        [m_timeLab setTextColor:[UIColor grayColor]];
        [m_timeLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_timeLab];
        
        m_reqUserLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+30,40,MAIN_WIDTH/2-40, 15)];
        [m_reqUserLab setTextAlignment:NSTextAlignmentRight];
        m_reqUserLab.numberOfLines = 2;
        [m_reqUserLab setBackgroundColor:[UIColor clearColor]];
        [m_reqUserLab setTextColor:[UIColor grayColor]];
        [m_reqUserLab setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:m_reqUserLab];
        
        m_statuLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-80,40,70, 16)];
        [m_statuLab setTextAlignment:NSTextAlignmentLeft];
        [m_statuLab setBackgroundColor:[UIColor clearColor]];
        [m_statuLab setTextColor:[UIColor grayColor]];
        [m_statuLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_statuLab];
        
        sep = [[UIView alloc]init];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [self addSubview:sep];
        
    }
    return self;
}

- (void)setCurrentDic:(NSDictionary *)currentDic
{
    [m_icon setImage:[UIImage imageNamed:@"read"]];
    NSString *_title = [NSString stringWithFormat:@"%@",[currentDic stringWithFilted:@"subject"]];
    m_important.hidden = self.tag != 30;
    BOOL isRead = [currentDic[@"readStatus"]integerValue] > 0;
    if (self.tag == 30 || self.tag == 40)
    {
        [m_titleLab setText:_title.length == 0 ? @"无主题" : _title];
        [m_timeLab setText:currentDic[@"sendDate"]];
        [m_reqUserLab setText:currentDic[@"senderName"]];
        
        if(self.tag == 30)
        {
            m_important.hidden = [currentDic[@"important"] integerValue] == 0;
            
            if(isRead)
            {
                [m_icon setImage:[UIImage imageNamed:@"read"]];
            }
            else
            {
                [m_icon setImage:[UIImage imageNamed:@"unread"]];
            }
        }
    }
    else
    {
        if(self.tag == 20)
        {
            m_important.hidden = [currentDic[@"important"] integerValue] == 0;
            
            if(isRead)
            {
                [m_icon setImage:[UIImage imageNamed:@"read"]];
            }
            else
            {
                [m_icon setImage:[UIImage imageNamed:@"unread"]];
            }
        }
        [m_titleLab setText:_title.length == 0 ? @"无主题" : _title];
        [m_timeLab setText:currentDic[@"sendDate"]];
        [m_reqUserLab setText:currentDic[@"mainNames"]];
    }
    if(m_important.hidden)
    {
        [m_icon setFrame:CGRectMake(5,35, 20, 20)];
        m_timeLab.frame = CGRectMake(35,40,(MAIN_WIDTH/2+40), 16);
    }
    else
    {
        [m_icon setFrame:CGRectMake(30,35, 20, 20)];
        m_timeLab.frame = CGRectMake(55,40,(MAIN_WIDTH/2+40), 16);
        
    }
    
    CGSize size = [FontSizeUtil sizeOfString:m_reqUserLab.text withFont:m_reqUserLab.font withWidth:m_reqUserLab.frame.size.width];
    if(size.height> 30)
    {
        size = CGSizeMake(size.width, 30);
    }
    [m_reqUserLab setFrame:CGRectMake(MAIN_WIDTH/2+30, 40, MAIN_WIDTH/2-40, size.height)];
    [sep setFrame:CGRectMake(0,CGRectGetMaxY(m_reqUserLab.frame)+6, MAIN_WIDTH, 0.5)];

}
@end
