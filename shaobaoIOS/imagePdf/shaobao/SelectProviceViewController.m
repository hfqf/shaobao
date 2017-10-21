//
//  SelectProviceViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SelectProviceViewController.h"
#import "SelectCityViewController.h"
@interface SelectProviceViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SelectProviceViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"选择省份"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER findQueryArea:@"1"
                 successedBlock:^(NSDictionary *succeedResult) {
                     if([succeedResult[@"ret"]integerValue] == 0){
                         self.m_arrData = succeedResult[@"data"];
                         [self reloadDeals];
                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                     [self reloadDeals];
                 }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    [cell.textLabel setText:info[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    SelectCityViewController *select = [[SelectCityViewController alloc]initWith:self.m_delegate withParentInfo:info];
    if([self.m_delegate isKindOfClass:NSClassFromString(@"FindViewController")]){
        [self.m_delegate onSelectedProvice:info withCity:nil withArea:nil];
    }
    [self.navigationController pushViewController:select animated:YES];
}

@end
