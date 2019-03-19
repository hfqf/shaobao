//
//  MessageDetailViewController.m
//  officeMobile
//
//  Created by Points on 15-3-15.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "FontSizeUtil.h"
@interface MessageDetailViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

{
    UITextField *m_telLab;
    UILabel *m_timeLab;
    UITextView *contentLab;
}
@property (nonatomic,strong)NSString *m_sendTime;
@property (nonatomic,strong)NSString *m_tel;

@end

@implementation MessageDetailViewController

- (BOOL)isValidPhoneNum:(NSString *)tel
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^[1]+\\d{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:tel];
}

- (id)initWithInfo:(NSDictionary *)info
{
    self.m_info = info;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.m_isSendMsg = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadDeals];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    if(self.m_isSendMsg)
    {
        [title setText:@"写短信"];
    }

}

- (void)sendBtnClicked
{
    [contentLab resignFirstResponder];
    [m_telLab resignFirstResponder];
    self.m_tel = m_telLab.text;
    NSString *tit = contentLab.text;
    tit = [tit stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(m_telLab.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入号码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(![self isValidPhoneNum:m_telLab.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"号码不合法" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(tit.length == 0 || [contentLab.text isEqualToString:@"请输入内容"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息内容不能为空" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [m_telLab resignFirstResponder];
    [contentLab resignFirstResponder];
    [HTTP_MANAGER sendMessageWithTel:m_telLab.text
                         WithContent:contentLab.text
                            WithTime: self.m_sendTime
                      successedBlock:^(NSDictionary *retDic){
                      
                          if([retDic[@"resultCode"]integerValue] == 0)
                          {
                              if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onNeedRefreshTableView)]
                                 )
                              {
                                  [self.m_delegate onNeedRefreshTableView];
                              }
                              [PubllicMaskViewHelper showTipViewWith:@"发送成功" inSuperView:self.view withDuration:1];
                              [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                               ];
                          }
                          else
                          {
                              [PubllicMaskViewHelper showTipViewWith:@"发送失败" inSuperView:self.view withDuration:1];

                          }
                          
                      } failedBolck:FAILED_BLOCK{
                          
                      [PubllicMaskViewHelper showTipViewWith:@"发送失败" inSuperView:self.view withDuration:1];
                      
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [FontSizeUtil sizeOfString:self.m_info[@"mcontent"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-20];
    if(self.m_isSendMsg)
    {
        size = CGSizeMake(MAIN_WIDTH-20, 120);
    }
    
    if(self.m_isSendMsg)
    {
        if(indexPath.row < 3)
        {
            int high = indexPath.row == 2 ?size.height+ 60 : 40;
            return high;
        }
        else
        {
            return 40;
        }
    }
    else
    {
        return indexPath.row == 2 ?size.height+ 60 : 40;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_isSendMsg ? 4 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0)
    {
        CGSize tipSize = [FontSizeUtil sizeOfString:@"发送时间:" withFont:[UIFont boldSystemFontOfSize:15] withWidth:MAIN_WIDTH-20];
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tipSize.width, tipSize.height)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont boldSystemFontOfSize:15]];
        [cell addSubview:tip];
        self.m_sendTime = [LocalTimeUtil getCurrentTime];

        [tip setText:[NSString stringWithFormat:@"发送时间"]];

        
        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 5,MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+5),30)];
        [m_timeLab setFont:[UIFont systemFontOfSize:14]];
        if(self.m_isSendMsg)
        {
            [m_timeLab setText:[NSString stringWithFormat:@"%@",self.m_sendTime]];
        }
        else
        {
            [m_timeLab setText:[NSString stringWithFormat:@"%@",self.m_info[@"sendTime"]]];
        }
//        m_timeLab.layer.cornerRadius = 4;
//        m_timeLab.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
//        m_timeLab.layer.borderWidth = 0.5;
        [cell addSubview:m_timeLab];
        [cell addSubview:tip];
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_timeLab.frame)+5, MAIN_WIDTH, 0.5)];
        sep.alpha = 0.3;
        sep.backgroundColor = [UIColor grayColor];
        [cell addSubview:sep];
        
    }
    else if (indexPath.row == 1)
    {
        
        CGSize tipSize = [FontSizeUtil sizeOfString:@"发送号码:" withFont:[UIFont boldSystemFontOfSize:15] withWidth:MAIN_WIDTH-20];
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tipSize.width, tipSize.height)];
        [tip setText:@"发送号码:"];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont boldSystemFontOfSize:15]];
        [cell addSubview:tip];
        
        m_telLab = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 5,MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+5),30)];
        [m_telLab setUserInteractionEnabled:self.m_isSendMsg];
        [m_telLab setFont:[UIFont systemFontOfSize:14]];
        if(self.m_isSendMsg)
        {
            [m_telLab setText:self.m_tel];
        }
        else
        {
            [m_telLab setText:[self.m_info stringWithFilted:@"dPhonenum"]];

        }
//        m_telLab.layer.cornerRadius = 4;
//        m_telLab.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
//        m_telLab.layer.borderWidth = 0.5;

        [cell addSubview:m_telLab];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_telLab.frame)+5, MAIN_WIDTH, 0.5)];
        sep.alpha = 0.3;
        sep.backgroundColor = [UIColor grayColor];
        [cell addSubview:sep];
    }
    else if (indexPath.row == 2)
    {
        CGSize size = [FontSizeUtil sizeOfString:self.m_info[@"mcontent"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-20];
        if(self.m_isSendMsg)
        {
            size = CGSizeMake(MAIN_WIDTH-20, 80);
        }
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,10,MAIN_WIDTH-20, 15)];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"发送内容:"];
        [tip setFont:[UIFont boldSystemFontOfSize:15]];
        [cell addSubview:tip];
        
        contentLab = [[UITextView alloc]initWithFrame:CGRectMake(10,35,MAIN_WIDTH-20, size.height+50)];
        contentLab.delegate = self;
        contentLab.userInteractionEnabled = self.m_isSendMsg;
        [contentLab setText:self.m_info[@"mcontent"]];

        if(self.m_isSendMsg)
        {
            [contentLab setText:@"请输入内容"];
        }
        [contentLab setBackgroundColor:UIColorFromRGB(0Xf9f9f9)];
        contentLab.layer.cornerRadius = 4;
        contentLab.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
        contentLab.layer.borderWidth = 0.5;
        [contentLab setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:contentLab];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLab.frame)+5, MAIN_WIDTH, 0.5)];
        sep.alpha = 0.3;
        sep.backgroundColor = [UIColor grayColor];
        [cell addSubview:sep];
    }
    else
    {
        UIButton *qpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [qpBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [qpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [qpBtn setFrame:CGRectMake((MAIN_WIDTH-40)/2, 2, 40, 35)];
        [qpBtn setTitle:@"发送" forState:UIControlStateNormal];
        [qpBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        qpBtn.layer.cornerRadius = 4;
        qpBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        qpBtn.layer.borderWidth = 0.5;
        [cell addSubview:qpBtn];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setText:nil];
    return YES;
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.m_tel = textField.text;
    return YES;
}

@end


