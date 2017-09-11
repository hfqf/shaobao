//
//  SelectContactViewController.m
//  officeMobile
//
//  Created by Points on 15-3-22.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SelectContactViewController.h"
#import "AdtContacterInfo.h"
@interface SelectContactViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectContactViewController


- (id)initWith:(enum_contact_type)type
{
    self.m_currentType = type;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"选择联系人"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setFrame:CGRectMake(MAIN_WIDTH-50,DISTANCE_TOP, 50, HEIGHT_NAVIGATION)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [navigationBG addSubview:doneBtn];
}

- (void)doneBtnClicked
{
    NSMutableArray *arr = [NSMutableArray array];
    for(AdtContacterInfo *info in self.m_arrData)
    {
        if(info.m_isSelected)
        {
            [arr addObject:info];
        }
    }
    [self.m_delegate onSelectContact:arr type:self.m_currentType];
    [self backBtnClicked];
}



- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getContact:m_searchBar.text
                       depId:@""
              successedBlock:^(NSDictionary *retDic){
        NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
        self.m_arrData = ret[@"result"];
        
        NSMutableArray *arrTemp = [NSMutableArray array];
        NSArray *arr = ret[@"result"];
        for(NSDictionary *dic in arr)
        {
            AdtContacterInfo *info = [[AdtContacterInfo alloc]init];
            info.m_isSelected = NO;
            info.m_loginName = [dic stringWithFilted:@"loginName"];
            info.m_mobile = [NSString stringWithFormat:@"%lld",[[dic stringWithFilted:@"mobile"]longLongValue]];
            info.m_userId = [NSString stringWithFormat:@"%lld",[[dic stringWithFilted:@"userId"]longLongValue]];
            info.m_userName = [dic stringWithFilted:@"userName"];
            [arrTemp addObject:info];
        }
        self.m_arrData = arrTemp;
        
        [self reloadDeals];
        
    } failedBolck:FAILED_BLOCK{
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    AdtContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    [cell.textLabel setText:info.m_userName];
    [cell.textLabel  setTextColor:info.m_isSelected ? KEY_COMMON_CORLOR : [UIColor blackColor]];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdtContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    info.m_isSelected = !info.m_isSelected;
    [self reloadDeals];
}

@end
