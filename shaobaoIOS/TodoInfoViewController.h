//
//  TodoInfoViewController.h
//  officeMobile
//
//  Created by Points on 15-3-24.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//


#import "SpeRefreshAndLoadViewController.h"
#import "iAppPDFAppDelegate.h"

@protocol TodoInfoViewControllerDelegate <BaseViewControllerDelegate>

@required

- (void)onCommitCompleted;

@end
@interface TodoInfoViewController : SpeRefreshAndLoadViewController
{
            iAppPDFAppDelegate *app;
}
@property(nonatomic,strong)NSDictionary *m_info;

@property(nonatomic,strong)ADTGovermentFileInfo *m_infoData;

@property(nonatomic,weak)id<TodoInfoViewControllerDelegate>m_infoDelegate;
- (id)init:(id )todoInfo withIndex:(NSInteger)index;
@end
