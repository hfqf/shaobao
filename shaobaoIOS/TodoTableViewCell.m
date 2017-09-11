//
//  TodoTableViewCell.m
//  officeMobile
//
//  Created by Points on 15/5/20.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "TodoTableViewCell.h"

@implementation TodoTableViewCell


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
        
        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(55,40,(MAIN_WIDTH/2-35), 16)];
        [m_timeLab setBackgroundColor:[UIColor clearColor]];
        [m_timeLab setTextColor:[UIColor grayColor]];
        [m_timeLab setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:m_timeLab];
        
        m_reqUserLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,40,MAIN_WIDTH/2-10, 16)];
        [m_reqUserLab setTextAlignment:NSTextAlignmentRight];
        [m_reqUserLab setBackgroundColor:[UIColor clearColor]];
        [m_reqUserLab setTextColor:[UIColor grayColor]];
        [m_reqUserLab setFont:[UIFont systemFontOfSize:15]];
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
        [sep setFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
        [self addSubview:sep];
        
    }
    return self;
}

- (void)setCurrentDic:(NSDictionary *)currentDic
{
    m_reqUserLab.hidden = NO;
    m_important.hidden = YES;
    [m_titleLab setText:[NSString stringWithFormat:@"%@",currentDic[@"subject"]]];
    if(self.tag == 0 || self.tag == 1)
    {
        BOOL isRead = [currentDic[@"isread"]intValue] == 1;
        BOOL isImport = [currentDic[@"isimport"] integerValue] == 2;
        m_important.hidden = !isImport;
        
        [m_icon setImage:[UIImage imageNamed:isRead ? @"read" : @"unread"]];

        [m_timeLab setText:currentDic[@"receivetime"]];
        NSString *sender = currentDic[@"sendername"];
        [m_reqUserLab setText:[NSString stringWithFormat:@"发送人:%@",sender]];
        
        if(sender.length == 0)
        {
            m_reqUserLab.hidden = YES;
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
    }
    else
    {
        BOOL isRead = [currentDic[@"isRead"]intValue] == 1;
        [m_icon setImage:[UIImage imageNamed:isRead ? @"read" : @"unread"]];
        [m_timeLab setText:currentDic[@"date"]];
        [m_reqUserLab setText:nil];
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
}
@end
