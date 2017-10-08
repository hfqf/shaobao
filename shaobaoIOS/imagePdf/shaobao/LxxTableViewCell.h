//
//  LxxTableViewCell.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//
#import "ADTLxxItemInfo.h"
@protocol LxxTableViewCellDelegate<NSObject>
@required

- (void)onLxxTableViewCellDelegateForDel:(ADTLxxItemInfo *)info;

- (void)onLxxTableViewCellDelegateForComment:(ADTLxxItemInfo *)info;
@end
#import <UIKit/UIKit.h>

@interface LxxTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    EGOImageView *m_head;
    UILabel *m_userType;
    UILabel *m_nameLab;
    UILabel *m_timeLab;
    UILabel *m_addressLab;
    UILabel *m_contentLab;
    UITableView *m_table;

    UIButton *m_delBtn;
    UIButton *m_commentBtn;

    EGOImageView *m_picview1;
    EGOImageView *m_picview2;
    EGOImageView *m_picview3;
    EGOImageView *m_picview4;
    EGOImageView *m_picview5;
    EGOImageView *m_picview6;
    UIView *m_sep;
}
@property(nonatomic,weak)id<LxxTableViewCellDelegate>m_delegate;

@property(nonatomic,strong) ADTLxxItemInfo *currentData;
@property(nonatomic,strong)NSMutableArray *m_arrImageViews;

@end
