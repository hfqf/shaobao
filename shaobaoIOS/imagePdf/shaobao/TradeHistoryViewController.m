//
//  TradeHistoryViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/14.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "TradeHistoryViewController.h"

#import "FindTableViewCell.h"
#import "FindServiceInfoViewController.h"
#import "FindSenderInfoViewController.h"
#import "FindRequureInfoViewController.h"
@interface TradeHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TradeHistoryViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"交易记录"];
}

- (void)requestData:(BOOL)isRefresh
{
    NSDictionary *info = [self.m_arrData lastObject];
    NSString *helpId = isRefresh ? @"0" : info[@"id"];

       [HTTP_MANAGER myRecord:helpId
               successedBlock:^(NSDictionary *succeedResult) {

                   if([succeedResult[@"ret"]integerValue] == 0){
                       NSMutableArray *arr = isRefresh ? [NSMutableArray array] : [NSMutableArray arrayWithArray:self.m_arrData];
                       [arr addObjectsFromArray:succeedResult[@"data"]];

                       self.m_arrData = arr;
                   }
                   [self reloadDeals];

               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                   [self reloadDeals];

               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)high:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:UIColorFromRGB(0xFAFAFA)];

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15,120,20)];
    [_title setTextColor:UIColorFromRGB(0x333333)];
    [_title setFont:[UIFont systemFontOfSize:15]];
//    NSInteger type =  [info[@"type"]integerValue];
//    if(type == 1){
//        [_title setText:[NSString stringWithFormat:@"%@",@"提取"]];
//
//    }else if(type == 2){
//        [_title setText:[NSString stringWithFormat:@"%@",@"转赠"]];
//
//    }else if(type == 3){
//        [_title setText:[NSString stringWithFormat:@"%@",@"充值"]];
//
//    }else if(type == 4){
//        [_title setText:[NSString stringWithFormat:@"%@",@"提现拒绝转入"]];
//
//    }else if(type == 5){
//        [_title setText:[NSString stringWithFormat:@"%@",@"接单完成转入"]];
//
//    }else if(type == 6){
//        [_title setText:[NSString stringWithFormat:@"%@",@"支付抵扣"]];
//
//    }
    [_title setText:info[@"typeName"]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:_title];


    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10,40,200,20)];
    [time setTextColor:UIColorFromRGB(0x9c9c9d)];
    [time setFont:[UIFont systemFontOfSize:13]];
    [time setText:info[@"createTime"]];
    [time setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:time];

    UILabel *cellMoney = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-110,15,100,20)];
    [cellMoney setTextColor:UIColorFromRGB(0x333333)];
    [cellMoney setFont:[UIFont systemFontOfSize:15]];
    [cellMoney setText:[NSString stringWithFormat:@"%.2f",[info[@"changeMoney"]floatValue]]];
    [cellMoney setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:cellMoney];

    UILabel *totalMoney = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-110,40,100,20)];
    [totalMoney setTextColor:UIColorFromRGB(0x9c9c9d)];
    [totalMoney setFont:[UIFont systemFontOfSize:13]];
    [totalMoney setText:[NSString stringWithFormat:@"¥%@",info[@"remainMoney"]]];
    [totalMoney setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:totalMoney];


    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [cell addSubview:sep];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
//
//    [HTTP_MANAGER findDeleteOne:info[@"id"]
//                 successedBlock:^(NSDictionary *succeedResult) {
//                     if([succeedResult[@"ret"]integerValue]==0){
//                         [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
//                         [self requestData:YES];
//                     }else{
//                         [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
//                     }
//
//                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//
//                 }];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end


