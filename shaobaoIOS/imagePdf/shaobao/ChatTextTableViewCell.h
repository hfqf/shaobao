//
//  ChatTextTableViewCell.h
//  JZH_BASE
//  文本信息的cell
//  Created by Points on 13-11-8.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBaseTableViewCell.h"

@class ChatTextTableViewCell;
@protocol ChatTextTableViewCellDelegate <NSObject>

@required
- (void)ChatTextTableViewCellLongPressed:(ChatTextTableViewCell *)cell;
- (void)ZanButtonOrPinlunButton:(ChatTextTableViewCell *)cell;
- (void)PinlunButton:(ChatTextTableViewCell *)cell;
@end

@interface ChatTextTableViewCell : ChatBaseTableViewCell
{
        UILabel          *m_content;// 文本信息
        UILabel          *m_contentother;// 文本信息
        UIImageView                 *m_bubbleBackGroundView;
    
        UIImageView              *BGOtherGroundView;
        UIImageView              *titleViewBG;
        UILabel                  *titleName;
}
@property(nonatomic,weak)id<ChatTextTableViewCellDelegate>m_delegate;


@end
