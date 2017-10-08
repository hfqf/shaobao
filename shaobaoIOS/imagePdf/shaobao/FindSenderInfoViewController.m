//
//  FindSenderInfoViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindSenderInfoViewController.h"
#import "FindAskMessagesViewController.h"
#import "SendMsgViewController.h"
@interface FindSenderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)ADTFindItem *m_helpInfo;
@end

@implementation FindSenderInfoViewController

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
                           @[@"需求信息",@"需求类型",@"需求说明",@"服务区域",@"详细地址"],
                           @[@"费用信息",@"服务费用",@"履约定金"],
                           @[@"联系信息",@"需求人",@"手机号码"],
                           @[@"承接人",@"承接人",@"手机号码",@"承接时间"],
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
    [title setText:@"需求详情"];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-120,20 , 120, 44)];
    [rightBtn setTitle:@"咨询消息" forState:0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    [navigationBG addSubview:rightBtn];
}

- (void)rightBtnClicked
{
    FindAskMessagesViewController *ask = [[FindAskMessagesViewController alloc]initWith:self.m_helpInfo];
    [self.navigationController pushViewController:ask animated:YES];
}


- (void)requestData:(BOOL)isRefresh
{
    self.tableView.tableFooterView = [self footerView];
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
            if(type == 0){
                [content setText:@"叫人帮忙"];
            }else if (type == 1){
                [content setText:@"律师侦探"];
            }else if (type == 2){
                [content setText:@"护卫保镖"];
            }else if (type == 3){
                [content setText:@"纠纷债务"];
            }else{
                [content setText:@"个性需求"];
            }
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 2){

            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 2;
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
            [content setText:[LoginUserUtil shaobaoUserName]];
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

        }
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            UIButton * m_acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [m_acceptBtn addTarget:self action:@selector(acceptBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [m_acceptBtn setTitle:@"联系承接人" forState:0];
            [m_acceptBtn setTitleColor:KEY_COMMON_CORLOR forState:0];
            [m_acceptBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [m_acceptBtn setFrame:CGRectMake(MAIN_WIDTH-130,2, 120,26)];
            m_acceptBtn.layer.cornerRadius = m_acceptBtn.frame.size.height/2;
            m_acceptBtn.layer.borderColor = UIColorFromRGB(0XCFCFCF).CGColor;
            m_acceptBtn.layer.borderWidth = 0.5;
            [cell addSubview:m_acceptBtn];
        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2, MAIN_WIDTH-160, 20)];
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_acceptUserId];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else if(indexPath.row == 2){

            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 10;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_acceptUserPhone];
            [cell addSubview:content];
            [content setTextColor:[UIColor blackColor]];

        }else{
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(150, ([self high:indexPath]-20)/2,MAIN_WIDTH-160, 20)];
            content.tag = 10;
            [content setTextAlignment:NSTextAlignmentLeft];
            [content setFont:[UIFont systemFontOfSize:13]];
            [content setText:self.m_helpInfo.m_acceptTime];
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
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 70)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(10, 10, MAIN_WIDTH-20, 50)];
    [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [bg addSubview:sendBtn];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sendBtn.layer.cornerRadius = 3;
    return bg;
}

- (void)sameFeeBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (void)sendBtnClicked
{
    [HTTP_MANAGER findUpdateStatus:self.m_helpInfo.m_id
                           optType:@"2"
                    successedBlock:^(NSDictionary *succeedResult) {

                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                    }];
}


- (void)acceptBtnClicked
{
    SendMsgViewController *send =[[SendMsgViewController alloc]initWith:self.m_helpInfo];
    [self.navigationController pushViewController:send animated:YES];
}
@end


