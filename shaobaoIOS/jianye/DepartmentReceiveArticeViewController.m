//
//  DepartmentReceiveArticeViewController.m
//  jianye
//
//  Created by points on 2017/6/15.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "DepartmentReceiveArticeViewController.h"
#import "DepartmentReceiveArticeInfoViewController.h"
#import "TodoInfoViewController.h"
@interface DepartmentReceiveArticeViewController ()<UITableViewDataSource,UITableViewDelegate,TodoInfoViewControllerDelegate>

@end

@implementation DepartmentReceiveArticeViewController
-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"请输入查询关键字"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
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
    [self removeBackBtn];
    [title setText:@"单位收文"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    [self createButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"待收",@"已收"];
    
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
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navigationBG.frame)+40, MAIN_WIDTH, 1)];
    [line setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [self.view addSubview:line];
    
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
    
    [HTTP_MANAGER getDepartmentReceiveArticles:[NSString stringWithFormat:@"%lu",self.m_page]
                                        stauts:self.m_currentIndex == 0
                                           key:m_searchBar.text
                                successedBlock:^(NSDictionary *succeedResult) {
                     [self removeWaitingView];
                     if(self.m_isRefresh)
                     {
                         NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                         self.m_arrData = ret[@"result"];
                     }
                     else
                     {
                         NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
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
    return 50;
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
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, MAIN_WIDTH-20, 18)];
    [_title setText:info[@"subject"]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setTextColor:UIColorFromRGB(0x323232)];
    [_title setFont:[UIFont systemFontOfSize:16]];
    [cell addSubview:_title];
    
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, MAIN_WIDTH/2-10, 18)];
    [desc setText:info[@"sendDeptName"]];
    [desc setTextAlignment:NSTextAlignmentLeft];
    [desc setTextColor:UIColorFromRGB(0x8a8a8a)];
    [desc setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:desc];
    
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 30, MAIN_WIDTH/2, 18)];
    [time setText:info[@"sendDate"]];
    [time setTextAlignment:NSTextAlignmentRight];
    [time setTextColor:UIColorFromRGB(0x8a8a8a)];
    [time setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:time];
    

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    DepartmentReceiveArticeInfoViewController *infoVc = [[DepartmentReceiveArticeInfoViewController alloc]initWith:info with:self.m_currentIndex == 1];
    infoVc.m_delegate = self;
    [self.navigationController pushViewController:infoVc animated:YES];
}

#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}

- (void)onUpdateInfo:(NSString *)docId
{
     [self requestData:YES];
    [self showWaitingView];
    [HTTP_MANAGER getGovermentFileInfo:[NSString stringWithFormat:@"%ld",[docId integerValue]]
                        successedBlock:^(NSDictionary *retDic){
                            
                            [self removeWaitingView];
                            TodoInfoViewController *info = [[TodoInfoViewController alloc]init:[ADTGovermentFileInfo getInfoFrom:retDic] withIndex:self.m_currentIndex];
                            info.view.tag = self.m_currentIndex;
                            info.m_infoDelegate = self;
                            [self.navigationController pushViewController:info animated:YES];
                            
                        } failedBolck:FAILED_BLOCK{
                            
                            [self removeWaitingView];
                            
                        }];
}

- (void)onCommitCompleted
{
    [self requestData:YES];
}

@end
