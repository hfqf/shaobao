//
//  MeetingManagerViewController.m
//  jianye
//
//  Created by points on 2017/2/10.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "MeetingManagerViewController.h"
#import "MeetingInfoViewController.h"
#import "AddNewMeetingViewController.h"
@interface MeetingManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MeetingManagerViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"请输入查询关键字"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
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
    [self requestData:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"会议管理"];
    [self createButtons];
    
    backBtn.hidden = YES;
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
}


- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"审核",@"申请"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    if(self.m_currentIndex == 1)
    {
        AddNewMeetingViewController *add = [[AddNewMeetingViewController alloc]init];
        add.m_delegate = self;
        [self.navigationController pushViewController:add animated:YES];
        return;
    }
    
    [self requestData:YES];
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == btn.tag)
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


#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    if(isRefresh)
    {
        self.m_currentIndex = 0;
    }
    else
    {
        self.m_currentIndex++;
    }

    [HTTP_MANAGER getMeetingManagerList:self.m_currentIndex
                                subject:m_searchBar.text
                         successedBlock:^(NSDictionary *succeedResult) {
                         
                             [self removeWaitingView];
                        
                             if(isRefresh)
                             {
                                 NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                 self.m_arrData = ret[@"result"];
                                 [self reloadDeals];
                             }
                             else
                             {
                                 NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                 NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                 [arr addObjectsFromArray:ret[@"result"]];
                                 self.m_arrData = arr;
                                 [self reloadDeals];
                             }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [self reloadDeals];
        
    }];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
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
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = self.m_currentIndex;
    
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, MAIN_WIDTH/2, 18)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:UIColorFromRGB(0x323232)];
    [tip setFont:[UIFont systemFontOfSize:16]];
    [tip setBackgroundColor:[UIColor clearColor]];
    [tip setText:[info stringWithFilted:@"meetingName"]];
    [cell addSubview:tip];
    
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(tip.frame)+10, MAIN_WIDTH/2, 18)];
    [time setTextAlignment:NSTextAlignmentLeft];
    [time setTextColor:UIColorFromRGB(0x939393)];
    [time setFont:[UIFont systemFontOfSize:16]];
    [time setBackgroundColor:[UIColor clearColor]];
    [time setText:[LocalTimeUtil timeWithTimeIntervalString:[[info stringWithFilted:@"meetingDateStart"]longLongValue]]];
    [cell addSubview:time];
    
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120,15,110, 18)];
    [state setTextAlignment:NSTextAlignmentRight];
    [state setTextColor:UIColorFromRGB(0x939393)];
    [state setFont:[UIFont systemFontOfSize:16]];
    [state setBackgroundColor:[UIColor clearColor]];
    
    NSString *ret = [info stringWithFilted:@"applyStatus"];
    if(ret.integerValue == 0)
    {
        [state setText:@""];
    }
    else if (ret.integerValue == 1)
    {
        [state setText:@"待审核"];
    }
    else if (ret.integerValue == 2)
    {
        [state setText:@"未通过"];
    }
    else if (ret.integerValue == 3)
    {
        [state setText:@"已通过"];
    }
    else
    {
        [state setText:@""];
    }
    [cell addSubview:state];

    UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,CGRectGetMaxY(tip.frame)+10,MAIN_WIDTH/2-10, 18)];
    [address setTextAlignment:NSTextAlignmentRight];
    [address setTextColor:UIColorFromRGB(0x939393)];
    [address setFont:[UIFont systemFontOfSize:16]];
    [address setBackgroundColor:[UIColor clearColor]];
    [address setText:[info stringWithFilted:@"roomAddress"]];
    [cell addSubview:address];

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 74.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    MeetingInfoViewController *infoVc = [[MeetingInfoViewController alloc]initWith:info];
    infoVc.m_delegate = self;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}

@end
