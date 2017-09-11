//
//  TodoCheckInfoViewController.h
//  officeMobile
//
//  Created by Points on 15/11/2.
//  Copyright © 2015年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface TodoCheckInfoViewController : SpeRefreshAndLoadViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithInfo:(NSArray *)arr;

@end
