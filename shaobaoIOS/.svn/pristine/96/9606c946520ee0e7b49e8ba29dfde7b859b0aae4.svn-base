//
//  MessageTableViewCell.m
//  officeMobile
//
//  Created by Points on 15-3-8.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "MessageTableViewCell.h"
@implementation MessageTableViewCell

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
        
        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(5,40,(MAIN_WIDTH/2+40), 16)];
        [m_timeLab setBackgroundColor:[UIColor clearColor]];
        [m_timeLab setTextColor:[UIColor grayColor]];
        [m_timeLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_timeLab];
        
        m_reqUserLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,40,100, 16)];
        [m_reqUserLab setTextAlignment:NSTextAlignmentLeft];
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
        
        sep = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [self addSubview:sep];

    }
    return self;
}

- (void)setCurrentDic:(NSDictionary *)currentDic
{
    if(self.tag == 0)
    {

        [m_titleLab setText:[NSString stringWithFormat:@"%@",currentDic[@"subject"]]];
        [m_timeLab setText:[NSString stringWithFormat:@"日期:%@",currentDic[@"receivetime"] == nil ?currentDic[@"date"] : currentDic[@"receivetime"] ]];
        [m_reqUserLab setFrame:CGRectMake(MAIN_WIDTH-110,40,100, 16)];
        [m_reqUserLab setTextAlignment:NSTextAlignmentRight];
        if(currentDic[@"sendername"] == nil)
        {
            [m_reqUserLab setText:@""];
        }
        else
        {
            [m_reqUserLab setText:[NSString stringWithFormat:@"发送人:%@",[currentDic stringWithFilted:@"sendername"]]];
        }
    }
    else if (self.tag == 1)
    {
        [m_titleLab setText:[NSString stringWithFormat:@"%@",currentDic[@"subject"]]];
        [m_timeLab setText:currentDic[@"sendDate"]];
        [m_reqUserLab setText:currentDic[@"mainNames"]];
    }
    else if (self.tag == 2)
    {
        [m_titleLab setText:[NSString stringWithFormat:@"%@",currentDic[@"title"]]];
        [m_timeLab setText:[NSString stringWithFormat:@"日期:%@",currentDic[@"date"]]];
        [sep setFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
    }
    else if (self.tag == 3)
    {
        [m_timeLab setFont:[UIFont systemFontOfSize:12]];
        [m_reqUserLab setFont:m_timeLab.font];
        [m_statuLab setFont:m_reqUserLab.font];
        m_reqUserLab.frame = CGRectMake(MAIN_WIDTH/2-20,40,100, 16);
        [m_titleLab setText:[NSString stringWithFormat:@"请假单标题:%@",currentDic[@"subject"]]];
        [m_timeLab setText:[NSString stringWithFormat:@"日期:%@",currentDic[@"absenceDate"]]];
        [m_reqUserLab setText:[NSString stringWithFormat:@"审核人:%@",[currentDic stringWithFilted:@"receiveUserName"]]];
        NSInteger status = [currentDic[@"status"]integerValue];
        if(status == 0)
        {
            [m_statuLab setText:[NSString stringWithFormat:@"状态:%@",@"待提交"]];
        }
        else if (status == 1)
        {
            [m_statuLab setText:[NSString stringWithFormat:@"状态:%@",@"通过"]];
        }
        else if (status == 2)
        {
            [m_statuLab setText:[NSString stringWithFormat:@"状态:%@",@"审批中"]];
        }
        else if (status == -1)
        {
            [m_statuLab setText:[NSString stringWithFormat:@"状态:%@",@"不通过"]];
        }
        else
        {
            
        }
    }else if (self.tag == 4)
    {
        
    }
    else
    {
        
    }
  
}
@end
