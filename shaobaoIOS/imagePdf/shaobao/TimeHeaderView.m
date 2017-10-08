//
//  TimeHeaderView.m
//  JZH_BASE
//
//  Created by Points on 13-11-13.
//  Copyright (c) 2013年 Points. All rights reserved.
//
#define LineWidth 60
#define TimeLabWidth 150
#define TimeLabHeight 15
#import "TimeHeaderView.h"
#import "LocalTimeUtil.h"
#import "NSDate+Parser.h"

@implementation TimeHeaderView


- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
    
//        UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        [headView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:headView];

        leftLine = [[UIImageView alloc]initWithFrame:CGRectMake(( CGRectGetWidth(self.frame) - LineWidth*2 - TimeLabWidth ) / 2, 6 ,58, 2)];
        [leftLine setImage:[UIImage imageNamed:@"homelist_time_left"]];
        [leftLine setBackgroundColor:[UIColor clearColor]];
        //[headView addSubview:leftLine];
        
         m_timeLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLine.frame) , 0, TimeLabWidth, TimeLabHeight)];
        [m_timeLab setBackgroundColor:[UIColor clearColor]];
        [m_timeLab setTextAlignment:NSTextAlignmentCenter];
        [m_timeLab setFont:[UIFont systemFontOfSize:14]];
        [m_timeLab setTextColor:[UIColor colorWithHexString:@"#454545"]];
        [headView addSubview:m_timeLab];
        
        
        rightLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_timeLab.frame),6, 58, 2)];
        [rightLine setImage:[UIImage imageNamed:@"homelist_time_right"]];
        [rightLine setBackgroundColor:[UIColor clearColor]];
        //[headView addSubview:rightLine];
        
        return self;
    }
    return self;
}

- (void)setTime:(NSString *)time isHidden:(BOOL)flag
{
    if (19 != time.length)
    {
        return;
    }
    
    NSDate* now = [NSDate date];
    NSDate* date = [NSDate dateWithString:time];
    
    BOOL isToday = [LocalTimeUtil isToday:time];
    BOOL isYes   =[LocalTimeUtil isYesterday:time];
    if(isToday)
    {
//        [m_timeLab setText:[NSString stringWithFormat:@"今天%@",[time substringWithRange:NSMakeRange(11, 5)]]];
        [m_timeLab setText:[NSString stringWithFormat:@"%d月%@日 %@:%@", [date.month intValue], date.day, date.hour, date.minute]];

    }
    else if (isYes)
    {
//        [m_timeLab setText:[NSString stringWithFormat:@"昨天%@",[time substringWithRange:NSMakeRange(11, 5)]]];
        [m_timeLab setText:[NSString stringWithFormat:@"%d月%@日 %@:%@", [date.month intValue], date.day, date.hour, date.minute]];

    }
    else if ([[now year] isEqualToString:[date year]])
    {
        [m_timeLab setText:[NSString stringWithFormat:@"%d月%@日 %@:%@", [date.month intValue], date.day, date.hour, date.minute]];
    }
    else
    {
        [m_timeLab setText:[NSString stringWithFormat:@"%@年%d月%@日 %@:%@", date.year, [date.month intValue], date.day, date.hour, date.minute]];
    }
    m_timeLab.hidden = flag;
    rightLine.hidden = flag;
    leftLine.hidden = flag;
}



@end
