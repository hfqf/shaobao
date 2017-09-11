//
//  ContactViewController.h
//  officeMobile
//
//  Created by Points on 15-3-5.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
#import "ADTGropuInfo.h"
@protocol ContactViewControllerDelegate <NSObject>

@required

- (void)onSelected:(NSArray *)arrContacter;

@end

@interface ContactViewController : SpeRefreshAndLoadViewController
@property (nonatomic,weak)id<ContactViewControllerDelegate>m_selectDelegate;
@property(nonatomic,strong)NSMutableDictionary *m_selectedContactDic;

- (id)initForSelectContact;

- (id)initForSelectSingleContact;
@end
