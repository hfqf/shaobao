//
//  FindTableViewCell.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/28.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//
@protocol FindTableViewCellDelegate<NSObject>
@required
- (void)onAccept;

- (void)onDelete;
@end
#import <UIKit/UIKit.h>
#import "ADTFindItem.h"
@interface FindTableViewCell : UITableViewCell
{
    EGOImageView *m_head;
    UILabel *m_userType;
    UILabel *m_nameLab;
    UILabel *m_timeLab;
    UILabel *m_addressLab;
    UILabel *m_contentLab;
    UILabel *m_feeLab;
    UILabel *m_promiseLab;
    UILabel *m_stateLab;
    UIButton *m_acceptBtn;
    UIButton *m_delBtn;
    EGOImageView *m_picview1;
    EGOImageView *m_picview2;
    EGOImageView *m_picview3;
    EGOImageView *m_picview4;
    EGOImageView *m_picview5;
    EGOImageView *m_picview6;
}
@property(nonatomic,weak)id<FindTableViewCellDelegate>m_delegate;
@property(nonatomic,strong)ADTFindItem *currentData;
@end
