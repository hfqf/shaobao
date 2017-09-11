//
//  MessageDetailViewController.h
//  officeMobile
//
//  Created by Points on 15-3-15.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface MessageDetailViewController : SpeRefreshAndLoadViewController

@property(nonatomic,assign)BOOL m_isSendMsg;
@property(nonatomic,strong)NSDictionary *m_info;
- (id)initWithInfo:(NSDictionary *)info;
@end
