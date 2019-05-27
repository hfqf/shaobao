//
//  VoteTableViewCell.h
//  shaobao
//
//  Created by Points on 2019/5/19.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//
@protocol VoteTableViewCellDelegate <NSObject>

@required

- (void)onWorkItemClicked:(ADTVoteOptionItem *)option;

- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl;

@end
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoteTableViewCell : UITableViewCell{
UILabel *m_optionLab;
UILabel *m_numLab;
UIButton *m_btn;
}

@property(nonatomic,strong) ADTVoteOptionItem *option;
@property(nonatomic,weak) id<VoteTableViewCellDelegate>m_delegate;
@end

NS_ASSUME_NONNULL_END
