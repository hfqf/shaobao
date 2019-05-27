//
//  VoteTableViewCell.m
//  shaobao
//
//  Created by Points on 2019/5/19.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "VoteTableViewCell.h"

@implementation VoteTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btn addTarget:self action:@selector(indexBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        m_btn.tag = 1;
        [m_btn setFrame:CGRectMake(10, 5, 30, 30)];
        [m_btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [m_btn setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [m_btn setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [self addSubview:m_btn];
        
        m_optionLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, MAIN_WIDTH-90, 30)];
        [m_optionLab setTextAlignment:NSTextAlignmentLeft];
        [m_optionLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_optionLab];
        
        m_numLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-40, 5,30, 30)];
        [m_numLab setTextAlignment:NSTextAlignmentLeft];
        [m_numLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_numLab];
    }
    return self;
}

- (void)setOption:(ADTVoteOptionItem *)option{
    if(option.m_isNew){
        m_btn.hidden = YES;
        
    }else{
        m_btn.hidden = NO;
        m_btn.selected = NO;
    }
    
    _option = option;
    [m_optionLab setText:[NSString stringWithFormat:@"选项%lu:%@",option.m_index+1,option.m_option]];
    m_numLab.hidden = option.m_isNew;
    [m_numLab setText:[NSString stringWithFormat:@"%@票",option.m_num]];
}

- (void)indexBtnClikced:(UIButton *)btn{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onWorkItemClicked:)]){
        [self.m_delegate onWorkItemClicked:self.option];
    }
}
@end
