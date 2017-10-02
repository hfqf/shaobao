//
//  FindTableViewCell.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/28.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindTableViewCell.h"

@implementation FindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        m_head.layer.cornerRadius = 30;
        m_head.clipsToBounds = YES;
        [self addSubview:m_head];

        m_userType = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_head.frame), 60, 18)];
        [m_userType setTextAlignment:NSTextAlignmentCenter];
        [m_userType setTextColor:[UIColor blackColor]];
        [m_userType setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_userType];

        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,10,120, 18)];
        [m_nameLab setTextAlignment:NSTextAlignmentLeft];
        [m_nameLab setTextColor:[UIColor blackColor]];
        [m_nameLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_nameLab];

        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120,10,110, 18)];
        [m_timeLab setTextAlignment:NSTextAlignmentRight];
        [m_timeLab setTextColor:[UIColor blackColor]];
        [m_timeLab setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:m_timeLab];

        m_addressLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_nameLab.frame),(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 18)];
        [m_addressLab setTextAlignment:NSTextAlignmentLeft];
        [m_addressLab setTextColor:[UIColor blackColor]];
        [m_addressLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_addressLab];

        m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_addressLab.frame),(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 18)];
        m_contentLab.numberOfLines = 0;
        [m_contentLab setTextAlignment:NSTextAlignmentLeft];
        [m_contentLab setTextColor:[UIColor blackColor]];
        [m_contentLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_contentLab];

        m_feeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_contentLab.frame),120, 18)];
        [m_feeLab setTextAlignment:NSTextAlignmentLeft];
        [m_feeLab setTextColor:[UIColor blackColor]];
        [m_feeLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_feeLab];

        m_promiseLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_feeLab.frame),120, 18)];
        [m_promiseLab setTextAlignment:NSTextAlignmentLeft];
        [m_promiseLab setTextColor:[UIColor blackColor]];
        [m_promiseLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_promiseLab];


        m_acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_acceptBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMinY(m_feeLab.frame), 90, 30)];
        m_acceptBtn.layer.cornerRadius = m_acceptBtn.frame.size.width/2;
        m_acceptBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:m_acceptBtn];

        m_delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_delBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMinY(m_promiseLab.frame), 90, 30)];
        m_delBtn.layer.cornerRadius = m_delBtn.frame.size.width/2;
        m_delBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:m_delBtn];

        
    }
    return self;
}

- (void)setCurrentData:(ADTFindItem *)currentData{
    _currentData = currentData;
    [m_head setImageURL:[NSURL URLWithString:currentData.m_userAvatar]];
    [m_userType setText:currentData.m_userType.integerValue == 1 ? @"个人" : @"商家"];
    [m_nameLab setText:currentData.m_userName];
    [m_timeLab setText:currentData.m_createTime];
    [m_addressLab setText:[NSString stringWithFormat:@"%@%@%@",currentData.m_provinceName,currentData.m_cityName,currentData.m_countyName]];

    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:m_contentLab.font withWidth:(MAIN_WIDTH-(20+CGRectGetWidth(m_head.frame)))];
    [m_contentLab setFrame:CGRectMake(CGRectGetMinX(m_head.frame)+10, CGRectGetMaxY(m_addressLab.frame), size.width, size.height)];

    [m_feeLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_contentLab.frame)+10, 200, 18)];
    if(currentData.m_userType.integerValue == 1){
        m_feeLab.hidden = NO;
        NSString *fee = [NSString stringWithFormat:@"服务费:%@元",currentData.m_serviceFee];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:fee];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, 3)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:KEY_COMMON_CORLOR
                           range:NSMakeRange(3, attrString.length-3)];
        [m_feeLab setAttributedText:attrString];
    }else{
        m_feeLab.hidden = YES;

    }

    NSString *state = nil;
    if(currentData.m_status.integerValue == 0){
        state = @"未支付";
    }else if (currentData.m_status.integerValue == 1){
        state = @"已支付";
    }else if (currentData.m_status.integerValue == 2){
        state = @"处理中";
    }else if (currentData.m_status.integerValue == 3){
        state = @"已完成";
    }

    NSString *promis = [NSString stringWithFormat:@"承诺定金:%@元 %@",currentData.m_creditFee,state];
    [m_promiseLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_promiseLab.frame), 200, 18)];

    NSMutableAttributedString *promiseString = [[NSMutableAttributedString alloc]initWithString:promis];
    [promiseString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, 4)];
    [promiseString addAttribute:NSForegroundColorAttributeName
                       value:KEY_COMMON_CORLOR
                       range:NSMakeRange(4,currentData.m_creditFee.length)];
    [promiseString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(promis.length-3,3)];

    [promiseString addAttribute:NSBackgroundColorAttributeName
                          value:[UIColor blueColor]
                          range:NSMakeRange(promis.length-3,3)];
    [m_promiseLab setAttributedText:promiseString];
}
@end
