//
//  UserInfoViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/24.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TggStarEvaluationView.h"
@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *m_id;
@end

@implementation UserInfoViewController

- (id)initWith:(NSDictionary *)userInfo
{
    self.m_info = userInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        self.m_arrData = @[
                           @[@"基本信息",@"身份认证",@"会员等级",@"财产等级"],
                           @[@"五大等级",@"契约履行等级",@"敬业敬职等级",@"服务品质等级",@"忠勇孝勤等级",@"感恩义道等级"],
                           @[@"十大能力",@"快速执行能力",@"承担责任能力",@"敢拼敢闯能力",@"屡败屡战能力",@"号召组织能力",@"感恩处世能力",@"合作协作能力",@"技能水平能力",@"管理水平能力",@"策划水平能力",],
                           @[@"客户评价",@"发布的订单",@"承接的订单"],
                           ];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"用户信息"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (float)high:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 30;
    }else if(indexPath.section == 3 && indexPath.row > 0){
        return 70;
    }else
    {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self high:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr= [self.m_arrData objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr= [self.m_arrData objectAtIndex:indexPath.section];

    if(indexPath.section == 0){

        static NSString * identify = @"spe1";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 100, 20)];
        [tip setFont:[UIFont systemFontOfSize:15]];
        [tip setText:[arr objectAtIndex:indexPath.row]];
        [tip setTextColor:UIColorFromRGB(0x333333)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:tip];

        UILabel*value = [[UILabel alloc]initWithFrame:CGRectMake(120,([self high:indexPath]-20)/2,MAIN_WIDTH-130, 20)];
        [value setFont:[UIFont systemFontOfSize:15]];
        [value setTextColor:UIColorFromRGB(0x333333)];
        [value setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:value];

        if(indexPath.row == 1){
            NSInteger flag = [self.m_info[@"ugrade1"]integerValue];
            [value setText:flag == 0 ? @"未认证":@"已认证"];
        }else if (indexPath.row == 2){
            NSInteger flag = [self.m_info[@"ugrade2"]integerValue];
            if(flag==0){
                [value setText:@"非会员"];
            }else if (flag == 1){
                [value setText:@"会员"];
            }else if (flag == 2){
                [value setText:@"高级会员"];
            }else if (flag == 3){
                [value setText:@"贵宾"];
            }
        }else  if (indexPath.row == 3){
            NSInteger flag = [self.m_info[@"ugrade3"]integerValue];
            if(flag==-1){
                [value setText:@"负产"];
            }else if (flag == 0){
                [value setText:@"无产"];
            }else if (flag == 1){
                [value setText:@"特困"];
            }else if (flag == 2){
                [value setText:@"赤贫"];
            }else if (flag == 3){
                [value setText:@"贫穷"];
            }else if (flag == 4){
                [value setText:@"工薪"];
            }else if (flag == 5){
                [value setText:@"蓝领"];
            }else if (flag == 6){
                [value setText:@"白领"];
            }else if (flag == 7){
                [value setText:@"金领"];
            }else if (flag == 8){
                [value setText:@"中产"];
            }else if (flag == 9){
                [value setText:@"富人"];
            }else if (flag == 10){
                [value setText:@"富翁"];
            }else if (flag == 11){
                [value setText:@"大富翁"];
            }else if (flag == 12){
                [value setText:@"富豪"];
            }else if (flag == 13){
                [value setText:@"大富豪"];
            }else if (flag == 14){
                [value setText:@"超级大富豪"];
            }
        }

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
        [cell addSubview:sep];
        return cell;

    }else if (indexPath.section == 1 ||indexPath.section == 2){
        if(indexPath.row == 0){

            static NSString * identify = @"spe1";
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 100, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setText:[arr objectAtIndex:indexPath.row]];
            [tip setTextColor:UIColorFromRGB(0x333333)];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
            [cell addSubview:sep];
            return cell;

        }else{

            static NSString * identify = @"spe1";
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 100, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setText:[arr objectAtIndex:indexPath.row]];
            [tip setTextColor:UIColorFromRGB(0x333333)];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
            [cell addSubview:sep];
            TggStarEvaluationView *tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:nil];
            tggStarEvaView.tapEnabled = NO;
            tggStarEvaView.frame = CGRectMake(120, ([self high:indexPath]-30)/2, 150, 30);
            [cell addSubview:tggStarEvaView];

            if(indexPath.section == 1){
                NSInteger num = [self.m_info[[NSString stringWithFormat:@"grade%lu",indexPath.row]]integerValue];
                tggStarEvaView.starCount = num;
            }else{
                NSInteger num = [self.m_info[[NSString stringWithFormat:@"ability%lu",indexPath.row]]integerValue];
                tggStarEvaView.starCount = num;
            }
            return cell;
        }

    }else{

        if(indexPath.row == 0){
            static NSString * identify = @"spe1";
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 100, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setText:[arr objectAtIndex:indexPath.row]];
            [tip setTextColor:UIColorFromRGB(0x333333)];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
            [cell addSubview:sep];
            return cell;
        }else if(indexPath.row == 1){

            static NSString * identify = @"spe1";
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10,15, 100, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setText:[arr objectAtIndex:indexPath.row]];
            [tip setTextColor:UIColorFromRGB(0x333333)];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip];

            UILabel*tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10,40, 100, 20)];
            [tip1 setFont:[UIFont systemFontOfSize:15]];
            [tip1 setText:@"评价"];
            [tip1 setTextColor:UIColorFromRGB(0x333333)];
            [tip1 setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip1];

            UILabel*sentNum = [[UILabel alloc]initWithFrame:CGRectMake(120,15, 100, 20)];
            [sentNum setFont:[UIFont systemFontOfSize:15]];
            [sentNum setText:[NSString stringWithFormat:@"%ld次",[self.m_info[@"stotal"]intValue]]];
            [sentNum setTextColor:UIColorFromRGB(0x333333)];
            [sentNum setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:sentNum];

            UILabel*badNum = [[UILabel alloc]initWithFrame:CGRectMake(120,40,MAIN_WIDTH-140, 20)];
            [badNum setFont:[UIFont systemFontOfSize:14]];
            [badNum setText:[NSString stringWithFormat:@"差评%ld   好评%ld   中评%ld",[self.m_info[@"scomment1"]intValue],[self.m_info[@"scomment2"]intValue],[self.m_info[@"scomment3"]intValue] ]];
            [badNum setTextColor:UIColorFromRGB(0x333333)];
            [badNum setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:badNum];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
            [cell addSubview:sep];

            return cell;
        }else if(indexPath.row == 2){

            static NSString * identify = @"spe1";
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel*tip = [[UILabel alloc]initWithFrame:CGRectMake(10,15, 100, 20)];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [tip setText:[arr objectAtIndex:indexPath.row]];
            [tip setTextColor:UIColorFromRGB(0x333333)];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip];

            UILabel*tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10,40, 100, 20)];
            [tip1 setFont:[UIFont systemFontOfSize:15]];
            [tip1 setText:@"评价"];
            [tip1 setTextColor:UIColorFromRGB(0x333333)];
            [tip1 setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:tip1];

            UILabel*sentNum = [[UILabel alloc]initWithFrame:CGRectMake(120,15, 100, 20)];
            [sentNum setFont:[UIFont systemFontOfSize:15]];
            [sentNum setText:[NSString stringWithFormat:@"%ld次",[self.m_info[@"rtotal"]intValue]]];
            [sentNum setTextColor:UIColorFromRGB(0x333333)];
            [sentNum setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:sentNum];

            UILabel*badNum = [[UILabel alloc]initWithFrame:CGRectMake(120,40,MAIN_WIDTH-140, 20)];
            [badNum setFont:[UIFont systemFontOfSize:14]];
            [badNum setText:[NSString stringWithFormat:@"差评%ld   好评%ld   中评%ld",[self.m_info[@"rcomment1"]intValue],[self.m_info[@"rcomment2"]intValue],[self.m_info[@"rcomment3"]intValue] ]];
            [badNum setTextColor:UIColorFromRGB(0x333333)];
            [badNum setTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:badNum];
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
            [cell addSubview:sep];
            return cell;

        }

    }

    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 10)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    return bg;
}
@end

