//
//  EmailTableViewCell.h
//  officeMobile
//
//  Created by Points on 15/5/20.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailTableViewCell : UITableViewCell
{
    UILabel *m_titleLab;
    UIImageView *m_important;
    UIImageView *m_icon;
    UILabel *m_timeLab;
    UILabel *m_reqUserLab;
    UILabel *m_statuLab;
    UIView *sep;
}
@property (nonatomic,strong) NSDictionary *currentDic;

@end
