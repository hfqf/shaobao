//
//  SpeRefreshAndLoadViewController.m
//  xxt_xj
//
//  Created by Points on 13-12-10.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
@interface SpeRefreshAndLoadViewController ()
{

}


@end

@implementation SpeRefreshAndLoadViewController

- (void)dealloc
{
    self.m_arrData = nil;
    
    self.tableView._header.delegate = nil;
    self.tableView._footer.delegate = nil;
    
 
    [self.tableView._header.scrollView removeObserver:self.tableView._header forKeyPath:@"contentOffset"];
    [self.tableView._footer.scrollView removeObserver:self.tableView._footer forKeyPath:@"contentOffset"];
    
    
    self.tableView._header.scrollView = nil;
    self.tableView._footer.scrollView = nil;
    
    self.tableView = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
{
    self = [super init];
    if(self)
    {
        SpeCommonTableView * table =  [[SpeCommonTableView alloc]initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_NAVIGATION-(isNeedBottom?HEIGHT_MAIN_BOTTOM:0)) Style:style withIsNeedPullDown:isNeedPullDownRefresh withIsNeedPullUpLoadMore:isNeesLoadMore withIsNeedBottobBar:isNeedBottom  withViewController:self];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        UIView *bg = [[UIView alloc]initWithFrame:table.bounds];
//        [bg setBackgroundColor:[UIColor whiteColor]];
//        [table setBackgroundView:bg];
        self.tableView = table;
        [self.view addSubview:self.tableView];

        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
withIsCustomNavigatiionHeight:(int)customNavHeight
{
    self = [super init];
    if(self)
    {
        SpeCommonTableView * table =  [[SpeCommonTableView alloc]initWithFrame:CGRectMake(0, DISTANCE_TOP+customNavHeight, MAIN_WIDTH, MAIN_HEIGHT-DISTANCE_TOP-customNavHeight-(isNeedBottom?(OS_ABOVE_IOS7?HEIGHT_MAIN_BOTTOM:HEIGHT_MAIN_BOTTOM+20):OS_ABOVE_IOS7 ? 0:20)) Style:style withIsNeedPullDown:isNeedPullDownRefresh withIsNeedPullUpLoadMore:isNeesLoadMore withIsNeedBottobBar:isNeedBottom  withViewController:self];
        
        UIView *bg = [[UIView alloc]initWithFrame:table.bounds];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [table setBackgroundView:bg];
        self.tableView = table;
        
        [self.view addSubview:table];

        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.tableView._header)
    {
        [ self.tableView._header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0];
    }
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self.tableView._header performSelector:@selector(endRefreshing) withObject:nil afterDelay:30.0];
    if (refreshView == self.tableView._header)
    { // 下拉刷新
        [self requestData:YES];
    }
    else
    {
        [self requestData:NO];
    }
}


- (void)startRequestData:(MJRefreshBaseView *)pt
{
    if([pt isMemberOfClass:[MJRefreshHeaderView class]])
    {
        [self removeEmptyView];
        [self requestData:YES];
    }
    else
    {
        [self requestData:NO];
    }
}


#pragma mark - 需要子类实现
/*
 * isRefresh : YES, 是下拉刷新;NO是上拉加载
 */
- (void)requestData:(BOOL)isRefresh
{
 
}



#pragma mark 刷新
- (void)reloadDeals
{
    [self removeWaitingView];
    // 结束刷新状态
    [self.tableView._header endRefreshing];
    [self.tableView._footer endRefreshing];
    [self.tableView reloadData];
}

- (void)endRefreshing;
{
    if(self.tableView._header) {
        [self.tableView._header endRefreshing];
    }
}

//右滑
- (void)Swipe:(UISwipeGestureRecognizer *)gest
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(dragWithDirect:withCurrentTabIndex:)])
    {
        [self.m_delegate dragWithDirect:gest.direction withCurrentTabIndex:(int)self.view.tag];
    }
}

- (void)onShowSliderView
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onShowSliderView)])
    {
        [self.m_delegate onShowSliderView];
    }
}

- (void)showEmptyView
{
//{
//    if(![self.m_emptyView isDescendantOfView:self.view])
//    {
//        [self.view addSubview:self.m_emptyView];
//    }
}

- (void)removeEmptyView
{
//    if([self.m_emptyView isDescendantOfView:self.view])
//    {
//        [self.m_emptyView removeFromSuperview];
//    }
}



@end
