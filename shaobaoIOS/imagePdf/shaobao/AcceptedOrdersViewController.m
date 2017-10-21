//
//  AcceptedOrdersViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/14.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AcceptedOrdersViewController.h"
#import "FindTableViewCell.h"
#import "FindServiceInfoViewController.h"
#import "FindSenderInfoViewController.h"
#import "FindRequureInfoViewController.h"
@interface AcceptedOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,FindTableViewCellDelegate>

@end

@implementation AcceptedOrdersViewController
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
    [title setText:@"承接的订单"];
}

- (void)requestData:(BOOL)isRefresh
{
    NSDictionary *info = [self.m_arrData lastObject];
    NSString *helpId = isRefresh ? @"0" : info[@"id"];

    [HTTP_MANAGER findGetMyAcceptHelpList:helpId
                               pageSize:@"20"
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
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    CGSize size = [FontSizeUtil sizeOfString:info[@"content"] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-120];
    return size.height+30;
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
    CGSize size = [FontSizeUtil sizeOfString:info[@"content"] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-120];
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15,size.width, size.height)];
    _title.numberOfLines = 0;
    [_title setTextColor:UIColorFromRGB(0x333333)];
    [_title setFont:[UIFont systemFontOfSize:15]];
    [_title setText:info[@"content"]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:_title];

    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-110,([self high:indexPath]-20)/2,100,20)];
    [time setTextColor:UIColorFromRGB(0x333333)];
    [time setFont:[UIFont systemFontOfSize:15]];
    [time setText:[info[@"createTime"]substringToIndex:10]];
    [time setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:time];

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
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    ADTFindItem *data = [ADTFindItem from:info];

    if(data.m_userType.integerValue == 2){
        FindServiceInfoViewController *vc = [[FindServiceInfoViewController alloc]initWith:data];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if(data.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue){
            FindSenderInfoViewController *info = [[FindSenderInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }else{
            FindRequureInfoViewController *info = [[FindRequureInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }
    }
}
@end

