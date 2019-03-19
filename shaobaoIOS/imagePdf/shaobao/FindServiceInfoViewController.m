//
//  FindServiceInfoViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/12.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindServiceInfoViewController.h"
#import "SendMsgViewController.h"
#import "FindSendConfirmOrderViewController.h"
@interface FindServiceInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)ADTFindItem *m_helpInfo;
@end

@implementation FindServiceInfoViewController

- (id)initWith:(ADTFindItem *)findInfo
{
    self.m_helpInfo = findInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@""]];
        self.m_helpInfo.m_arrPics = arr;
        [self requestData:YES];

        self.m_arrData = @[
                           @[@"服务信息",@"服务类型",@"服务说明",@"区域地址"],
                           @[@"费用信息",@"履约保证金"],
                           @[@"联系信息",@"发布人",@"手机号码",@"邮箱"],
                           ];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height)];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"服务详情"];

//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-120, 20, 120, 44)];
//    [rightBtn setTitle:@"联系需求人" forState:0];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [navigationBG addSubview:rightBtn];
}

- (void)rightBtnClicked
{
    SendMsgViewController *send =[[SendMsgViewController alloc]initWith:self.m_helpInfo];
    [self.navigationController pushViewController:send animated:YES];
}


- (void)requestData:(BOOL)isRefresh
{
    if(self.m_helpInfo.m_payStatus.integerValue == 0){
        self.tableView.tableFooterView = [self footerView];
    }
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    return arr.count;
}

- (CGFloat)high:(NSIndexPath *)path
{
    
    if(path.row == 2 &&path.section == 0){
        CGSize size = [FontSizeUtil sizeOfString:self.m_helpInfo.m_content withFont:[UIFont systemFontOfSize:13] withWidth:MAIN_WIDTH-160];
        return size.height+20;
    }
    if(path.row == 0){

        return 30;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    NSArray *arr = [self.m_arrData objectAtIndex:indexPath.section];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 100, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setText:[arr objectAtIndex:indexPath.row]];
    [cell addSubview:tip];
    [tip setTextColor:[UIColor blackColor]];

    if(indexPath.section == 0){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2, MAIN_WIDTH-160, 20)];
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            NSInteger type = self.m_helpInfo.m_type.integerValue;
            if(type == 1){
                [content setText:@"叫人帮忙"];
            }else if (type == 2){
                [content setText:@"律师侦探"];
            }else if (type == 3){
                [content setText:@"护卫保镖"];
            }else if (type ==4){
                [content setText:@"纠纷债务"];
            }else{
                [content setText:@"个性需求"];
            }
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 2){

            CGSize size = [FontSizeUtil sizeOfString:self.m_helpInfo.m_content withFont:[UIFont systemFontOfSize:13] withWidth:MAIN_WIDTH-160];
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150,10,MAIN_WIDTH-160,size.height)];
            content.tag = 2;
            content.numberOfLines = 0;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_content];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 3){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2, MAIN_WIDTH-160, 20)];
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:[NSString stringWithFormat:@"%@ %@ %@",self.m_helpInfo.m_provinceName,self.m_helpInfo.m_cityName,self.m_helpInfo.m_countyName]];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];
        }
        else{
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 4;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_address];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 6;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:[NSString stringWithFormat:@"%@元",self.m_helpInfo.m_creditFee]];
            [cell addSubview:content];
            [content setTextColor:KEY_COMMON_CORLOR];

        }else if(indexPath.row == 2){

            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 7;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:[NSString stringWithFormat:@"%@元",self.m_helpInfo.m_serviceFee]];
            [cell addSubview:content];
            [content setTextColor:KEY_COMMON_CORLOR];

        }

    }else if (indexPath.section == 2){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2, MAIN_WIDTH-160, 20)];
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_userName];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 2){

            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 10;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_userPhone];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 3){
            
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 11;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_email];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];
            
        }
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
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

- (UIView *)footerView
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 60)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(10, 0, MAIN_WIDTH-20, 50)];
    [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
    [sendBtn addTarget:self action:@selector(payBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [bg addSubview:sendBtn];

    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sendBtn.layer.cornerRadius = 3;


//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(sameFeeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setFrame:CGRectMake(10, 0, 30, 30)];
//    btn.selected = YES;
//    [btn setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
//    [bg addSubview:btn];
//
//    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(50,5,MAIN_WIDTH-50, 16)];
//    [content setTextAlignment:NSTextAlignmentLeft];
//    [content setFont:[UIFont systemFontOfSize:14]];
//    [content setText:@"我接受对方等额定金进行履约!"];
//    [bg addSubview:content];
//    [content setTextColor:[UIColor blackColor]];
    return bg;
}

- (void)payBtnClicked{

    self.m_helpInfo.m_serviceFee = @"0";
    FindSendConfirmOrderViewController *order = [[FindSendConfirmOrderViewController alloc]initWith:self.m_helpInfo];
    [self.navigationController pushViewController:order animated:YES];
    
}

- (void)sendBtnClicked
{
    [HTTP_MANAGER findUpdateStatus:self.m_helpInfo.m_id
                           optType:@"1"
                    successedBlock:^(NSDictionary *succeedResult) {

                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                    }];
}

@end


