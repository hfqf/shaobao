//
//  SelectContactViewController.h
//  officeMobile
//
//  Created by Points on 15-3-22.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//


#import "SpeRefreshAndLoadViewController.h"

@protocol SelectContactViewControllerDelegate <NSObject>

@required
- (void)onSelectContact:(NSArray *)arrContact type:(enum_contact_type )currentType;

@end

@interface SelectContactViewController : SpeRefreshAndLoadViewController

@property (nonatomic,assign)enum_contact_type m_currentType;

@property (nonatomic,weak)id<SelectContactViewControllerDelegate>m_delegate;

- (id)initWith:(enum_contact_type)type;
@end
