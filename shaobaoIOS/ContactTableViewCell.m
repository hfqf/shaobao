//
//  ContactTableViewCell.m
//  officeMobile
//
//  Created by Points on 15-3-10.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

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
        
        m_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        [self addSubview:m_icon];
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, MAIN_WIDTH-20, 20)];
        m_nameLab.numberOfLines = 0;
        m_nameLab.lineBreakMode = NSLineBreakByCharWrapping;
        [m_nameLab setBackgroundColor:[UIColor clearColor]];
        [m_nameLab setTextColor:[UIColor blackColor]];
        [m_nameLab setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:m_nameLab];
        
        sep = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.3;
        [self addSubview:sep];
        
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setFrame:CGRectMake(MAIN_WIDTH-50, 5, 30, 30)];
        [selectBtn setImage:[UIImage imageNamed:@"btn_checked"] forState:UIControlStateSelected];
        [selectBtn setImage:[UIImage imageNamed:@"btn_unchecked"] forState:UIControlStateNormal];
        [self addSubview:selectBtn];
    }
    return self;
}

- (void)setCurrentData:(id)currentData
{
    _currentData = currentData;
    self.accessoryType = UITableViewCellAccessoryNone;
    if([currentData isKindOfClass:[ADTContacterInfo class]])
    {
        selectBtn.hidden = YES;
        [m_icon setImage:[UIImage imageNamed:@"person"]];
        ADTContacterInfo *info = (ADTContacterInfo *)currentData;
        CGSize size = [FontSizeUtil sizeOfString:info.m_strUserName withFont:[UIFont boldSystemFontOfSize:16] withWidth:MAIN_WIDTH-60];
        m_nameLab.frame = CGRectMake(50, 10, MAIN_WIDTH-60, size.height);
        [m_nameLab setText:info.m_strUserName];
        self.accessoryType = info.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    }
    else
    {
        ADTGropuInfo *info = (ADTGropuInfo *)currentData;
        if(info.isContactView)
        {
            selectBtn.hidden = YES;
        }
        else
        {
            selectBtn.hidden = [info.m_strDeptName isEqualToString:@"..返回上级"];
        }
        [m_icon setImage:[UIImage imageNamed:@"unit"]];
        CGSize size = [FontSizeUtil sizeOfString:info.m_strDeptName withFont:[UIFont boldSystemFontOfSize:16] withWidth:MAIN_WIDTH-60];
        m_nameLab.frame = CGRectMake(50, 10, MAIN_WIDTH-60, size.height);
        [m_nameLab setText:info.m_strDeptName];
        
        selectBtn.selected = info.isSelected;

    }
    [sep setFrame:CGRectMake(0, CGRectGetMaxY(m_nameLab.frame)+10, MAIN_WIDTH, 0.5)];
}

- (void)selectBtnClicked
{
    selectBtn.selected = !selectBtn.selected;
    ADTGropuInfo *info = self.currentData;
    info.isSelected = !info.isSelected;
    
    [self.m_delegate onSelected:info];

}
@end

