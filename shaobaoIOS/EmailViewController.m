//
//  EmailViewController.m
//  officeMobile
//
//  Created by Points on 15-3-5.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "EmailViewController.h"
#import "EmailTableViewCell.h"
#import "EmailDetailViewController.h"
#import "SendEmailViewController.h"
@interface EmailViewController ()<UITableViewDataSource,UITableViewDelegate,SendEmailViewControllerDelegate>

@end

@implementation EmailViewController

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
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBackBtn];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    [title setText:@"邮件"];
    [self createButtons];
}

- (void)createButtons
{
    self.m_currentIndex = 30;
    self.m_arrCategory = @[@"收件箱",@"发件箱",@"草稿箱",@"已删除",@"写邮件"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
        {
            btn.tag = 30;
        }
        else if (i == 1)
        {
           btn.tag = 20;
        }
        else if (i==2)
        {
            btn.tag = 10;
        }
        else if (i==3)
        {
            btn.tag = 40;
        }
        else
        {
            btn.tag = 4;

        }
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
    
    if(self.m_currentIndex == 4)
    {
        SendEmailViewController *send = [[SendEmailViewController alloc]initWithInfo:nil WithType:email_send];
        send.m_sendDelegate = self;
        [self.navigationController pushViewController:send animated:YES];
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
        [m_tipView setFrame:CGRectMake([self.m_arrBtn indexOfObject:btn]*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
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
    
    if(self.m_currentIndex == 4)
    {
        self.m_currentIndex = 10;
    }
    
    [HTTP_MANAGER getEmailWithType:self.m_currentIndex
                               key:m_searchBar.text
                            sender:@""
                        startIndex:[NSString stringWithFormat:@"%ld",(unsigned long)self.m_arrData.count]
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
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentDic = [self.m_arrData objectAtIndex:indexPath.row];
    NSString *sender = nil;
    if (self.m_currentIndex == 30 || self.m_currentIndex == 40)
    {
        sender =   currentDic[@"senderName"];
    }
    else
    {
       sender = currentDic[@"mainNames"];
    }
    CGSize size = [FontSizeUtil sizeOfString:sender withFont:[UIFont systemFontOfSize:12] withWidth:MAIN_WIDTH/2-10];
    if(size.height> 30)
    {
        size = CGSizeMake(size.width, 30);
    }
    return    40+size.height+10;
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
    EmailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[EmailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tag = self.m_currentIndex;
    cell.currentDic = [self.m_arrData objectAtIndex:indexPath.row];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 10)
    {
        NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
        
        [self showWaitingView];
        [HTTP_MANAGER GetEmialInfo:info[@"mailId"]
                         isSaveBox:YES
                             msgId:@""
                    successedBlock:^(NSDictionary *retDic){
                        
                        [self removeWaitingView];
                        NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
                        SendEmailViewController *send = [[SendEmailViewController alloc]initWithInfo:ret   WithType:email_send isSaveBox:YES];
                        send.m_sendDelegate= self;
                        [self.navigationController pushViewController:send animated:YES];
                        
                    } failedBolck:FAILED_BLOCK{
                        
                        [self removeWaitingView];
                        [PubllicMaskViewHelper showTipViewWith:@"获取邮件详情失败" inSuperView:self.view withDuration:1];
                        
                    }];

        return;
    }
    
    
    EmailDetailViewController *info = [[EmailDetailViewController alloc]initWith:[self.m_arrData objectAtIndex:indexPath.row]  mailType:self.m_currentIndex];
    info.m_delegate = self;
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

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}

#pragma mark - SendEmailViewControllerDelegate
- (void)onSendEmailSucceed
{
    self.m_currentIndex = 20;
    
    [self requestData:YES];
    
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag ==self.m_currentIndex)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(1*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}

@end
