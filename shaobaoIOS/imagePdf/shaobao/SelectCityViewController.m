//
//  SelectCityViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectAreaViewController.h"
#import "SendHelpViewController.h"
#import "SendServiceeViewController.h"
@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)NSInteger m_index;
@end

@implementation SelectCityViewController
- (id)initWith:(id<BaseViewControllerDelegate>)delegate withParentInfo:(NSDictionary *)pInfo
{
    self.m_delegate = delegate;
    self.m_info = pInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"选择城市"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(MAIN_WIDTH-50, HEIGHT_STATUSBAR, 40, 44)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:btn];
    [btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmBtnClicked
{
    NSDictionary *info = [self.m_arrData objectAtIndex:self.m_index];
    [self.m_delegate onSelectedProvice:self.m_info withCity:info withArea:nil];
    NSArray *arr = self.navigationController.viewControllers;
    for(UIViewController *vc in arr){
        if([vc isMemberOfClass: [SendHelpViewController  class]] ||
           [vc isMemberOfClass: [SendServiceeViewController  class]] ){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER findQueryArea:self.m_info[@"id"]
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(MAIN_WIDTH-50, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:self.m_index == indexPath.row ?@"area_select_on" : @"area_select_un"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [cell addSubview:btn];
    return cell;
}

- (void)btnClicked:(UIButton *)btn
{
    self.m_index = btn.tag;
    [self reloadDeals];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    SelectAreaViewController *select = [[SelectAreaViewController alloc]initWith:self withParentInfo:info];
    BaseViewController *delegate = (BaseViewController *)self.m_delegate;
    if([delegate.m_delegate isKindOfClass:NSClassFromString(@"FindViewController")]){
        [self.m_delegate onSelectedProvice:self.m_info withCity:info withArea:nil];
    }
    [self.navigationController pushViewController:select animated:YES];
}

- (void)onSelectedProvice:(NSDictionary *)pInfo withCity:(NSDictionary *)cInfo withArea:(NSDictionary *)aInfo
{
    [self.m_delegate onSelectedProvice:self.m_info withCity:cInfo withArea:aInfo];
}

@end

