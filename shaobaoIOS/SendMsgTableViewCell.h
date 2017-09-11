//
//  SendMsgTableViewCell.h
//  officeMobile
//
//  Created by Points on 15-3-15.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMsgTableViewCell : UITableViewCell
{
    UILabel *m_titleLab;
    UILabel *m_contentLab;
    UIView *sep;
}

@property (nonatomic,strong)NSDictionary *currentDic;
@end
