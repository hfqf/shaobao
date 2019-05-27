//
//  StaffWorkItemTableViewCell.m
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "StaffWorkItemTableViewCell.h"

@implementation StaffWorkItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        m_tipLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 30)];
        [m_tipLab setTextAlignment:NSTextAlignmentLeft];
        [m_tipLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_tipLab];
        
        m_option1Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_tipLab.frame)+20, 5,20, 30)];
        [m_option1Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option1Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option1Lab setText:@"高"];
        [self addSubview:m_option1Lab];
        
        m_btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btn1 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn1.tag = 1;
        [m_btn1 setFrame:CGRectMake(CGRectGetMaxX(m_option1Lab.frame)+5, 5, 30, 30)];
        [m_btn1 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn1 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [m_btn1 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn1];
        
        m_option2Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_btn1.frame)+20, 5,20, 30)];
        [m_option2Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option2Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option2Lab setText:@"中"];
        [self addSubview:m_option2Lab];
        
        m_btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btn2 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn2.tag = 2;
        [m_btn2 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn2 setFrame:CGRectMake(CGRectGetMaxX(m_option2Lab.frame)+5, 5, 30, 30)];
        [m_btn2 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [m_btn2 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn2];
        
        m_option3Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_btn2.frame)+20, 5,20, 30)];
        [m_option3Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option3Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option3Lab setText:@"低"];
        [self addSubview:m_option3Lab];
        
        m_btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btn3 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn3.tag = 3;
        [m_btn3 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn3 setFrame:CGRectMake(CGRectGetMaxX(m_option3Lab.frame)+5, 5, 30, 30)];
        [m_btn3 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [m_btn3 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn3];
    }
    return self;
}

- (void)setTip:(NSString *)tip{
    _tip = tip;
    [m_tipLab setText:tip];
}

- (void)setIndex:(NSInteger)index{
    if(index == 1){
        m_btn1.selected = YES;
        m_btn2.selected = NO;
        m_btn3.selected = NO;
    }else if (index == 2)
    {
        m_btn1.selected = NO;
        m_btn2.selected = YES;
        m_btn3.selected = NO;
    }else{
        m_btn1.selected = NO;
        m_btn2.selected = NO;
        m_btn3.selected = YES;
    }
}




- (void)indexBtnClikced:(UIButton *)btn{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onWorkItemClicked:index:)]){
        [self.m_delegate onWorkItemClicked:self.tip index:btn.tag];
    }
}
@end


@implementation StaffWorkItemTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        m_tipLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 30)];
        [m_tipLab setTextAlignment:NSTextAlignmentLeft];
        [m_tipLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_tipLab];
        
        m_option1Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_tipLab.frame), 5,20, 30)];
        [m_option1Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option1Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option1Lab setText:@"高"];
        [self addSubview:m_option1Lab];
        
        m_btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [m_btn1 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn1.tag = 1;
        [m_btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_btn1 setFrame:CGRectMake(CGRectGetMaxX(m_option1Lab.frame)+5, 5, 30, 30)];
        [m_btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [m_btn1 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//        [m_btn1 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
//        [m_btn1 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [m_btn1 setTitle:@"(2)" forState:UIControlStateNormal];
        [self addSubview:m_btn1];
        
        m_option2Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_btn1.frame)+20, 5,20, 30)];
        [m_option2Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option2Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option2Lab setText:@"中"];
        [self addSubview:m_option2Lab];
        
        m_btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [m_btn2 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn2.tag = 2;
        [m_btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [m_btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_btn2 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn2 setFrame:CGRectMake(CGRectGetMaxX(m_option2Lab.frame)+5, 5, 30, 30)];
//        [m_btn2 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
//        [m_btn2 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn2];
        
        m_option3Lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_btn2.frame)+20, 5,20, 30)];
        [m_option3Lab setTextAlignment:NSTextAlignmentLeft];
        [m_option3Lab setFont:[UIFont systemFontOfSize:14]];
        [m_option3Lab setText:@"低"];
        [self addSubview:m_option3Lab];
        
        m_btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [m_btn3 addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn3.tag = 3;
        [m_btn3.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [m_btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_btn3 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn3 setFrame:CGRectMake(CGRectGetMaxX(m_option3Lab.frame)+5, 5, 30, 30)];
//        [m_btn3 setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
//        [m_btn3 setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn3];
    }
    return self;
}

- (void)setStaff:(ADTStaffItem *)staff withIndex:(NSInteger)index{
    self.staff = staff;
    self.index = index;
    
    if(index == 0){
        [m_tipLab setText:@"工作态度"];
        [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_gztd_g] forState:UIControlStateNormal];
        [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_gztd_z] forState:UIControlStateNormal];
        [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_gztd_d] forState:UIControlStateNormal];
    }else if (index == 1){
        [m_tipLab setText:@"业务能力"];
        [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ywnl_g] forState:UIControlStateNormal];
        [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ywnl_z] forState:UIControlStateNormal];
        [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ywnl_d] forState:UIControlStateNormal];
    }else if (index == 2){
        [m_tipLab setText:@"契约精神"];
         [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_qyjs_g] forState:UIControlStateNormal];
         [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_qyjs_z] forState:UIControlStateNormal];
         [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_qyjs_d] forState:UIControlStateNormal];
    }else if (index == 3){
         [m_tipLab setText:@"品行品质"];
         [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_pxpz_g] forState:UIControlStateNormal];
         [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_pxpz_z]  forState:UIControlStateNormal];
         [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_pxpz_d]  forState:UIControlStateNormal];
    }else if (index == 4){
        [m_tipLab setText:@"廉洁自律"];
        [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ljzl_g]  forState:UIControlStateNormal];
        [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ljzl_z] forState:UIControlStateNormal];
        [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_ljzl_d] forState:UIControlStateNormal];
    }else if (index == 5){
        [m_tipLab setText:@"社会贡献"];
        [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_shgx_g] forState:UIControlStateNormal];
        [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_shgx_z] forState:UIControlStateNormal];
        [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_shgx_d] forState:UIControlStateNormal];
    }else if (index == 6){
        [m_tipLab setText:@"自我膨胀"];
        [m_btn1 setTitle:[NSString stringWithFormat:@"%@票",staff.m_zwpz_g] forState:UIControlStateNormal];
        [m_btn2 setTitle:[NSString stringWithFormat:@"%@票",staff.m_zwpz_z] forState:UIControlStateNormal];
        [m_btn3 setTitle:[NSString stringWithFormat:@"%@票",staff.m_zwpz_d] forState:UIControlStateNormal];
    }


}


@end
