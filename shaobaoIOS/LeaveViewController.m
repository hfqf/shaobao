//
//  LeaveViewController.m
//  officeMobile
//
//  Created by Points on 15-3-5.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "LeaveViewController.h"
#import "MessageTableViewCell.h"
#import "NewAbsenceViewController.h"
@interface LeaveViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeaveViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setDelegate:self];
        [m_searchBar setPlaceholder:@"请输入查询关键字"];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.m_delegate onShowTabbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeBackBtn];
    [title setText:@"请假"];
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
    self.m_arrCategory = @[@"待办申请",@"已办申请",@"请假申请"];
    
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
    
    if(self.m_currentIndex == 2)
    {
        NewAbsenceViewController *new = [[NewAbsenceViewController alloc]initWithInfo:nil withType:self.m_currentIndex];
        new.m_delegate = self;
        [self presentViewController:new animated:YES completion:NULL];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK -

- (void)requestData:(BOOL)isRefresh
{
    if(isRefresh)
    {
        self.m_arrData = nil;
    }
    self.m_isRefresh = isRefresh;
    [HTTP_MANAGER getAbsenceList:m_searchBar.text
                           index:[NSNumber numberWithInteger:self.m_arrData.count]
                           statu:self.m_currentIndex == 0
               successedBlock:^(NSDictionary *retDic){
                   
                   [self processData:retDic];
                   
               } failedBolck:FAILED_BLOCK{
                   
                   [self reloadDeals];
               }];
}

- (void)processData:(NSDictionary *)retDic
{
    if(self.m_isRefresh)
    {
        NSArray *arrRet = [retDic[@"DATA"] mutableObjectFromJSONString];
        self.m_arrData = arrRet;
    }
    else
    {
        NSArray *arrRet = [retDic[@"DATA"] mutableObjectFromJSONString];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
        [arr addObjectsFromArray:arrRet];
        self.m_arrData = arr;
    }
    [self reloadDeals];
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
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tag = 3;
    cell.currentDic = [self.m_arrData objectAtIndex:indexPath.row];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewAbsenceViewController *info = [[NewAbsenceViewController alloc]initWithInfo:[self.m_arrData objectAtIndex:indexPath.row] withType:self.m_currentIndex];
    info.m_delegate = self;
    
    
    //[self.m_delegate onHideTabbar];
    [self presentViewController:info animated:YES completion:NULL];//
    
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

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}

- (void)onNeedRefreshTableView:(NSInteger)index
{
    self.m_currentIndex = index;
    
    [self requestData:YES];
    UIButton *btn = [self.m_arrBtn objectAtIndex:index];
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
@end
