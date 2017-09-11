//
//  ObserberInfoViewController.m
//  jianye
//
//  Created by points on 2017/2/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ObserberInfoViewController.h"

@interface ObserberInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ObserberInfoViewController

- (id)initWith:(NSDictionary *)info
{
    self.m_info = info;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"督办件"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getObserverInfo:self.m_info[@"id"]
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


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHigh:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = self.m_infoShow;
    
    if(indexPath.row == 0 ||
       indexPath.row == 1 ||
       indexPath.row == 2 ||
       indexPath.row == 3 )
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15,120, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:tip];
        
        UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame),15,MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+10)-10, 18)];
        [state setTextAlignment:NSTextAlignmentLeft];
        [state setTextColor:UIColorFromRGB(0x323232)];
        [state setFont:[UIFont systemFontOfSize:14]];
        [state setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:state];
        
        if(indexPath.row == 0)
        {
            [tip setText:@"督办件来源:"];
            [state setText:[info stringWithFilted:@"documentSubject"]];
        }
        else if (indexPath.row == 1)
        {
            [tip setText:@"编号:"];
            [state setText:[info stringWithFilted:@"documentNo"]];

        }
        else if (indexPath.row == 2)
        {
            [tip setText:@"登记时间:"];
            [state setText:[[LocalTimeUtil timeWithTimeIntervalString:[[info stringWithFilted:@"createDate"]longLongValue]]substringToIndex:10]];
        }
        else
        {
            [tip setText:@"办理时间:"];
            [state setText:[[LocalTimeUtil timeWithTimeIntervalString:[[info stringWithFilted:@"finishTime"]longLongValue]]substringToIndex:10]];
        }

    }
    else if (indexPath.row == 4)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,([self getHigh:indexPath]-18)/2,80, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:@"拟办:"];
        [cell addSubview:tip];
        
        
        UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame),10,MAIN_WIDTH-100, [self getHigh:indexPath]-20)];
        [state setTextAlignment:NSTextAlignmentLeft];
        [state setTextColor:UIColorFromRGB(0x323232)];
        [state setFont:[UIFont systemFontOfSize:14]];
        state.numberOfLines  = 0;
        [state setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:state];
        
        [state setText:self.m_infoShow[@"opinion1"]];
        
    }
    else if (indexPath.row == 5)
    {
        
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,([self getHigh:indexPath]-18)/2,60, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:@"批示:"];
        [cell addSubview:tip];
        
        int lastHigh = 10;
        NSArray *arr = [self.m_infoShow[@"leader"]objectFromJSONString];
        if(arr.count == 0)
        {
            lastHigh = 50;
        }
        else
        {
            for(NSDictionary *leaderInfo in arr){
                NSString *   str = [NSString stringWithFormat:@"%@ %@ %@",leaderInfo[@"name"],leaderInfo[@"time"],leaderInfo[@"opinion"]];
                CGSize size = [FontSizeUtil sizeOfString:str withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-80];
                
                
                UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame),lastHigh,MAIN_WIDTH-80, size.height)];
                [state setTextAlignment:NSTextAlignmentLeft];
                [state setTextColor:UIColorFromRGB(0x323232)];
                [state setFont:[UIFont systemFontOfSize:14]];
                state.numberOfLines  = 0;
                [state setText:str];
                [state setBackgroundColor:[UIColor clearColor]];
                [cell addSubview:state];
                
                lastHigh += ( (size.height < 20 ? 20 : size.height));
            }
        }
    
    }
    else if (indexPath.row == 6)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,5,80, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:@"内容:"];
        [cell addSubview:tip];
        
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(10,30,MAIN_WIDTH-20,[self getHigh:indexPath]-35)];
        desc.numberOfLines =0;
        [desc setTextAlignment:NSTextAlignmentLeft];
        [desc setTextColor:UIColorFromRGB(0x323232)];
        [desc setFont:[UIFont systemFontOfSize:14]];
        [desc setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
        [desc setText:info[@"content"]];
        desc.layer.cornerRadius = 5;
        desc.layer.borderWidth = 0.5;
        desc.layer.borderColor = UIColorFromRGB(0xd5d5d5).CGColor;
        [cell addSubview:desc];
    }
    else
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,([self getHigh:indexPath]-18)/2,60, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:@"备注:"];
        [cell addSubview:tip];
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(80,10,MAIN_WIDTH-100,[self getHigh:indexPath]-20)];
        desc.numberOfLines = 0;
        [desc setTextAlignment:NSTextAlignmentLeft];
        [desc setTextColor:UIColorFromRGB(0x323232)];
        [desc setFont:[UIFont systemFontOfSize:14]];
        [desc setText:info[@"remark"]];
        [cell addSubview:desc];
        
    }
    
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self getHigh:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}


- (NSInteger)getHigh:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 ){
        return 50;
    }
    else if(indexPath.row  == 4){
        
        CGSize size = [FontSizeUtil sizeOfString:self.m_infoShow[@"opinion1"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-100];
        return (size.height < 30 ? 30 : size.height)+30;
    }
    else if(indexPath.row  == 5){
        
        int high = 10;
        NSArray *arr = [self.m_infoShow[@"leader"]objectFromJSONString];
        if(arr.count == 0)
        {
            high = 50;
        }
        else{
            for(NSDictionary *leaderInfo in arr){
                NSString *   str = [NSString stringWithFormat:@"%@ %@ %@",leaderInfo[@"name"],leaderInfo[@"time"],leaderInfo[@"opinion"]];
                CGSize size = [FontSizeUtil sizeOfString:str withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-80];
                high += ( (size.height < 20 ? 20 : size.height));
            }
        }
        return high;
    }
    else if(indexPath.row  == 6){
        CGSize size = [FontSizeUtil sizeOfString:self.m_infoShow[@"content"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-20];
        return (size.height < 60 ? 60 : size.height)+35;
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:self.m_infoShow[@"remark"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-100];
        return (size.height < 30 ? 30 : size.height)+30;
    }
    return 0;
}




@end
