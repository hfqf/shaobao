//
//  LoginScrollerView.h
//  GCP
//
//  Created by Points on 15-1-18.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//


@protocol LoginScrollerViewDelegate <NSObject>

@required
- (void)onRemoveKeyboard;

@end

#import <UIKit/UIKit.h>

@interface LoginScrollerView : UIScrollView
@property (nonatomic,weak)id<LoginScrollerViewDelegate>m_delegate;
@end
