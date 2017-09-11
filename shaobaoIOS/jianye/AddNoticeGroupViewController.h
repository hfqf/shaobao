//
//  AddNoticeGroupViewController.h
//  jianye
//
//  Created by points on 2017/2/25.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

@protocol AddNoticeGroupViewController <NSObject>

@required

- (void)onSelectedUnits:(NSArray *)arr;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface AddNoticeGroupViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak) id<AddNoticeGroupViewController>m_delegate;

@end
