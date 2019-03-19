//
//  InAndOutMoneyViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/14.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "InAndOutMoneyViewController.h"

@interface InAndOutMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong) NSString *m_netMoney;
@end

@implementation InAndOutMoneyViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        [self.tableView setFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
        [self.view bringSubviewToFront:navigationBG];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [navigationBG setBackgroundColor:[UIColor clearColor]];
    [navigationBG setImage:[UIImage imageNamed:@""]];
    [title setText:@"收支酷"];
    [title setTextColor:[UIColor whiteColor]];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(MAIN_WIDTH-100, HEIGHT_STATUSBAR, 90, 44)];
    [navigationBG addSubview:btn];
    [btn setTitle:@"交易记录" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];

    [self.view bringSubviewToFront:navigationBG];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)rightBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"TradeHistoryViewController") alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getCash:^(NSDictionary *succeedResult) {

        if([succeedResult[@"ret"]integerValue]==0){
            self.m_netMoney = succeedResult[@"data"][@"netMoney"];
            //            self.m_netMoney =@"1000";
        }

        [self reloadDeals];
        self.tableView.tableHeaderView = [self headrView];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self reloadDeals];
        self.tableView.tableHeaderView = [self headrView];
    }];
}

- (UIView *)headrView
{
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200+HEIGHT_STATUSBAR)];
    [bg setImage:[UIImage imageNamed:@"set_ye_bg"]];
    bg.userInteractionEnabled = YES;

    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+HEIGHT_NAVIGATION, 90, 20)];
    [tip1 setText:@"网钞币"];
    [tip1 setFont:[UIFont systemFontOfSize:18]];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip1];

    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50+HEIGHT_NAVIGATION, MAIN_WIDTH-20, 50)];
    [tip2 setText:[NSString stringWithFormat:@"%.2fWCB",self.m_netMoney.floatValue]];
    [tip2 setFont:[UIFont boldSystemFontOfSize:50]];
    [tip2 setTextAlignment:NSTextAlignmentLeft];
    [tip2 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip2];

    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 110+HEIGHT_NAVIGATION, MAIN_WIDTH-20, 20)];
    [tip3 setText:@"备注: 1网钞币等于1元人民币"];
    [tip3 setFont:[UIFont systemFontOfSize:18]];
    [tip3 setTextAlignment:NSTextAlignmentLeft];
    [tip3 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip3];

    return bg;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
    if(indexPath.row == 0){
        [img setImage:[UIImage imageNamed:@"set_outcashe"]];

    }else if (indexPath.row == 1){
        [img setImage:[UIImage imageNamed:@"set_zhuanz"]];

    }else{
        [img setImage:[UIImage imageNamed:@"set_szk"]];
    }
    [cell addSubview:img];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *tit = [[UILabel alloc]initWithFrame:CGRectMake(50,25,60, 20)];
    [tit setTextAlignment:NSTextAlignmentLeft];
    [tit setFont:[UIFont systemFontOfSize:16]];
    [tit setTextColor:UIColorFromRGB(0x333333)];
    [cell addSubview:tit];

    if(indexPath.row == 0){
        [tit setText:@"提取"];
    }else if (indexPath.row == 1){
        [tit setText:@"转赠"];
    }else{
        [tit setText:@"充值"];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"余额提取需要收取3%的手续费(金融机构支付宝微信平台的费用)" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 1;
        [alert show];
    }else if(indexPath.row == 1) {
        [self.navigationController pushViewController:[[NSClassFromString(@"TransferViewController") alloc]init] animated:YES];
    }else{
         [self.navigationController pushViewController:[[NSClassFromString(@"SaveMoneyViewController") alloc]init] animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
          [self.navigationController pushViewController:[[NSClassFromString(@"OutCashViewController") alloc]init] animated:YES];
    }
}
@end
