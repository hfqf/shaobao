//
//  FindTableViewCell.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/28.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindTableViewCell.h"
#import "SDImageCache.h"
@implementation FindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)headClicked
{
    [self.m_delegate onHeadClicked:self.currentData.m_userId];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        m_head.layer.cornerRadius = 30;
        m_head.clipsToBounds = YES;
        m_head.userInteractionEnabled = YES;
        [self addSubview:m_head];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClicked)];
        [m_head addGestureRecognizer:tap];

        m_userType = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_head.frame)+10, 60, 18)];
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
        [m_timeLab setTextColor:UIColorFromRGB(0xc9c9c9)];
        [m_timeLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_timeLab];

        m_addressLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_nameLab.frame)+20,(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 18)];
        [m_addressLab setTextAlignment:NSTextAlignmentLeft];
        [m_addressLab setTextColor:UIColorFromRGB(0x999999)];
        [m_addressLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_addressLab];

        m_processStateLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120,CGRectGetMaxY(m_nameLab.frame)+20,110, 18)];
        [m_processStateLab setTextAlignment:NSTextAlignmentRight];
        [m_processStateLab setTextColor:KEY_COMMON_CORLOR];
        [m_processStateLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_processStateLab];

        m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_addressLab.frame)+20,(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 18)];
        m_contentLab.numberOfLines = 0;
        [m_contentLab setTextAlignment:NSTextAlignmentLeft];
        [m_contentLab setTextColor:UIColorFromRGB(0x999999)];
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
        [m_acceptBtn addTarget:self action:@selector(acceptBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_acceptBtn setTitle:@"承接" forState:0];
        [m_acceptBtn setTitleColor:KEY_COMMON_CORLOR forState:0];
        [m_acceptBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [m_acceptBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMinY(m_feeLab.frame), 70, 30)];
        m_acceptBtn.layer.cornerRadius = m_acceptBtn.frame.size.height/2;
        m_acceptBtn.layer.borderColor = UIColorFromRGB(0XCFCFCF).CGColor;
        m_acceptBtn.layer.borderWidth = 0.5;
        [self addSubview:m_acceptBtn];

        m_delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_delBtn setTitle:@"删除" forState:0];
        [m_delBtn setTitleColor:UIColorFromRGB(0xDB2E4A) forState:0];
        [m_delBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [m_delBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMinY(m_promiseLab.frame), 70, 30)];
        m_delBtn.layer.cornerRadius = m_delBtn.frame.size.height/2;
        m_delBtn.layer.borderColor = UIColorFromRGB(0XCFCFCF).CGColor;
        m_delBtn.layer.borderWidth = 0.5;
        [self addSubview:m_delBtn];

        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
        [self addSubview:m_sep];

        self.m_arrImageViews = [NSMutableArray array];
        m_picview1 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview1.tag = 1;
        m_picview2 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview2.tag = 2;
        m_picview3 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview3.tag = 3;
        m_picview4 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview4.tag = 4;
        m_picview5 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview5.tag = 5;
        m_picview6 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview6.tag = 6;


        [m_picview1 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview2 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview3 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview4 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview5 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview6 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];


        [self.m_arrImageViews addObject:m_picview1];
        [self.m_arrImageViews addObject:m_picview2];
        [self.m_arrImageViews addObject:m_picview3];
        [self.m_arrImageViews addObject:m_picview4];
        [self.m_arrImageViews addObject:m_picview5];
        [self.m_arrImageViews addObject:m_picview6];

    }
    return self;
}



- (void)imgTap:(UIButton *)btn
{
    [self.m_delegate onTap:btn.tag with:_currentData.m_arrPics];
}

- (void)setCurrentData:(ADTFindItem *)currentData{
    _currentData = currentData;
    [m_head sd_setImageWithURL:[NSURL URLWithString:currentData.m_userAvatar] placeholderImage:[UIImage imageNamed:@"logo"]];
    [m_userType setText:currentData.m_userType.integerValue == 1 ? @"个人" : @"商家"];
    [m_nameLab setText:currentData.m_userName];
    [m_timeLab setText:[currentData.m_createTime substringToIndex:10]];
    [m_contentLab setText:currentData.m_content];
    [m_addressLab setText:[NSString stringWithFormat:@"%@%@%@",currentData.m_provinceName,currentData.m_cityName,currentData.m_countyName]];

    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:m_contentLab.font withWidth:(MAIN_WIDTH-(20+CGRectGetWidth(m_head.frame)))];
    [m_contentLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_addressLab.frame), size.width, size.height)];

    m_processStateLab.frame =  CGRectMake(MAIN_WIDTH-120,CGRectGetMaxY(m_nameLab.frame)+20,110, 18);

    [m_feeLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_contentLab.frame)+10, 200, 18)];
    if(currentData.m_userType.integerValue == 1){
        m_feeLab.hidden = NO;
        NSString *fee = [NSString stringWithFormat:@"服务费:%@元",currentData.m_serviceFee];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:fee];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, 3)];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0x844c8d)
                           range:NSMakeRange(3, attrString.length-3)];
        [m_feeLab setAttributedText:attrString];
    }else{
        m_feeLab.hidden = YES;

    }

    NSString *state = nil;
    if(currentData.m_payStatus.integerValue == 0){
        state = @"未支付";
    }else if (currentData.m_payStatus.integerValue == 1){
        state = @"已支付";
    }else{
        state = @"未支付";
    }

    NSString *promis =  [NSString stringWithFormat:@"承诺定金:%@元 %@",currentData.m_creditFee,state];
    [m_promiseLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_feeLab.frame)+10, 200, 18)];

    NSMutableAttributedString *promiseString = [[NSMutableAttributedString alloc]initWithString:promis];
    [promiseString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, 4)];
    [promiseString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x844c8d)
                       range:NSMakeRange(5,currentData.m_creditFee.length+1)];

    [promiseString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(promis.length-3,3)];

    [promiseString addAttribute:NSBackgroundColorAttributeName
                          value:UIColorFromRGB(0x2bcee1)
                          range:NSMakeRange(promis.length-3,3)];
    [promiseString addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11]
                          range:NSMakeRange(promis.length-3,3)];

    [m_promiseLab setAttributedText:promiseString];


    NSArray *arr = currentData.m_arrPics;

    for(EGOImageView *img in self.m_arrImageViews){
        img.hidden = YES;
    }

    if(arr.count == 0){
        [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(m_promiseLab.frame)+10, MAIN_WIDTH, 0.5)];
    }
    
    for(int i=0;i<arr.count;i++){

        NSString *url = [arr objectAtIndex:i];
        if(url.length == 0){
            continue;
        }
        NSInteger sep = 10;
        NSInteger cell_num = 3;
        NSInteger width = (MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+sep*(cell_num+1)))/3;

        NSInteger row = i/cell_num;
        NSInteger coulmn = i%cell_num;

        EGOImageButton *img = [self.m_arrImageViews objectAtIndex:i];
        img.hidden = NO;
        img.frame= CGRectMake(CGRectGetMaxX(m_head.frame)+sep+(sep+width)*coulmn, CGRectGetMaxY(m_promiseLab.frame)+sep+(sep+width)*row, width, width);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",[arr objectAtIndex:i]]]];
        [self addSubview:img];
        [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+10, MAIN_WIDTH, 0.5)];

    }

    m_acceptBtn.hidden = YES;
    if(currentData.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue){
        [m_delBtn setFrame:CGRectMake(MAIN_WIDTH-80, CGRectGetMinY(m_promiseLab.frame)-10, 70, 30)];
        m_delBtn.hidden = NO;
    }else{
        [m_acceptBtn setFrame:CGRectMake(MAIN_WIDTH-80, CGRectGetMinY(m_promiseLab.frame)-10, 70, 30)];
        m_acceptBtn.hidden = currentData.m_payStatus.integerValue == 0;
    }

    if(currentData.m_status.integerValue == 0){
        [m_processStateLab setText:@"待承接"];
    }else if (currentData.m_status.integerValue == 1){
        [m_processStateLab setText:@"已承接"];
    }else if (currentData.m_status.integerValue == 2){
        [m_processStateLab setText:@"承接人已确认"];
    }else if (currentData.m_status.integerValue == 3){
        [m_processStateLab setText:@"已完成"];
    }else if (currentData.m_status.integerValue == 4){

    }else if (currentData.m_status.integerValue == 5){

    }

    if(currentData.m_userType.integerValue == 2){
        m_processStateLab.hidden = YES;
    }

    m_acceptBtn.hidden = YES;
    m_delBtn.hidden = YES;
}

- (void)acceptBtnClicked
{
    [self.m_delegate onAccept:self.currentData];
}

- (void)delBtnClicked
{
    [self.m_delegate onDelete:self.currentData];
}
@end
