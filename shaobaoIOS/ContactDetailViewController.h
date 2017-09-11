//
//  ContactDetailViewController.h
//  officeMobile
//
//  Created by Points on 15-3-12.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
#import "ADTGropuInfo.h"
@interface ContactDetailViewController : SpeRefreshAndLoadViewController

@property (nonatomic,strong)ADTContacterInfo *m_contactInfo;
- (id)initWith:(ADTContacterInfo *)contactInfo;
@end
