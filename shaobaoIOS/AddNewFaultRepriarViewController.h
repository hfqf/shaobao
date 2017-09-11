//
//  AddNewFaultRepriarViewController.h
//  jianye
//
//  Created by points on 2017/7/1.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
#import "iAppPDFAppDelegate.h"

@protocol AddNewFaultRepriarViewControllerDelegate <BaseViewControllerDelegate>

@required

- (void)onCommitCompleted;

@end
@interface AddNewFaultRepriarViewController : SpeRefreshAndLoadViewController
{
    iAppPDFAppDelegate *app;
}

@property(nonatomic,strong)ADTGovermentFileInfo *m_infoData;
@property(nonatomic,weak)id<AddNewFaultRepriarViewControllerDelegate>m_infoDelegate;
- (id)init:(id )todoInfo withIndex:(NSInteger)index;
@end

