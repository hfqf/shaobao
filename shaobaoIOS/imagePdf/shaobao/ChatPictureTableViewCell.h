//
//  ChatPictureTableViewCell.h
//  JZH_BASE
//
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

@class ChatPictureTableViewCell;
@protocol ChatPictureTableViewCellDelegate <NSObject>

@required

- (void)ChatPictureTableViewCellLongPressed:(ChatPictureTableViewCell *)cell;


@optional

- (void)hideKeyBoard;

- (void)OnWatchFullScreenMap:(ChatPictureTableViewCell *)cell;

- (void)onSeeCurrentImageIdBigPic:(NSString *)iamgeId;
@end

#import <UIKit/UIKit.h>
#import "ChatBaseTableViewCell.h"
#import "ReceivedImageview.h"
@interface ChatPictureTableViewCell : ChatBaseTableViewCell<ReceivedImageviewDelegate>
{
    ReceivedImageview          *m_imageView;
    UIImageView                 *m_bubbleBackGroundView;
}

@property(nonatomic,weak)id<ChatPictureTableViewCellDelegate>m_delegate;

- (void)updatePicUrl:(NSString *)url;

@end
