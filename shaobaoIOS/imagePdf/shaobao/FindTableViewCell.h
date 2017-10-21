//
//  FindTableViewCell.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/28.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//
#import "ADTFindItem.h"

@protocol FindTableViewCellDelegate<NSObject>
@required
- (void)onAccept:(ADTFindItem *)data;

- (void)onDelete:(ADTFindItem *)data;

- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl;
@end
#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
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
    UILabel *m_processStateLab;
    UIButton *m_acceptBtn;
    UIButton *m_delBtn;
    EGOImageButton *m_picview1;
    EGOImageButton *m_picview2;
    EGOImageButton *m_picview3;
    EGOImageButton *m_picview4;
    EGOImageButton *m_picview5;
    EGOImageButton *m_picview6;
    UIView *m_sep;
}
@property(nonatomic,weak)id<FindTableViewCellDelegate>m_delegate;
@property(nonatomic,strong)ADTFindItem *currentData;
@property(nonatomic,strong)NSMutableArray *m_arrImageViews;
@end
