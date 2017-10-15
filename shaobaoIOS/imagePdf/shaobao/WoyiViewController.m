//
//  WoyiViewController.m
//  shaobao
//
//  Created by points on 2017/9/16.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "WoyiViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewViewController.h"
@interface WoyiViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WoyiViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @[
                               @{@"name":@"收支酷",@"icon":@"set_szk"},
                               @{@"name":@"瘦枝酷",@"icon":@"set_szk2"},
                               @{@"name":@"身份认证",@"icon":@"set_auth"},
                               ],
                           @[
                               @{@"name":@"客服中心",@"icon":@"set_customer"},
                               @{@"name":@"关于少保",@"icon":@"set_about"},
                               @{@"name":@"服务协议",@"icon":@"set_service"},
                               @{@"name":@"狩智酷",@"icon":@"set_ysz"},
                               ]

                           ];
        [self.tableView setFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationBG.hidden = YES;
    backBtn.hidden = YES;
    [title setText:@"窝逸"];
}
- (UIView *)headerView
{
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 300)];
    [bg setImage:[UIImage imageNamed:@"set_bg"]];
    bg.userInteractionEnabled = YES;
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0,40, MAIN_WIDTH, 20)];
    [tip setText:@"窝逸"];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [tip setTextColor:UIColorFromRGB(0xffffff)];
    [tip setFont:[UIFont systemFontOfSize:20]];
    [bg addSubview:tip];

    EGOImageView *head = [[EGOImageView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-100)/2, 70, 100, 100)];
    head.clipsToBounds = YES;
    head.layer.cornerRadius = 50;
    [head sd_setImageWithURL:[NSURL URLWithString:[LoginUserUtil shaobaoHeadUrl]] placeholderImage:[UIImage imageNamed:@"logo"]];
    [bg addSubview:head];

    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(head.frame)+10, MAIN_WIDTH, 20)];
    [name setText:[LoginUserUtil shaobaoUserName]];
    [name setTextAlignment:NSTextAlignmentCenter];
    [name setTextColor:UIColorFromRGB(0xffffff)];
    [name setFont:[UIFont systemFontOfSize:20]];
    [bg addSubview:name];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"set_sent"] forState:0];
    [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, (MAIN_WIDTH/2-19)/2, 0, (MAIN_WIDTH/2-19)/2)];
    [btn1 setFrame:CGRectMake(0, CGRectGetMaxY(name.frame)+20, MAIN_WIDTH/2, 50)];
    [btn1 setTitle:@"发布的订单" forState:0];
    [btn1 addTarget:self action:@selector(sentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(40, -20, 0, 0)];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bg addSubview:btn1];

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,CGRectGetMaxY(name.frame)+30, 0.5, 50)];
    [sep setBackgroundColor:UIColorFromRGB(0xffffff)];
    [bg addSubview:sep];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(40, 0, 0, 0)];
    [btn2 addTarget:self action:@selector(receiveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, (MAIN_WIDTH/2-19)/2, 0, (MAIN_WIDTH/2-19)/2)];
    [btn2 setImage:[UIImage imageNamed:@"set_received"] forState:0];
    [btn2 setFrame:CGRectMake(MAIN_WIDTH/2+1, CGRectGetMaxY(name.frame)+20, MAIN_WIDTH/2, 50)];
    [btn2 setTitle:@"承接的订单" forState:0];
    [bg addSubview:btn2];

    return bg;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadDeals];
    self.tableView.tableHeaderView = [self headerView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2){
        return 1;
    }
    NSArray *arr= [self.m_arrData objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2){
        static NSString * identify = @"spe1";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
        [cell addSubview:sep];

        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn addTarget:self action:@selector(logoutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setFrame:CGRectMake(10, 5, MAIN_WIDTH-20, 40)];
        [logoutBtn setBackgroundColor:[UIColor whiteColor]];
        logoutBtn.layer.cornerRadius = 2;
        logoutBtn.layer.borderColor = UIColorFromRGB(0xcfcfcf).CGColor;
        logoutBtn.layer.borderWidth = 0.5;
        [logoutBtn setTitle:@"退出登录" forState:0];
        [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [logoutBtn setTitleColor:UIColorFromRGB(0xDB2E4A) forState:0];
        [cell addSubview:logoutBtn];
        return cell;
    }else{
        NSArray *arr= [self.m_arrData objectAtIndex:indexPath.section];
        NSDictionary *info = [arr objectAtIndex:indexPath.row];
        static NSString * identify = @"spe";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
        [icon setImage:[UIImage imageNamed:info[@"icon"]]];
        [cell addSubview:icon];


        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(50,15, 200, 20)];
        [tip setText:info[@"name"]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x333333)];
        [tip setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:tip];

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
        [cell addSubview:sep];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 10)];
    [vi setBackgroundColor:UIColorFromRGB(0xfafafa)];
    return vi;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){

            [self.navigationController pushViewController:[[NSClassFromString(@"InAndOutMoneyViewController") alloc]init] animated:YES];

        }else if (indexPath.row == 1){
            [self.navigationController pushViewController:[[NSClassFromString(@"MyGradeViewController") alloc]init] animated:YES];
        }else{
            [self.navigationController pushViewController:[[NSClassFromString(@"AuthenticationViewController") alloc]init] animated:YES];
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            WebViewViewController *web = [[WebViewViewController alloc]initWith:@"http://121.196.222.155:8800/h5/my/1" withTitle:@"客服中心"];
            [self.navigationController pushViewController:web animated:YES];
        }else if (indexPath.row == 1){
            WebViewViewController *web = [[WebViewViewController alloc]initWith:@"http://121.196.222.155:8800/h5/my/2" withTitle:@"关于少保"];
            [self.navigationController pushViewController:web animated:YES];
        }else if (indexPath.row == 2){
            WebViewViewController *web = [[WebViewViewController alloc]initWith:@"http://121.196.222.155:8800/h5/my/3" withTitle:@"服务协议"];
            [self.navigationController pushViewController:web animated:YES];
        }else{

            [self.navigationController pushViewController:[[NSClassFromString(@"WantWorkViewController") alloc]init] animated:YES];

        }

    }else{

    }
}
#pragma mark - private

- (void)sentBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"PunishedOrdersViewController") alloc]init] animated:YES];
}

- (void)receiveBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"AcceptedOrdersViewController") alloc]init] animated:YES];

}

- (void)logoutBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
