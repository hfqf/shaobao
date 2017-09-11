//
//  HomeStartViewController.m
//  jianye
//
//  Created by points on 2017/2/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "HomeStartViewController.h"
#import "SideslipViewController.h"
#import "SpeRefreshAndLoadViewController.h"
@interface HomeStartViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger m_row ;
    UIButton *btn;
}
@property(nonatomic,strong)NSArray *m_arrMoudle;
@property(nonatomic,strong)NSString *m_infoContent;
@property(nonatomic,strong)NSMutableDictionary *m_numsDic;
@property(nonatomic,strong)UITableView *table;
@end

@implementation HomeStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    m_row = 3;
    self.m_numsDic = [NSMutableDictionary dictionary];
    UIImageView *naviIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20+(HEIGHT_NAVIGATION-21)/2, 210, 21)];
    [naviIcon setImage:[UIImage imageNamed:@"home_navi_icon"]];
    [navigationBG addSubview:naviIcon];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.table= [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    [self.table reloadData];
    
    self.m_infoContent = @"“智慧建邺移动办公平台”是与区机关协同办公系统对接的移动应用软件，包括公文管理、通知管理、会议管理、督查督办、电子期刊、领导日程及通讯录等功能，实现基于移动终端上的查阅、签批和回复。机关工作人员在移动终端上的操作与PC终端同步，最终实现移动终端和PC终端的操作一致，进一步满足机关工作人基于移动互联网应用的办公需求，全面提升政府管理和服务效能。";
    
    
    self.m_arrMoudle = [LoginUserUtil arrModules];
  
    
}

- (NSArray *)filtedDataSoure{
    return self.m_arrMoudle;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUnreadNums];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define SEP  30


#define WIDHT_BTN  (MAIN_WIDTH-5*SEP)/4

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        NSInteger row  = ceil([self filtedDataSoure].count*1.0/4.0);
        
        return (SEP+WIDHT_BTN+SEP)*row+40;
        
    }
    else{
        
        return MAIN_WIDTH/2.5;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0)
    {
        for(NSDictionary *info in [self filtedDataSoure])
        {
            NSInteger coulmn = [self.m_arrMoudle indexOfObject:info]%4;
            NSInteger row    = [self.m_arrMoudle indexOfObject:info]/4;
            UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            _btn.tag = [[self filtedDataSoure] indexOfObject:info];
            [_btn addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_btn setFrame:CGRectMake(SEP+coulmn*(WIDHT_BTN+SEP), SEP*(row+1)+row*(WIDHT_BTN+SEP), WIDHT_BTN, WIDHT_BTN)];
            [_btn setImage:[UIImage imageNamed:info[@"icon"]] forState:UIControlStateNormal];
            [cell addSubview:_btn];
            
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_btn.frame)-10, CGRectGetMaxY(_btn.frame)+5, WIDHT_BTN+20, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setTextAlignment:NSTextAlignmentCenter];
            [tip setTextColor:UIColorFromRGB(0x646464)];
            [tip setText:info[@"name"]];
            [cell addSubview:tip];
            
            NSNumber *num = [self.m_numsDic objectForKey:info[@"key"]];
            if(num){
                NSInteger _num = [num integerValue];
                if(_num > 0){
                    UILabel *_lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDHT_BTN-15,0, 20, 20)];
                    [_lab setBackgroundColor:[UIColor redColor]];
                    _lab.layer.cornerRadius = 10;
                    [_lab setFont:[UIFont systemFontOfSize:11]];
                    [_lab setTextAlignment:NSTextAlignmentCenter];
                    _lab.clipsToBounds = YES;
                    [_lab setText:[NSString stringWithFormat:@"%lu",_num]];
                    [_lab setTextColor:[UIColor whiteColor]];
                    [_btn addSubview:_lab];
                }

            }
            
            
        }
    }
    else
    {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_WIDTH/2.5)];
        [icon setImage:[UIImage imageNamed:@"layer"]];
        [cell addSubview:icon];
    }
    return cell;
}

- (void)moduleBtnClicked:(UIButton *)_btn
{
    MainTabBarViewController *mainVC  = [[MainTabBarViewController alloc]init];
    mainVC.leftView.currentIndex = _btn.tag+1;
    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark - 打开侧滑栏
- (void)onShowSliderView
{
    [self.m_delegate onShowSliderView];
}

#pragma mark - 获取提醒数字

- (void)getUnreadNums
{
    [HTTP_MANAGER getNumNoticeUnreadNum:^(NSDictionary *succeedResult) {
        
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
        [self.m_numsDic setObject:resultDict[@"result"] forKey:@"tzgl"];
        [self.table reloadData];
        }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    [HTTP_MANAGER getNumMeetingUnreadNum:^(NSDictionary *succeedResult) {
        
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
        [self.m_numsDic setObject:resultDict[@"result"] forKey:@"hygl"];
        [self.table reloadData];
        }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    [HTTP_MANAGER getNumDocumentUnreadNum:^(NSDictionary *succeedResult) {
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
         [self.m_numsDic setObject:resultDict[@"result"] forKey:@"gwgl"];
        [self.table reloadData];
        }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    [HTTP_MANAGER getNumFaultRepairUnreadNum:^(NSDictionary *succeedResult) {
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
         [self.m_numsDic setObject:resultDict[@"result"] forKey:@"gzbx"];
        [self.table reloadData];
        }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    [HTTP_MANAGER getNumDocumentSignUnreadNum:^(NSDictionary *succeedResult) {
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
        [self.m_numsDic setObject:resultDict[@"result"] forKey:@"dwsw"];
        [self.table reloadData];
        }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    [HTTP_MANAGER getNumDocManagerUnreadNum:^(NSDictionary *succeedResult) {
        
        NSDictionary *resultDict=[[succeedResult objectForKey:@"DATA"] objectFromJSONString];
        if([resultDict isKindOfClass:[NSDictionary class]]){
            [self.m_numsDic setObject:resultDict[@"result"] forKey:@"dcdb"];
            [self.table reloadData];
        }
        
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
}


- (void)showBtnClicked
{
    btn.selected = !btn.selected;
    if(btn.selected){
        m_row = 1;
    }else{
        m_row = 3;
    }
    
    [self.table reloadData];
    
}
@end
