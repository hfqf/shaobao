//
//  TodoViewController.m
//  officeMobile
//
//  Created by Points on 15-3-5.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "TodoViewController.h"
#import "TodoTableViewCell.h"
#import "PublicFileViewController.h"

#import "TodoInfoViewController.h"

@interface TodoViewController ()<UITableViewDataSource,UITableViewDelegate,TodoInfoViewControllerDelegate>


@end

@implementation TodoViewController
@synthesize fileNameStr;
@synthesize isEnableAnnotation;
@synthesize isQianming;
@synthesize isCanAnnotation;
@synthesize signatureNameAp;
@synthesize authorNameAp;
@synthesize effectDayStr;
@synthesize isNotTake;
@synthesize isMeettingFile;
@synthesize isHaveCamera;
@synthesize isCanChangeAuthor;
@synthesize isCountersigned;
@synthesize isPushCamera;
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBackBtn];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10, 4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    [title setText:@"公文管理"];
    
    [self createButtons];
    
}

- (void)PDFBtnClicked
{
    
    isEnableAnnotation = NO;
    isQianming = NO;
    isCanAnnotation = YES;
    isNotTake = YES;
    isHaveCamera = YES;
    isCanChangeAuthor = YES;
    isCountersigned = YES;
    isPushCamera = YES;
    isMeettingFile = YES;
    
    
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"待批文件",@"待阅文件",@"已批文件",@"已阅文件"];
    
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
    [self showWaitingView];
    self.m_isRefresh = isRefresh;
    if(isRefresh)
    {
        self.m_arrData = nil;
    }
    
    if(self.m_currentIndex == 0)
    {
        [HTTP_MANAGER getTodoFile:@"10,20"
                              key:m_searchBar.text == nil ? @"" : m_searchBar.text
                       actorClass:@"0,3"
                       startIndex:[NSString stringWithFormat:@"%ld",(unsigned long)self.m_arrData.count]
                   successedBlock:^(NSDictionary *retDic){
                       
                       [self processData:retDic];
                       
                   } failedBolck:FAILED_BLOCK{
                       [self reloadDeals];
                   }];
    }
    else if(self.m_currentIndex == 1)
    {
        [HTTP_MANAGER getTodoFile:@"10,20"
                              key:m_searchBar.text == nil ? @"" : m_searchBar.text
                       actorClass:@"1"
                       startIndex:[NSString stringWithFormat:@"%ld",(unsigned long)self.m_arrData.count]
                   successedBlock:^(NSDictionary *retDic){
                       
                     [self processData:retDic];
                       
                   } failedBolck:FAILED_BLOCK{
                       [self reloadDeals];
                   }];
    }
    else if(self.m_currentIndex == 2)
    {
        [HTTP_MANAGER getDoneFile:@""
                              key:m_searchBar.text == nil ? @"" : m_searchBar.text
                       actorClass:@"0"
                       startIndex:[NSString stringWithFormat:@"%ld",(unsigned long)self.m_arrData.count]
                   successedBlock:^(NSDictionary *retDic){
                       
                      [self processData:retDic];
                       
                   } failedBolck:FAILED_BLOCK{
                        [self reloadDeals];
                   }];
    }
    else
    {
        [HTTP_MANAGER getDoneFile:@""
                              key:m_searchBar.text == nil ? @"" : m_searchBar.text
                       actorClass:@"1"
                       startIndex:[NSString stringWithFormat:@"%ld",(unsigned long)self.m_arrData.count]
                   successedBlock:^(NSDictionary *retDic){
                       
                      [self processData:retDic];
                       
                   } failedBolck:FAILED_BLOCK{
                       
                        [self reloadDeals];
                   }];
    }
}

- (void)processData:(NSDictionary *)retDic
{
    if(self.m_isRefresh)
    {
        self.m_arrData = [retDic[@"DATA"]mutableObjectFromJSONString];
    }
    else
    {
        NSArray *arrRet = [retDic[@"DATA"]mutableObjectFromJSONString];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
        [arr addObjectsFromArray:arrRet];
        self.m_arrData = arr;
    }
    [self reloadDeals];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    TodoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[TodoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tag = self.m_currentIndex;
    cell.currentDic = [self.m_arrData objectAtIndex:indexPath.row];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.m_arrData objectAtIndex:indexPath.row];
    if(self.m_currentIndex == 0 || self.m_currentIndex == 1)
    {
        TodoInfoViewController *info = [[TodoInfoViewController alloc]init:dic withIndex:self.m_currentIndex];
        info.m_infoDelegate = self;
        info.view.tag = self.m_currentIndex;
        [self.navigationController pushViewController:info animated:YES];
    }
    else
    {
        [self showWaitingView];
        [HTTP_MANAGER getGovermentFileInfo:dic[@"flowId"]
                            successedBlock:^(NSDictionary *retDic){
                            
                                [self removeWaitingView];
                                TodoInfoViewController *info = [[TodoInfoViewController alloc]init:[ADTGovermentFileInfo getInfoFrom:retDic] withIndex:self.m_currentIndex];
                                info.m_infoDelegate = self;
                                info.view.tag = self.m_currentIndex;
                                [self.navigationController pushViewController:info animated:YES];
                            
                            } failedBolck:FAILED_BLOCK{
                            
                                [self removeWaitingView];
                                
                            }];
    }
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

#pragma mark - TodoInfoViewControllerDelegate

- (void)onCommitCompleted
{
    [self requestData:YES];
}

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}
@end
