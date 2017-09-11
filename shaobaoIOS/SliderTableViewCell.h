//
//  SliderTableViewCell.h
//  Education
//
//  Created by Points on 14-10-16.
//  Copyright (c) 2014年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderTableViewCell : UITableViewCell
{
    UIImageView *m_icon;
    UILabel    *m_nameLab;
    UIImageView *sep;
    UIImageView *_markImageView;
}

@property(nonatomic,strong)NSDictionary *m_cellDic;

- (void)setCellDic:(NSDictionary *)dic with:(BOOL)isSelected isHomeCell:(BOOL)flag;

@end
