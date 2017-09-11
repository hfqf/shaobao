//
//  SpeRefreshAndLoadViewController.h
//  xxt_xj
//
//  Created by Points on 13-12-10.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeCommonTableView.h"
#import "BaseViewController.h"
@interface SpeRefreshAndLoadViewController : BaseViewController<MJRefreshBaseViewDelegate,UISearchBarDelegate>
{
    BOOL m_isRefresh;
    UIView *m_tipView;
    UISearchBar *m_searchBar;
}

@property (nonatomic,strong) SpeCommonTableView *tableView;
@property (nonatomic,copy) NSArray *m_arrData;

@property (nonatomic,strong) NSArray *m_arrCategory;

@property (nonatomic,strong) NSArray *m_arrBtn;

@property(nonatomic,assign)NSInteger m_currentIndex;

@property(nonatomic,assign)NSInteger m_page;

@property(nonatomic,assign)BOOL m_isRefresh;

@property (nonatomic,copy)NSDictionary *m_info;

@property (nonatomic,copy)NSDictionary *m_infoShow;
- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom;

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
withIsCustomNavigatiionHeight:(int)customNavHeight
;

- (void)requestData:(BOOL)isRefresh;

//刷新界面
- (void)reloadDeals;

-(void)showEmptyView;

- (void)removeEmptyView;

/**
 *  停止下拉加载
 */
- (void)endRefreshing;

@end
