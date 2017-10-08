//
//  LxxTableViewCell.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LxxTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation LxxTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        m_head.layer.cornerRadius = 30;
        m_head.clipsToBounds = YES;
        [self addSubview:m_head];

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

        m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_nameLab.frame)+20,(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 18)];
        [m_contentLab setTextAlignment:NSTextAlignmentLeft];
        m_contentLab.numberOfLines = 0;
        [m_contentLab setTextColor:UIColorFromRGB(0x999999)];
        [m_contentLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_contentLab];

        m_commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_commentBtn setFrame:CGRectMake(MAIN_WIDTH-140, CGRectGetMaxY(m_contentLab.frame)+20, 50, 30)];
        [m_commentBtn setTitle:@"回复" forState:0];
        [m_commentBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_commentBtn];

        m_delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_commentBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_delBtn setFrame:CGRectMake(MAIN_WIDTH-70, CGRectGetMaxY(m_contentLab.frame)+20, 50, 30)];
        [m_delBtn setTitle:@"删除" forState:0];
        [m_delBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_delBtn];

        m_table = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
        m_table.dataSource = self;
        m_table.delegate = self;
        [self addSubview:m_table];

        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
        [self addSubview:m_sep];

        self.m_arrImageViews = [NSMutableArray array];
        m_picview1 = [[EGOImageView alloc]init];
        m_picview2 = [[EGOImageView alloc]init];
        m_picview3 = [[EGOImageView alloc]init];
        m_picview4 = [[EGOImageView alloc]init];
        m_picview5 = [[EGOImageView alloc]init];
        m_picview6 = [[EGOImageView alloc]init];
        [self.m_arrImageViews addObject:m_picview1];
        [self.m_arrImageViews addObject:m_picview2];
        [self.m_arrImageViews addObject:m_picview3];
        [self.m_arrImageViews addObject:m_picview4];
        [self.m_arrImageViews addObject:m_picview5];
        [self.m_arrImageViews addObject:m_picview6];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurrentData:(ADTLxxItemInfo *)currentData
{
    _currentData = currentData;
    [m_head sd_setImageWithURL:[NSURL URLWithString:currentData.m_userAvatar] placeholderImage:[UIImage imageNamed:@"logo"]];
    [m_nameLab setText:currentData.m_userName];
    [m_timeLab setText:[currentData.m_createTime substringToIndex:10]];
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:m_contentLab.font withWidth:(MAIN_WIDTH-(20+CGRectGetWidth(m_head.frame)))];
    [m_contentLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_nameLab.frame), size.width, size.height)];
    [m_contentLab setText:currentData.m_content];

    NSArray *arr = currentData.m_arrPics;

    for(EGOImageView *img in self.m_arrImageViews){
        img.hidden = YES;
    }

    if(arr.count == 0){
        [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(m_delBtn.frame)+10, MAIN_WIDTH, 0.5)];
    }

    for(int i=0;i<arr.count;i++){

        NSInteger sep = 10;
        NSInteger cell_num = 3;
        NSInteger width = (MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+sep*(cell_num+1)))/3;

        NSInteger row = i/cell_num;
        NSInteger coulmn = i%cell_num;

        EGOImageView *img = [self.m_arrImageViews objectAtIndex:i];
        img.hidden = NO;
        img.frame= CGRectMake(CGRectGetMaxX(m_head.frame)+sep+(sep+width)*coulmn, CGRectGetMaxY(m_contentLab.frame)+sep+(sep+width)*row, width, width);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BJ_SERVER,[arr objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"logo"]];
        [self addSubview:img];
        [m_commentBtn setFrame:CGRectMake(m_commentBtn.frame.origin.x, CGRectGetMaxY(img.frame)+10, m_commentBtn.frame.size.width, m_commentBtn.frame.size.height)];
        [m_delBtn setFrame:CGRectMake(m_delBtn.frame.origin.x, CGRectGetMaxY(img.frame)+10, m_delBtn.frame.size.width, m_delBtn.frame.size.height)];
        [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(m_delBtn.frame)+10, MAIN_WIDTH, 0.5)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentData.m_arrComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    return cell;
}

- (void)commentBtnClicked
{
    [self.m_delegate onLxxTableViewCellDelegateForComment:self.currentData];
}

- (void)delBtnClicked
{
    [self.m_delegate onLxxTableViewCellDelegateForDel:self.currentData];
}

@end
