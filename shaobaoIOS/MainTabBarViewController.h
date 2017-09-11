//
//  MainTabBarViewController.h
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013å¹´ Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TabbarButtonsBGView.h"
#import "SideslipView.h"

@protocol MainTabBarViewControllerDelegate <BaseViewControllerDelegate>

@required

- (void)onShowLeftView;

- (void)onRemoveTapObserver;

- (void)onAddTapObserver;

- (void)onResetY;


@end

@interface MainTabBarViewController : UITabBarController<BaseViewControllerDelegate,TabbarButtonsBGViewDelegate>

@property (nonatomic,assign)id<MainTabBarViewControllerDelegate>m_delegate;

@property(nonatomic,strong)SideslipView *leftView;


@end
