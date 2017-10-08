//
//  FindCategoryViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindCategoryViewController.h"

#import "FindTableViewCell.h"
#import "FindRequureInfoViewController.h"
#import "FindSenderInfoViewController.h"
@interface FindCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,FindTableViewCellDelegate>
@property(assign)NSInteger m_index;
@end

@implementation FindCategoryViewController

-(id)initWith:(NSInteger)type
{
    self.m_index = type;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.m_index == 0){
        [title setText:@"叫人帮忙"];
    }else if (self.m_index == 1){
        [title setText:@"律师侦探"];
    }else if (self.m_index == 2){
        [title setText:@"保卫保镖"];
    }else if (self.m_index == 3){
        [title setText:@"纠纷债务"];
    }else if (self.m_index == 4){
        [title setText:@"个性需求"];
    }else if (self.m_index == 1){
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{

    [HTTP_MANAGER findGetHelpList:@""
                         userType:[LoginUserUtil shaobaoUserType]
                           status:@""
                          provice:@""
                             city:@""
                           county:@""
                        startTime:@""
                          endTime:@""
                           helpId:@"0"
                         pageSize:@"20"
                   successedBlock:^(NSDictionary *succeedResult) {

                       if([succeedResult[@"ret"]integerValue] == 0){
                           NSMutableArray *arr = [NSMutableArray array];
                           for(NSDictionary *info in  succeedResult[@"data"]){
                               ADTFindItem *item = [ADTFindItem from:info];
                               [arr addObject:item];
                           }
                           self.m_arrData = arr;
                       }
                       [self reloadDeals];


                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                   }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)highOf:(ADTFindItem *)currentData
{
    CGFloat high = 40;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:15] withWidth:(MAIN_WIDTH-(20+70))];
    high+=size.height;
    high+=20;

    if(currentData.m_userType.integerValue == 1){
        high+=20;
    }

    NSInteger row = ceil(currentData.m_arrPics.count/3.0);
    NSInteger sep = 10;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-(70+sep*(cell_num+1)))/3;
    high+= (sep+width)*row;
    high+=50;
    return high;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:[self.m_arrData objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTFindItem *data = [self.m_arrData objectAtIndex:indexPath.row];
    if(data.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue){
        FindSenderInfoViewController *info = [[FindSenderInfoViewController alloc]initWith:data];
        [self.navigationController pushViewController:info animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden1 = @"cell2";
    FindTableViewCell *cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];

    //            FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    //            if(cell == nil){
    //                cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    //            }
    cell.currentData= [self.m_arrData objectAtIndex:indexPath.row];
    cell.m_delegate  = self;
    return cell;
}


#pragma mark - MXCycleScrollViewDelegate
- (void)clickImageIndex:(NSInteger)index {
    NSLog(@"pageViewDidTapIndex %ld",index);


}


#pragma mark - FindTableViewCell

- (void)onDelete:(ADTFindItem *)data
{

}

- (void)onAccept:(ADTFindItem *)data
{
    FindRequureInfoViewController *info = [[FindRequureInfoViewController alloc]initWith:data];
    [self.navigationController pushViewController:info animated:YES];
}
@end

