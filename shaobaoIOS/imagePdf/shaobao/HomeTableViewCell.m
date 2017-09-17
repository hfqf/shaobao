//
//  HomeTableViewCell.m
//  shaobao
//
//  Created by points on 2017/9/17.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self addSubview:m_head];

        m_userType = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 18)];
        [m_userType setTextAlignment:NSTextAlignmentCenter];
        [m_userType setFont:[UIFont systemFontOfSize:15]];
        [m_userType setTextColor:[UIColor blackColor]];
        [self addSubview:m_userType];

        m_name =[[UILabel alloc]initWithFrame:CGRectMake(70, 10,120, 18)];
        [m_name setTextAlignment:NSTextAlignmentLeft];
        [m_name setFont:[UIFont systemFontOfSize:15]];
        [m_name setTextColor:[UIColor blackColor]];
        [self addSubview:m_name];

        m_time =[[UILabel alloc]initWithFrame:CGRectMake(70, 10,120, 18)];
        [m_time setTextAlignment:NSTextAlignmentRight];
        [m_time setFont:[UIFont systemFontOfSize:15]];
        [m_time setTextColor:UIColorFromRGB(0xc9c9c9)];
        [self addSubview:m_time];

        m_address = [[UILabel alloc]initWithFrame:CGRectMake(70, 30,MAIN_WIDTH-80, 18)];
        [m_address setTextAlignment:NSTextAlignmentLeft];
        [m_address setFont:[UIFont systemFontOfSize:15]];
        [m_address setTextColor:UIColorFromRGB(0x999999)];
        [self addSubview:m_address];

        m_desc = [[UILabel alloc]initWithFrame:CGRectMake(70,CGRectGetMaxY(m_address.frame)+5,MAIN_WIDTH-80, 18)];
        [m_desc setTextAlignment:NSTextAlignmentLeft];
        [m_desc setFont:[UIFont systemFontOfSize:15]];
        [m_desc setTextColor:UIColorFromRGB(0x999999)];
        [self addSubview:m_desc];

        m_promiss = [[UILabel alloc]initWithFrame:CGRectMake(70,CGRectGetMaxY(m_desc.frame)+5,MAIN_WIDTH-80, 18)];
        [m_promiss setTextAlignment:NSTextAlignmentLeft];
        [m_promiss setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_promiss];

        m_state = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,CGRectGetMaxY(m_desc.frame)+5,MAIN_WIDTH-80, 18)];
        [m_state setTextAlignment:NSTextAlignmentCenter];
        [m_state setFont:[UIFont systemFontOfSize:15]];
        [m_state setBackgroundColor:UIColorFromRGB(0x2bcee1)];
        m_state.layer.cornerRadius = 2;
        [m_state setTextColor:[UIColor whiteColor]];
        [self addSubview:m_state];

    }
    return self;
}

- (void)setInfoData:(NSDictionary *)infoData
{
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
