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
#import "FindSendConfirmOrderViewController.h"
@interface FindSenderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UITextView *commentTextView;
}
@property(assign)NSInteger m_commentIndex;
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
        [self requestData:YES];

        self.m_arrData = findInfo.m_arrPics.count == 0 ? @[
                           @[@"需求信息",@"需求类型",@"需求说明",@"服务区域",@"详细地址"],
                           @[@"费用信息",@"服务费用",@"履约定金"],
                           @[@"联系信息",@"需求人",@"手机号码"],
                           @[@"承接人",@"承接人",@"手机号码",@"承接时间"],
                           ]:
        @[
          @[@"需求信息",@"需求类型",@"需求说明",@"服务区域",@"详细地址"],
          @[@"费用信息",@"服务费用",@"履约定金"],
          @[@"联系信息",@"需求人",@"手机号码"],
          @[@"承接人",@"承接人",@"手机号码",@"承接时间"],
          @[@"图片信息",@""],
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
        if(self.m_helpInfo.m_arrPics.count>0 && path.section == 4){
            NSInteger sep = 10;
            NSInteger num = 4.0;
            NSInteger width = (MAIN_WIDTH-(num+1)*sep)/num;
            NSInteger row = ceil((self.m_helpInfo.m_arrPics.count*1.0)/num);
            return row *(width+sep*2);
        }else{
            return 50;
        }
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
    [tip setFont:[UIFont systemFontOfSize:15]];
    [tip setText:[arr objectAtIndex:indexPath.row]];
    [cell addSubview:tip];
    [tip setTextColor:UIColorFromRGB(0x333333)];

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
            if(self.m_helpInfo.m_status.integerValue !=0){
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
            }

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
    }else if (indexPath.section == 4){
        if(indexPath.row == 0){

        }else{
            for(NSString *url in self.m_helpInfo.m_arrPics){
                NSInteger sep = 10;
                NSInteger num = 4;
                NSInteger index = [self.m_helpInfo.m_arrPics indexOfObject:url];
                NSInteger row = index/num;
                NSInteger coulmn = index%num;
                NSInteger width = (MAIN_WIDTH-(num+1)*sep)/num;
                EGOImageView *img = [[EGOImageView alloc]initWithFrame:CGRectMake(sep+(sep+width)*coulmn, sep+(sep+width)*row, width, width)];
                img.tag = index;
                img.userInteractionEnabled = YES;
                [img setImageForAllSDK:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",url]] withDefaultImage:[UIImage imageNamed:@"logo"]];
                [cell addSubview:img];
            }
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
    if(self.m_helpInfo.m_userScoreStatus.integerValue == 0 && self.m_helpInfo.m_status.integerValue == 3){

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

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 70)];
        [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setFrame:CGRectMake(10, 10, MAIN_WIDTH-20, 50)];
        [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
        if(self.m_helpInfo.m_payStatus.integerValue == 0){
            [sendBtn setTitle: @"立即支付" forState:UIControlStateNormal];
            [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if(self.m_helpInfo.m_status.integerValue == 0){
                sendBtn.hidden = YES;
            }else if(self.m_helpInfo.m_status.integerValue == 1){
                sendBtn.hidden = YES;

            }else if(self.m_helpInfo.m_status.integerValue == 2){
                [sendBtn setTitle: @"确认已完成" forState:UIControlStateNormal];
                [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            }else if(self.m_helpInfo.m_status.integerValue == 3){
                [bg setBackgroundColor:[UIColor clearColor]];
                sendBtn.hidden = YES;

            }
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
                optType:@"1"
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
}

- (void)sendBtnClicked
{
    if(self.m_helpInfo.m_payStatus.integerValue == 0){

        FindSendConfirmOrderViewController *order = [[FindSendConfirmOrderViewController alloc]initWith:self.m_helpInfo];
        [self.navigationController pushViewController:order animated:YES];

    }else{
        [self showWaitingView];
        [HTTP_MANAGER findUpdateStatus:self.m_helpInfo.m_id
                               optType:@"3"
                        successedBlock:^(NSDictionary *succeedResult) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                            if([succeedResult[@"ret"]integerValue] == 1){
                                [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                            }

                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                        }];
    }

}


- (void)acceptBtnClicked
{
    [HTTP_MANAGER getAcceptMessageGroup:self.m_helpInfo.m_id
                         successedBlock:^(NSDictionary *succeedResult) {

                             if([succeedResult[@"ret"]integerValue] == 0){

                                 NSDictionary *info = succeedResult[@"data"];
                                 ADTFindItem *item = [[ADTFindItem alloc]init];
                                 item.m_id = [info stringWithFilted:@"id"];
                                 item.m_isSender = YES;
                                 item.m_acceptUserName = [info stringWithFilted:@"askUserName"];
                                 SendMsgViewController *send =[[SendMsgViewController alloc]initWith:item];
                                 [self.navigationController pushViewController:send animated:YES];
                             }else{
                                 [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                             }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        

    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"输入评价内容"]){
        textView.text = @"";
    }
    return YES;
}
@end


