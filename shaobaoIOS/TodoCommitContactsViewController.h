//
//  TodoCommitContactsViewController.h
//  jianye
//
//  Created by points on 2017/4/24.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

@protocol TodoCommitContactsViewControllerDelegate <NSObject>

@required

- (void)onTodoCommitContactsViewControllerSelected:(NSArray *)arrContacts;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface TodoCommitContactsViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak)id<TodoCommitContactsViewControllerDelegate>m_selectDelegate;
- (id)initWithSelectMode:(BOOL)isSingle withDataSource:(NSArray *)arr;
@end
