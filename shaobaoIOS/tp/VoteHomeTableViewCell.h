//
//  VoteHomeTableViewCell.h
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

@protocol VoteHomeTableViewCellDelegate<NSObject>
@required
- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl;

@end


#import <UIKit/UIKit.h>


@interface VoteHomeTableViewCell : UITableViewCell{
    UILabel *m_title;
    UILabel *m_createrLab;
    UILabel *m_time;
    EGOImageButton *m_picview1;
    EGOImageButton *m_picview2;
    EGOImageButton *m_picview3;
    UIView *m_sep ;
}

@property(nonatomic,weak)id<VoteHomeTableViewCellDelegate>m_delegate;
@property(nonatomic,strong) ADTVoteItem *currentData;
@property(nonatomic,strong)NSMutableArray *m_arrImageViews;
@end

@interface VoteHomeTableViewCell2 : UITableViewCell{
    UILabel *m_title;
    UILabel *m_createrLab;
    UILabel *m_time;
    EGOImageButton *m_picview1;
    EGOImageButton *m_picview2;
    EGOImageButton *m_picview3;
    UIView *m_sep ;
}

@property(nonatomic,weak)id<VoteHomeTableViewCellDelegate>m_delegate;
@property(nonatomic,strong) ADTComment *currentData;
@property(nonatomic,strong)NSMutableArray *m_arrImageViews;
@end

