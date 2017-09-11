//
//  NoticeViewController.m
//  officeMobile
//
//  Created by Points on 15-3-5.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "NoticeViewController.h"
#import "MessageTableViewCell.h"
#import "NoticeInfoViewController.h"
#import "AddNewNoticeViewController.h"
@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NoticeViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setDelegate:self];
        [m_searchBar setPlaceholder:@"请输入查询关键字"];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBackBtn];
    [title setText:@"通知管理"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    [self createButtons];
}



- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"待收通知",@"新建通知",@"已收通知",@"已发通知"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH/self.m_arrCategory.count, 40)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+36, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame)-HEIGHT_MAIN_BOTTOM)];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestCategoryData];

}


- (void)requestCategoryData
{
    if(self.m_currentIndex == 1)
    {
        AddNewNoticeViewController *add = [[AddNewNoticeViewController alloc]init];
        add.m_delegate = self;
        [self.navigationController pushViewController:add animated:YES];
        return;
    }
    
    [self requestData:YES];
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == self.m_currentIndex)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma MARK -

- (void)requestData:(BOOL)isRefresh
{
    if(isRefresh)
    {
        self.m_page = 0;
    }
    else
    {
        self.m_page++;
    }
    [self showWaitingView];
    self.m_isRefresh = isRefresh;
    [HTTP_MANAGER getNoticeList:m_searchBar.text
                          index:[NSNumber numberWithInteger:self.m_page]
                         status:self.m_currentIndex == 0 ? @"0" : @"1"
                           type:self.m_currentIndex
                 successedBlock:^(NSDictionary *retDic){
                     [self removeWaitingView];
                     if(self.m_isRefresh)
                     {
                         NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
                         self.m_arrData = ret[@"result"];
                     }
                     else
                     {
                         NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
                         NSArray *arrRet = ret[@"result"];
                         NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                         [arr addObjectsFromArray:arrRet];
                         self.m_arrData = arr;
                     }
                     [self reloadDeals];
                     
               } failedBolck:FAILED_BLOCK{
                   [self removeWaitingView];
                   [self reloadDeals];
               }];
    
    
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH-100, 18)];
    [_title setText:info[@"title"]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setTextColor:UIColorFromRGB(0x313131)];
    [_title setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:_title];
  
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-110, 10, 100, 18)];
    BOOL isFeedback = [info[@"isFeedback"]integerValue] == 1;
    if(!isFeedback)
    {
        if([info[@"status"]integerValue] == 1)
        {
            [state setText:@"已签收"];
        }
        else
        {
           [state setText:@"未签收"];
        }
    }
    else
    {
        if([info[@"status"]integerValue] == 0)
        {
            [state setText:@"未签收"];
        }
        else if ([info[@"status"]integerValue] == 1)
        {
            [state setText:@"未反馈"];
        }
        else if ([info[@"status"]integerValue] == 2)
        {
            [state setText:@"已反馈"];
        }
        else
        {
            
        }
    }
    [state setTextAlignment:NSTextAlignmentRight];
    [state setTextColor:UIColorFromRGB(0x7d7d7d)];
    [state setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:state];
    
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, MAIN_WIDTH-100, 18)];
    [time setText:[LocalTimeUtil timeWithTimeIntervalString:[info[@"startDate"]longLongValue]]];
    [time setTextAlignment:NSTextAlignmentLeft];
    [time setTextColor:UIColorFromRGB(0x7d7d7d)];
    [time setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:time];
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 40, MAIN_WIDTH/2-10, 18)];
    [desc setText:info[@"place"]];
    [desc setTextAlignment:NSTextAlignmentRight];
    [desc setTextColor:UIColorFromRGB(0x7d7d7d)];
    [desc setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:desc];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeInfoViewController *info = [[NoticeInfoViewController alloc]initWithInfo:[self.m_arrData objectAtIndex:indexPath.row] isSendedNotice:self.m_currentIndex == 3];
    info.m_delegate = self;
    info.view.tag = self.m_currentIndex;
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:self.m_isRefresh];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [self requestData:self.m_isRefresh];
}

- (void)onNeedRefreshTableView:(NSInteger)index
{
    self.m_currentIndex = index;
    [self requestCategoryData];
}
@end
