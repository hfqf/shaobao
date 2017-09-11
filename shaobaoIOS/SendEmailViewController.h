//
//  SendEmailViewController.h
//  officeMobile
//
//  Created by Points on 15-3-22.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//


@protocol SendEmailViewControllerDelegate <NSObject>

@required

- (void)onSendEmailSucceed;

@end
#import "SpeRefreshAndLoadViewController.h"



@interface SendEmailViewController : SpeRefreshAndLoadViewController

@property(nonatomic,assign)enum_email_type m_currentType;

@property(nonatomic,strong)NSMutableDictionary *m_info;

@property(nonatomic,weak)id<SendEmailViewControllerDelegate>m_sendDelegate;

-(id)initWithInfo:(NSDictionary *)emialInfo WithType:(enum_email_type)type isSaveBox:(BOOL)falg;

- (id)initWithInfo:(NSDictionary *)emialInfo WithType:(enum_email_type)type;
@end
