//
//  SideslipView.h
//  xxt_xj
//
//  Created by Yang on 14/11/4.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "SliderUITableView.h"
@protocol sideslipViewDelegate <NSObject>

- (void)sideslipViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)onLogoutBtnClicked;

-  (void)onPopToHomeView;

- (void)onSelectIndex:(NSInteger)index;

- (void)onShowMainView;
@end

@interface SideslipView : UIImageView
@property (nonatomic, strong) SliderUITableView *tableView;

@property (nonatomic, weak) id<sideslipViewDelegate>delegate;


@property(nonatomic,assign)NSInteger currentIndex;

@end
