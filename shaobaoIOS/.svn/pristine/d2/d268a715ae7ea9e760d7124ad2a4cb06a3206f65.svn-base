
//
//  SliderTableViewCell.m
//  Education
//
//  Created by Points on 14-10-16.
//  Copyright (c) 2014年 Education. All rights reserved.
//

#import "SliderTableViewCell.h"
#import <AvailabilityMacros.h>
#import "LoginUserUtil.h"

@implementation SliderTableViewCell

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
        [self setBackgroundColor:[UIColor clearColor]];
        m_icon = [[UIImageView alloc]initWithFrame:CGRectMake(20,5, 30, 30)];
        [self addSubview:m_icon];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(64,10,MAIN_WIDTH/2,20)];
        [m_nameLab setBackgroundColor:[UIColor clearColor]];
        [m_nameLab setTextAlignment:NSTextAlignmentLeft];
        [m_nameLab setFont:[UIFont systemFontOfSize:18]];
        [m_nameLab setTextColor:[UIColor whiteColor]];
        [self addSubview:m_nameLab];
    }
    return self;
}

- (void)setCellDic:(NSDictionary *)dic with:(BOOL)isSelected isHomeCell:(BOOL)flag
{
    [m_icon setImage:[UIImage imageNamed:dic[@"icon"]]];
    [m_nameLab setText:dic[@"name"]];
    
    NSString *name = dic[@"name"];
    CGSize size = CGSizeOfString(name, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), m_nameLab.font);
    UIViewSetOriginX(_markImageView, CGRectGetMinX(m_nameLab.frame) + size.width+ 6);
    
    [self setBackgroundColor:isSelected ? UIColorFromRGB(0x12334f) : UIColorFromRGB(0x204565)];
}
@end
