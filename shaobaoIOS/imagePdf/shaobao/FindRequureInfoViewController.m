//
//  FindRequureInfoViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindRequureInfoViewController.h"
#import "SendMsgViewController.h"
#import "TggStarEvaluationView.h"
@interface FindRequureInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UITextView *commentTextView;
}
@property(assign)NSInteger m_commentIndex;
@property(nonatomic,strong)ADTFindItem *m_helpInfo;
@property(assign)BOOL m_isAcceptProtocol;
@end

@implementation FindRequureInfoViewController

- (id)initWith:(ADTFindItem *)findInfo
{
    self.m_isAcceptProtocol = NO;
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
                           @[@"联系信息",@"需求人",@"手机号码",@"邮箱",@"微信"],
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
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-120, 20, 120, 44)];
    [rightBtn setTitle:@"联系需求人" forState:0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    [navigationBG addSubview:rightBtn];

}

- (void)rightBtnClicked
{
    if([LoginUserUtil isLogined]){
        SendMsgViewController *send =[[SendMsgViewController alloc]initWith:self.m_helpInfo];
        [self.navigationController pushViewController:send animated:YES];
    }else{
        [self.navigationController pushViewController:[[NSClassFromString(@"LoginViewController") alloc]init] animated:YES];
    }
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
            if(type == 1){
                [content setText:@"叫人帮忙"];
            }else if (type == 2){
                [content setText:@"律师侦探"];
            }else if (type == 3){
                [content setText:@"护卫保镖"];
            }else if (type == 4){
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

    if(self.m_helpInfo.m_acceptScoreStatus.integerValue == 0 && self.m_helpInfo.m_status.integerValue == 3){

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 280)];
        [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];

        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10,0,200, 20)];
        [lab setText:@"填写交易评价"];
        [lab setFont:[UIFont systemFontOfSize:15]];
        [lab setTextColor:UIColorFromRGB(0x333333)];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [bg addSubview:lab];


        UIButton *sendBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn1 addTarget:self action:@selector(selectLevelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn1 setFrame:CGRectMake(10, 25, 80, 30)];
        [bg addSubview:sendBtn1];
        sendBtn1.tag = 0;
        [sendBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
        sendBtn1.layer.cornerRadius = 3;
        sendBtn1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        sendBtn1.layer.borderWidth = 0.5;
        [sendBtn1 setTitle:@"好评" forState:0];
        [sendBtn1 setBackgroundColor:self.m_commentIndex == 0 ? KEY_COMMON_CORLOR : [UIColor lightGrayColor]];

        UIButton *sendBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn2.tag = 1;
        [sendBtn2 addTarget:self action:@selector(selectLevelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn2 setFrame:CGRectMake(100, 25, 80, 30)];
        [bg addSubview:sendBtn2];
        [sendBtn2.titleLabel setFont:[UIFont systemFontOfSize:15]];
        sendBtn2.layer.cornerRadius = 3;
        sendBtn2.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        sendBtn2.layer.borderWidth = 0.5;
        [sendBtn2 setTitle:@"中评" forState:0];
        [sendBtn2 setBackgroundColor:self.m_commentIndex == 1 ? KEY_COMMON_CORLOR : [UIColor lightGrayColor]];

        UIButton *sendBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn3.tag = 2;
        [sendBtn3 addTarget:self action:@selector(selectLevelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn3 setFrame:CGRectMake(190,25, 80, 30)];
        [bg addSubview:sendBtn3];
        [sendBtn3.titleLabel setFont:[UIFont systemFontOfSize:15]];
        sendBtn3.layer.cornerRadius = 3;
        sendBtn3.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        sendBtn3.layer.borderWidth = 0.5;
        [sendBtn3 setTitle:@"差评" forState:0];
        [sendBtn3 setBackgroundColor:self.m_commentIndex == 2 ? KEY_COMMON_CORLOR : [UIColor lightGrayColor]];

        if(commentTextView==nil){
            commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 70, MAIN_WIDTH-20, 150)];
        }
        [commentTextView setText:@"输入评价内容"];
        commentTextView.delegate = self;
        commentTextView.layer.cornerRadius = 4;
        [bg addSubview:commentTextView];

        UIButton *sendCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendCommentBtn addTarget:self action:@selector(sendCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [sendCommentBtn setFrame:CGRectMake(10, 230, MAIN_WIDTH-20, 40)];
        [bg addSubview:sendCommentBtn];
        [sendCommentBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        sendCommentBtn.layer.cornerRadius = 3;
        [sendCommentBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [sendCommentBtn setTitle:@"保存评价" forState:0];
        return bg;

    }else{

    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH,self.m_helpInfo.m_status.integerValue == 0 ? 110 : 60)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];

    if(self.m_helpInfo.m_status.integerValue == 0){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(sameFeeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(10, 0, 30, 30)];
        btn.selected = self.m_isAcceptProtocol;
        [btn setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [bg addSubview:btn];

        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(50,5,MAIN_WIDTH-50, 16)];
        [content setTextAlignment:NSTextAlignmentLeft];
        [content setFont:[UIFont systemFontOfSize:14]];
        [content setText:@"我接受对方等额定金进行履约!"];
        [bg addSubview:content];
        [content setTextColor:[UIColor blackColor]];
    }

    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(10,self.m_helpInfo.m_status.integerValue == 0 ? 50 : 0, MAIN_WIDTH-20, 50)];
    [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
    if(self.m_helpInfo.m_status.integerValue == 0){
        if(self.m_isAcceptProtocol){
            [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
            sendBtn.userInteractionEnabled = YES;
        }else{
            [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
            sendBtn.userInteractionEnabled = NO;
        }
        [sendBtn setTitle:@"确认承接" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.m_helpInfo.m_status.integerValue == 1){
        [sendBtn setTitle:@"确认已完成" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.m_helpInfo.m_status.integerValue == 2){
        //        [sendBtn setTitle:@"等待对方确认" forState:UIControlStateNormal];
        sendBtn.hidden = YES;
    }else if (self.m_helpInfo.m_status.integerValue == 3){
        //        [sendBtn setTitle:@"对方确认已完成" forState:UIControlStateNormal];
        sendBtn.hidden = YES;



    }
    [bg addSubview:sendBtn];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sendBtn.layer.cornerRadius = 3;
    return bg;
    }
    return [[UIView alloc]init];
}

- (void)sendCommentBtnClicked
{

    [HTTP_MANAGER score:self.m_helpInfo.m_id
            scoreResult:[NSString stringWithFormat:@"%ld",self.m_commentIndex]
           scoreContent:commentTextView.text
                optType:@"2"
         successedBlock:^(NSDictionary *succeedResult) {
             [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
             if([succeedResult[@"ret"]integerValue] == 0){
                 [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
             }

         } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {


         }];
}

- (void)selectLevelBtnClicked:(UIButton *)btn
{
    self.m_commentIndex = btn.tag;
    self.tableView.tableFooterView = [self footerView];
}


- (void)sameFeeBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.m_isAcceptProtocol = btn.selected;
    self.tableView.tableFooterView = [self footerView];

}

- (void)sendBtnClicked
{
    if([LoginUserUtil isLogined]){
        [self showWaitingView];
        [HTTP_MANAGER findUpdateStatus:self.m_helpInfo.m_id
                               optType:[NSString stringWithFormat:@"%ld",self.m_helpInfo.m_status.integerValue+1]
                        successedBlock:^(NSDictionary *succeedResult) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                            if([succeedResult[@"ret"]integerValue] == 1){
                                [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                            }

                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                        }];
    }else{
        [self.navigationController pushViewController:[[NSClassFromString(@"LoginViewController") alloc]init] animated:YES];
    }

}

@end

