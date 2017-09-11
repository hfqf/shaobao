//
//  MeetingSelectRoomViewController.h
//  jianye
//
//  Created by points on 2017/2/26.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

@protocol MeetingSelectRoomViewControllerDelegate <NSObject>

@required

- (void)onSelectedRoom:(NSDictionary *)info;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface MeetingSelectRoomViewController : SpeRefreshAndLoadViewController

@property(nonatomic,weak)id<MeetingSelectRoomViewControllerDelegate>m_selectDelegate;


- (id)initWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
@end
