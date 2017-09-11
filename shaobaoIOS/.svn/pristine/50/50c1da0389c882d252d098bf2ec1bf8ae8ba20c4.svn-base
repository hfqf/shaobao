//
//  LeaderSchudeInfoControllerViewController.m
//  jianye
//
//  Created by points on 2017/2/22.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LeaderSchudeInfoControllerViewController.h"

@interface LeaderSchudeInfoControllerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(assign) BOOL m_isDay;
@end

@implementation LeaderSchudeInfoControllerViewController

- (id)initWith:(NSDictionary *)info isDay:(BOOL)isDay
{
    self.m_info = info;
    self.m_isDay = isDay;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    if(self.m_isDay)
    {
        [HTTP_MANAGER getLeaderDayScheduleInfo:self.m_info[@"scheduleId"]
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          [self removeWaitingView];
                          
                          NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                          self.m_infoShow = ret[@"result"];
                          
                          [self reloadDeals];
                          
                      } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                          
                          [self removeWaitingView];
                          [self reloadDeals];
                          
                      }];
    }
    else
    {
        [HTTP_MANAGER getLeaderWeekScheduleInfo:self.m_info[@"scheduleId"]
                                 successedBlock:^(NSDictionary *succeedResult) {
                                     
                                     [self removeWaitingView];
                                     
                                     NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                     self.m_infoShow = ret[@"result"];
                                     
                                     [self reloadDeals];
                                     
                                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                     
                                     [self removeWaitingView];
                                     [self reloadDeals];
                                     
                                 }];
    }

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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = self.m_infoShow;
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,15,80, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont systemFontOfSize:14]];
    [tip setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip];
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
    [content setTextAlignment:NSTextAlignmentLeft];
    [content setTextColor:[UIColor blackColor]];
    [content setFont:[UIFont systemFontOfSize:14]];
    [content setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:content];
    if(indexPath.row == 0){
        [tip setText:@"日期:"];
        [content setText:info[@"agentDate"]];
    }
    else if (indexPath.row == 1){
        [tip setText:@"开始时间:"];
        [content setText:info[@"startTime"]];
    }
    else if (indexPath.row == 2){
        [tip setText:@"结束时间:"];
        [content setText:info[@"endTime"]];
    }
    else if (indexPath.row == 3){
        [tip setText:@"地点:"];
        [content setText:info[@"address"]];
    }
    else if (indexPath.row == 4){
        [tip setText:@"内容:"];
         [content setText:info[@"content"]];
    }
    else if (indexPath.row == 5){
        [tip setText:@"参会人员:"];
        [content setText:info[@"participant"]];
    }
    else{
        [tip setText:@"主办单位:"];
        [content setText:info[@"hostUnitName"]];
    }

        
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}



@end

