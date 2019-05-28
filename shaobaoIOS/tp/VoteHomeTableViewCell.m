//
//  VoteHomeTableViewCell.m
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "VoteHomeTableViewCell.h"

@implementation VoteHomeTableViewCell

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
        
        m_createrLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MAIN_WIDTH-140, 20)];
        [m_createrLab setTextAlignment:NSTextAlignmentLeft];
        [m_createrLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_createrLab];
     
        m_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, MAIN_WIDTH-20, 30)];
        [m_title setTextAlignment:NSTextAlignmentLeft];
        m_title.numberOfLines = 0;
        [m_title setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_title];
        
        m_time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-140, 0, 140, 20)];
        [m_time setTextAlignment:NSTextAlignmentRight];
        [m_time setTextColor:[UIColor grayColor]];
        [m_time setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:m_time];
        
        self.m_arrImageViews = [NSMutableArray array];
        m_picview1 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview2 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview3 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        [self.m_arrImageViews addObject:m_picview1];
        [self.m_arrImageViews addObject:m_picview2];
        [self.m_arrImageViews addObject:m_picview3];
    
        [m_picview1 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview2 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview3 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
    
        m_picview1.tag = 1;
        m_picview2.tag = 2;
        m_picview3.tag = 3;
        [self addSubview:m_picview1];
        [self addSubview:m_picview2];
        [self addSubview:m_picview3];
        
        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, MAIN_WIDTH, 0.5)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [self addSubview:m_sep];
        
    }
    return self;
}

- (void)imgTap:(UIButton *)btn
{
    [self.m_delegate onTap:btn.tag-1 with:_currentData.m_arrPics];
}

- (void)setCurrentData:(ADTVoteItem *)currentData{
    _currentData = currentData;
    [m_createrLab setText:[NSString stringWithFormat:@"发起者:%@",currentData.m_createName]];
    [m_title setText:currentData.m_title];
    [m_time  setText:currentData.m_time];
    NSArray *arr = currentData.m_arrPics;
    for(int i=0;i<arr.count;i++){
        if(i>2){
            break;
        }
        NSString *url = [arr objectAtIndex:i];
        if(url.length == 0){
            continue;
        }
        NSInteger sep = 10;
        NSInteger cell_num = 3;
        NSInteger width = (MAIN_WIDTH-sep*(cell_num+1))/3;
        
        NSInteger row = i/cell_num;
        NSInteger coulmn = i%cell_num;
        
        EGOImageButton *img = [self.m_arrImageViews objectAtIndex:i];
        img.hidden = NO;
        img.frame= CGRectMake(sep+(sep+width)*coulmn, CGRectGetMaxY(m_title.frame)+sep+(sep+width)*row, width, width);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img setPlaceholderImage:[UIImage imageNamed:@"logo"]];
        [img setImageURL:[NSURL URLWithString:url]];
    }
    [m_sep setFrame:CGRectMake(0, currentData.m_arrPics.count == 0 ? 79.5:179.5, MAIN_WIDTH, 0.5)];
    
}
@end


@implementation VoteHomeTableViewCell2

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
        
        m_createrLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MAIN_WIDTH-140, 15)];
        [m_createrLab setTextAlignment:NSTextAlignmentLeft];
        [m_createrLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_createrLab];
        
        m_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, MAIN_WIDTH-20, 50)];
        [m_title setTextAlignment:NSTextAlignmentLeft];
        m_title.numberOfLines = 0;
        m_title.lineBreakMode = NSLineBreakByCharWrapping;
        [m_title setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:m_title];
        
        m_time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-140, 0, 140, 20)];
        [m_time setTextAlignment:NSTextAlignmentRight];
        [m_time setTextColor:[UIColor grayColor]];
        [m_time setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:m_time];
        
        self.m_arrImageViews = [NSMutableArray array];
        m_picview1 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview2 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        m_picview3 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"logo"]];
        [self.m_arrImageViews addObject:m_picview1];
        [self.m_arrImageViews addObject:m_picview2];
        [self.m_arrImageViews addObject:m_picview3];
        
        [m_picview1 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview2 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview3 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        
        m_picview1.tag = 1;
        m_picview2.tag = 2;
        m_picview3.tag = 3;
        [self addSubview:m_picview1];
        [self addSubview:m_picview2];
        [self addSubview:m_picview3];
        
        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, MAIN_WIDTH, 0.5)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [self addSubview:m_sep];
        
    }
    return self;
}

- (void)imgTap:(UIButton *)btn
{
    [self.m_delegate onTap:btn.tag-1 with:_currentData.m_arrPics];
}

- (void)setCurrentData:(ADTComment *)currentData{
    _currentData = currentData;
    [m_createrLab setText:[NSString stringWithFormat:@"%@",currentData.m_createrName]];
    [m_title setText:currentData.m_title];
    [m_time  setText:currentData.m_time];
    NSArray *arr = currentData.m_arrPics;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:13] withWidth:MAIN_WIDTH-20];
    [m_title setFrame:CGRectMake(10, m_title.frame.origin.y, size.width, size.height)];
    NSInteger sep = 30;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-sep*(cell_num+1))/3;
    

    for(int i=0;i<arr.count;i++){
        if(i>2){
            break;
        }
        NSString *url = [arr objectAtIndex:i];
        if(url.length == 0){
            continue;
        }
        NSInteger row = i/cell_num;
        NSInteger coulmn = i%cell_num;
        
        EGOImageButton *img = [self.m_arrImageViews objectAtIndex:i];
        img.hidden = NO;
        img.frame= CGRectMake(sep+(sep+width)*coulmn, CGRectGetMaxY(m_title.frame), width, width);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img setPlaceholderImage:[UIImage imageNamed:@"logo"]];
        [img setImageURL:[NSURL URLWithString:url]];
    }
    [m_sep setFrame:CGRectMake(0,CGRectGetMaxY(m_title.frame)+(arr.count>0 ? width:0)+10, MAIN_WIDTH, 0.5)];
}
@end
