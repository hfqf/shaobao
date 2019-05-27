//
//  TabbarCustomButton.m
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "TabbarCustomButton.h"
#import "EGOImageView.h"

@implementation TabbarCustomButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(ENUM_UNREAD_MESSAGE_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_numLab = [[LKBadgeView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, 25, 25)];
        m_numLab.textColor =[UIColor whiteColor];
        m_numLab.font = [UIFont systemFontOfSize:10];
        m_numLab.badgeColor = [UIColor redColor];
        m_numLab.horizontalAlignment = LKBadgeViewHorizontalAlignmentCenter;
        m_numLab.heightMode = LKBadgeViewHeightModeLarge;
        m_numLab.widthMode = LKBadgeViewWidthModeStandard;
        
        [self addSubview:m_numLab];
        self.adjustsImageWhenHighlighted = NO;
        UIImage *img1 = [UIImage imageNamed:unSelectedImg];
        UIImage *img2 = [UIImage imageNamed:selecredImg];
        [self setImage:img1 forState:UIControlStateNormal];
        [self setImage:img2 forState:UIControlStateSelected];

        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        //title
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,37, self.frame.size.width, 19)];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:title];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [self addSubview:titleLab];
        
    
    }
    return self;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if(index == 0 || index == 1)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshNum) name:KEY_NEED_REFRESH_NUM object:nil];
    }
}


- (void)selected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.m_delegate onSelectedIndex:self];
}


- (void)setButton:(BOOL)isSelected
{
    self.selected = isSelected;
   // [self setBackgroundColor:isSelected ? UIColorFromRGB(0x52a6e0):[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [titleLab setTextColor: isSelected ? KEY_COMMON_CORLOR :UIColorFromRGB(0x787878)];
}


- (void)refreshNum
{

}

@end
