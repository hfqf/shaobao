//
//  ContactTableViewCell.h
//  officeMobile
//
//  Created by Points on 15-3-10.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//
#import "ADTGropuInfo.h"

@protocol ContactTableViewCellDelegate <NSObject>

- (void)onSelected:(ADTGropuInfo *)info;

@end

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
{
    UIImageView *m_icon;
    UILabel *m_nameLab;
    UIView *sep;
    UIButton *selectBtn;

}
@property (nonatomic,strong) id currentData;
@property (nonatomic,weak)id<ContactTableViewCellDelegate>m_delegate;
@end
