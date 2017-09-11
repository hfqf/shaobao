//
//  SliderUITableView.h
//  jianye
//
//  Created by points on 2017/5/3.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//
@protocol SliderUITableViewDelegate <NSObject>

@required
- (void)onShowOrHideSelf;

@end
#import <UIKit/UIKit.h>

@interface SliderUITableView : UITableView
@property(nonatomic,weak)id<SliderUITableViewDelegate>m_delegate;
@end
