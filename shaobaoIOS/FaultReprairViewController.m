//
//  FaultReprairViewController.m
//  jianye
//
//  Created by points on 2017/7/1.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FaultReprairViewController.h"
#import "AddNewFaultRepriarViewController.h"
#import "AddNewFaultViewController.h"
@interface FaultReprairViewController ()<UITableViewDelegate,UITableViewDataSource,AddNewFaultRepriarViewControllerDelegate>

@end

@implementation FaultReprairViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBackBtn];
    [title setText:@"故障报修"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    [self createButtons];
}

#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}


- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"故障受理",@"故障申报"];
    
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
        
        [HTTP_MANAGER getFaultRepairItemSetting:^(NSDictionary *succeedResult) {
            
            NSDictionary *ret  = [succeedResult[@"DATA"]mutableObjectFromJSONString];
            NSArray *arr = ret[@"result"];
            if(arr.count > 0){
                NSDictionary *app = [arr firstObject];
                [HTTP_MANAGER getFaultRepairFlowEntrySetting:app[@"appId"]
                                              successedBlock:^(NSDictionary *succeedResult) {
                                                  
                                                  ADTGovermentFileInfo *flow = [ADTGovermentFileInfo getInfoFrom:succeedResult];
                                                  
                                                  AddNewFaultRepriarViewController *info = [[AddNewFaultRepriarViewController alloc]init:flow withIndex:self.m_currentIndex];
                                                  info.m_infoDelegate = self;
                                                  info.view.tag = self.m_currentIndex;
                                                  [self.navigationController pushViewController:info animated:YES];
                                                  
                                              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                                  
                                              }];
            }
            
            
            
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            
        }];
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
    [HTTP_MANAGER getFaultRepairList:self.m_page
                             appType:@""
                                 key:@""
                      successedBlock:^(NSDictionary *succeedResult) {
        
                          [self removeWaitingView];
                          if(isRefresh)
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
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
         [self reloadDeals];

    }];

}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, MAIN_WIDTH-100, 20)];
    [_title setTextColor:[UIColor blackColor]];
    [_title setFont:[UIFont systemFontOfSize:18]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:_title];
    
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-100, 8,90, 16)];
    [state setTextColor:[UIColor lightGrayColor]];
    [state setFont:[UIFont systemFontOfSize:14]];
    [state setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:state];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(5,30,200, 16)];
    [time setTextColor:[UIColor lightGrayColor]];
    [time setFont:[UIFont systemFontOfSize:14]];
    [time setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:time];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-100, 30,90, 16)];
    [name setTextColor:[UIColor lightGrayColor]];
    [name setFont:[UIFont systemFontOfSize:14]];
    [name setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:name];
    
    [_title setText:info[@"subject"]];
    [state setText:[info[@"isFlowDone"]integerValue] == 1 ? @"已办结":@"未办结"];
    [time setText:info[@"receivetime"]];
    [name setText:info[@"sendername"]];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:sep];

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    [self showWaitingView];
    [HTTP_MANAGER getFaultRepairInfo:info[@"messageid"]
                        successedBlock:^(NSDictionary *retDic){
                            
                            [self removeWaitingView];
                            ADTGovermentFileInfo *flow = [ADTGovermentFileInfo getInfoFrom:retDic];
                            AddNewFaultRepriarViewController *info = [[AddNewFaultRepriarViewController alloc]init:flow withIndex:self.m_currentIndex];
                            info.m_infoDelegate = self;
                            info.view.tag = self.m_currentIndex;
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
