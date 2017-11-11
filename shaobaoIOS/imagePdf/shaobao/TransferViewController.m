//
//  TransferViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/14.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "TransferViewController.h"

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
}
@property(nonatomic,strong) NSString *m_netMoney;
@property(nonatomic,strong) NSString *m_payType;

@end

@implementation TransferViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
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
    [title setText:@"转赠"];
    [title setTextColor:[UIColor whiteColor]];

    [self.view bringSubviewToFront:navigationBG];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    return 60;
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

    cell.accessoryType = UITableViewCellAccessoryNone;
    UILabel *tit = [[UILabel alloc]initWithFrame:CGRectMake(10,20,100, 20)];
    [tit setTextAlignment:NSTextAlignmentLeft];
    [tit setFont:[UIFont systemFontOfSize:16]];
    [tit setTextColor:UIColorFromRGB(0x333333)];
    [cell addSubview:tit];

    if(indexPath.row == 0){
        [tit setText:@"转赠金额"];
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 20, 190, 20)];
        m_input1.delegate  = self;
        m_input1.returnKeyType = UIReturnKeyDone;
        m_input1.keyboardType = UIKeyboardTypeDecimalPad;
        [m_input1 setTextColor:UIColorFromRGB(0x333333)];
        [m_input1 setPlaceholder:@"请输入转赠金额"];
        [cell addSubview:m_input1];
        [m_input1 resignFirstResponder];
    }else if (indexPath.row == 1){
        [tit setText:@"对方账号"];
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 20, 190, 20)];
        m_input3.delegate  = self;
        m_input3.returnKeyType = UIReturnKeyDone;
//        m_input3.keyboardType = UIKeyboardTypeNumberPad;
        [m_input3 setTextColor:UIColorFromRGB(0x333333)];
        [m_input3 setPlaceholder:@"请输入对方账号"];
        [cell addSubview:m_input3];
    }else if (indexPath.row == 2){

        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm addTarget:self action:@selector(sendBtnClikced) forControlEvents:UIControlEventTouchUpInside];
        [confirm setFrame:CGRectMake(5, 5, MAIN_WIDTH-10, 50)];
        [confirm setBackgroundColor:KEY_COMMON_CORLOR];
        confirm.layer.cornerRadius = 4;
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:[UIColor whiteColor] forState:0];
        [cell addSubview:confirm];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 1){
//        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择提取方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
//        [act showInView:self.view];
//    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [m_input2 setText:@"支付宝"];
    }else
    {
        [m_input2 setText:@"微信"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)sendBtnClikced
{
    if(self.m_netMoney.integerValue == 0){
        [PubllicMaskViewHelper showTipViewWith:@"无钱可取" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_input1.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"转赠金额不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_input2.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"对方账号不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    [HTTP_MANAGER transferCash:m_input2.text
                         money:m_input1.text
                successedBlock:^(NSDictionary *succeedResult) {
               if([succeedResult[@"ret"]integerValue]==0){
                   [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                   [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
               }else{
                   [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
               }
           } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

               [PubllicMaskViewHelper showTipViewWith:@"提取失败" inSuperView:self.view withDuration:1];

           }];


}

@end


