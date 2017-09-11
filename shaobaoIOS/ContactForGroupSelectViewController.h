//
//  ContactForGroupSelectViewController.h
//  officeMobile
//
//  Created by Points on 15/11/10.
//  Copyright © 2015年 com.kinggrid. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactForGroupSelectViewController : ContactViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger m_index;
}
@property(nonatomic,strong)NSString *m_depId;
@property(nonatomic,strong)NSString *m_parentId;
@property(nonatomic,strong)NSString *m_preParentId;
@property(nonatomic,strong)ADTGropuInfo *m_currentGroup;
@property(nonatomic,strong)NSArray *m_arrGroup;

- (id)initForNotice;
@end
