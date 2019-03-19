//
//  ShaobaoRegisterViewController.m
//  shaobao
//
//  Created by points on 2017/9/11.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ShaobaoRegisterViewController.h"

@interface ShaobaoRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITextField *input0;
    UITextField *input1;
    UITextField *input2;
    UITextField *input3;
    UITextField *input4;
    UITextField *input5;
    UITextField *input6;
    UITextField *input;
}
@end

@implementation ShaobaoRegisterViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
        self.m_arrData = @[
                            @"用户昵称*",
                            @"选择身份*",
                            @"登录账号*",
                            @"登录密码*",
                            @"手机号码*",
                           ];
        [self addFooterView];
        [self reloadDeals];
    }
    return self;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"用户注册"];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFooterView
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 90)];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:KEY_COMMON_CORLOR];
    [loginBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:CGRectMake(10, 20,MAIN_WIDTH-20, 50)];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 22.5;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [footer addSubview:loginBtn];
    self.tableView.tableFooterView = footer;

}

- (void)commitBtnClicked
{
    if(input.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"用户姓名不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(input0.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"身份不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(input1.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"登录不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(input2.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"登录密码不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(input3.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"手机号码不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    [self showWaitingView];
    [HTTP_MANAGER startRegister:input1.text
                      loginPass:input2.text
                       userName:input.text
                           type:[input0.text
                                 isEqualToString:@"个人"] ? @"1" : @"2"
                          phone:input3.text
                          email:input4.text
                         weixin:input5.text
                             qq:input6.text
                 successedBlock:^(NSDictionary *succeedResult) {
                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                     if([succeedResult[@"ret"]integerValue]==0){
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                     }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"注册失败" inSuperView:self.view withDuration:1];
    }];

}



- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identy = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[self.m_arrData objectAtIndex:indexPath.row]];
    [str addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(4, 1)];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
    [tip setAttributedText:str];
    
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setFont:[UIFont systemFontOfSize:16]];
    [tip setTextColor:UIColorFromRGB(0x5d5d5d)];
    [cell addSubview:tip];

    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.row == 0){
        if(input == nil){
            input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input.font = [UIFont systemFontOfSize:15];
        input.textAlignment = NSTextAlignmentRight;
        input.placeholder = @"请输入用户姓名";
        input.delegate = self;
        input.returnKeyType = UIReturnKeyDone;
        input.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input];

    }else if(indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(input0 == nil){
            input0 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-90, 15,60, 20)];
        }
        input0.enabled = NO;
        input0.font = [UIFont systemFontOfSize:15];
        input0.textAlignment = NSTextAlignmentRight;
        input0.delegate = self;
        input0.returnKeyType = UIReturnKeyDone;
        input0.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input0];
    }else if(indexPath.row == 2){
        if(input1 == nil){
            input1 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input1.font = [UIFont systemFontOfSize:15];
        input1.textAlignment = NSTextAlignmentRight;
        input1.placeholder = @"请输入登录账号";
        input1.delegate = self;
        input1.returnKeyType = UIReturnKeyDone;
        input1.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input1];

    }else if(indexPath.row == 3){
        if(input2 == nil){
            input2 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input2.font = [UIFont systemFontOfSize:15];
        input2.textAlignment = NSTextAlignmentRight;
        input2.placeholder = @"请输入登录密码";
        input2.delegate = self;
        input2.returnKeyType = UIReturnKeyDone;
        input2.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input2];

    }else if(indexPath.row == 4){
        if(input3 == nil){
            input3 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input3 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        input3.font = [UIFont systemFontOfSize:15];
        input3.textAlignment = NSTextAlignmentRight;
        input3.placeholder = @"请输入手机号码";
        input3.delegate = self;
        input3.returnKeyType = UIReturnKeyDone;
        input3.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input3];

    }else if(indexPath.row == 5){
        if(input4 == nil){
            input4 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input4 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        input4.font = [UIFont systemFontOfSize:15];
        input4.textAlignment = NSTextAlignmentRight;
        input4.placeholder = @"请输入邮箱账号";
        input4.delegate = self;
        input4.returnKeyType = UIReturnKeyDone;
        input4.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input4];

    }else if(indexPath.row == 6){
        if(input5 == nil){
            input5 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input5 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        input5.font = [UIFont systemFontOfSize:15];
        input5.textAlignment = NSTextAlignmentRight;
        input5.placeholder = @"请输入微信账号";
        input5.delegate = self;
        input5.returnKeyType = UIReturnKeyDone;
        input5.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input5];

    }else if(indexPath.row == 7){
        if(input6 == nil){
            input6 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        }
        input6 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-10, 15, MAIN_WIDTH/2, 20)];
        input6.font = [UIFont systemFontOfSize:15];
        input6.textAlignment = NSTextAlignmentRight;
        input6.placeholder = @"请输入QQ号";
        input6.delegate = self;
        input6.returnKeyType = UIReturnKeyDone;
        input6.textColor = UIColorFromRGB(0xa1a1a1);
        [cell addSubview:input6];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){

        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择身份" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"商家",@"个人", nil];
        [act showInView:self.view];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [input0 setText:@"商家"];
    }else{
        [input0 setText:@"个人"];
    }
}



@end
