//
//  NewScheduleViewController.m
//  officeMobile
//
//  Created by Points on 15/11/1.
//  Copyright © 2015年 com.kinggrid. All rights reserved.
//

#import "NewScheduleViewController.h"

@implementation NewScheduleViewController
-(id)initWithInfo:(NSDictionary *)info
{
    self.m_defaultTime = [LocalTimeUtil getLocalTimeWith2:[NSDate date]];
    self.m_info = [NSMutableDictionary dictionaryWithDictionary:info];
    self.m_isAdd = self.m_info.allKeys.count == 0 ;
    if(self.m_isAdd)
    {
        [self.m_info setObject:self.m_defaultTime forKey:@"startTime"];
        [self.m_info setObject:self.m_defaultTime forKey:@"endTime"];
        [self.m_info setObject:self.m_defaultTime forKey:@"remindTime"];
    }
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = UIColorFromRGB(0xededed);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [title setText:self.m_isAdd ?@"新的日程" : self.m_info[@"title"]];
    
    
    if(self.m_isAdd)
    {
        UIView *headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 50)];
        
        int width = 40;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setFrame:CGRectMake((MAIN_WIDTH-width)/2, 10, width, 30)];
        [saveBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        saveBtn.layer.borderWidth = 0.5;
        saveBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        saveBtn.layer.cornerRadius = 4;
        [headVeiw addSubview:saveBtn];

        self.tableView.tableFooterView = headVeiw;
    }
    else
    {
        UIView *headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 50)];
        
        int width = 40;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setFrame:CGRectMake((MAIN_WIDTH/2)-width-20, 10, width, 30)];
        [saveBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        saveBtn.layer.borderWidth = 0.5;
        saveBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        saveBtn.layer.cornerRadius = 4;
        [headVeiw addSubview:saveBtn];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setTitle:@"删除" forState:UIControlStateNormal];
        [commitBtn setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, width, 30)];
        [commitBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        commitBtn.layer.borderWidth = 0.5;
        commitBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        commitBtn.layer.cornerRadius = 4;
        [headVeiw addSubview:commitBtn];
        self.tableView.tableFooterView = headVeiw;
    }
 
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)saveBtnClicked
{
    if(input0.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"标题不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input1.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"地点不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input2.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    [self.m_info setObject:input0.text forKey:@"subject"];
    [self.m_info setObject:input1.text forKey:@"place"];
    [self.m_info setObject:input2.text forKey:@"content"];
    [self.m_info setObject:input3.text forKey:@"startTime"];
    [self.m_info setObject:input4.text forKey:@"endTime"];
    [self.m_info setObject:input5.text forKey:@"remindTime"];
    [self.m_info setObject:[NSNumber numberWithBool:smsbtn.selected ? true : false]  forKey:@"sms"];
    
    [self showWaitingView];
    if(self.m_isAdd)
    {
        [HTTP_MANAGER saveSchdule:self.m_info
                   successedBlock:^(NSDictionary *succeedResult) {
                       
                       [self removeWaitingView];
                       NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                       if([ret[@"resultCode"] integerValue] == 0)
                       {
                           [self.m_delegate onNeedRefreshTableView];
                           [PubllicMaskViewHelper showTipViewWith:@"保存成功" inSuperView:self.view withDuration:1];
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                       else
                       {
                           
                       }
                       
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"保存成功" inSuperView:self.view withDuration:1];
                   }];
    }
    else
    {
        [HTTP_MANAGER modifySchdule:self.m_info
                   successedBlock:^(NSDictionary *succeedResult) {
                       
                       
                       [self removeWaitingView];
                       NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                       if([ret[@"resultCode"] integerValue] == 0)
                       {
                           [self.m_delegate onNeedRefreshTableView];
                           [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view withDuration:1];
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                       else
                       {
                           [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                       }
                       
                       
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                   }];
    }

}



- (void)deleteBtnClicked
{
    [self showWaitingView];
    [HTTP_MANAGER deleteSchdule:self.m_info
                 successedBlock:^(NSDictionary *succeedResult) {
                     
                     [self removeWaitingView];
                     NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                     if([ret[@"resultCode"] integerValue] == 0)
                     {
                         [self.m_delegate onNeedRefreshTableView];
                         [PubllicMaskViewHelper showTipViewWith:@"删除成功" inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                     }
                     else
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];
                     }
                     
                     
                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];
                 }];
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



#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 40;
    }
    else if (indexPath.row == 1)
    {
        return 40;
    }
    else if (indexPath.row == 2)
    {
        return 200;
    }
    else if (indexPath.row == 3)
    {
        return 40;
    }
    else if (indexPath.row == 4)
    {
        return 40;
        
    }else if (indexPath.row == 5)
    {
        return 40;
    }
    else
    {
        return 40;
    }
    return    0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(indexPath.row == 0)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 10, 80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"主    题:"];
        [cell addSubview:tip];
        
        input0 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 20)];
        [input0 setText:self.m_isAdd ? @"" : self.m_info[@"subject"]];
        [cell addSubview:input0];
        

    }
    else if (indexPath.row == 1)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 10,80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"地    点:"];
        [cell addSubview:tip];
        
        input1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 20)];
        [input1 setText:self.m_isAdd ? @"" : self.m_info[@"place"]];
        [cell addSubview:input1];
    }
    else if (indexPath.row == 2)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 90, 80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"内    容:"];
        [cell addSubview:tip];
        
        input2 = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 180)];
        input2.backgroundColor = UIColorFromRGB(0xededed);
        input2.layer.cornerRadius = 3;
        input2.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        [input2 setText:self.m_isAdd ? @"" : self.m_info[@"content"]];
        [cell addSubview:input2];
    }
    else if (indexPath.row == 3)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 10, 80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"开始时间:"];
        [cell addSubview:tip];
        
        input3 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 20)];
        [input3 setTextColor:UIColorFromRGB(0x787878)];
        [input3 setFont:[UIFont systemFontOfSize:14]];
        [input3 setText:self.m_info[@"startTime"]];
        [cell addSubview:input3];
        
        
        UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
        [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
        [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:confirmBtn];
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
        picker.tag = indexPath.row;
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [inputBg addSubview:picker];
        input3.inputView = inputBg;
    }
    else if (indexPath.row == 4)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 10, 80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"结束时间:"];
        [cell addSubview:tip];
        
        input4= [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 20)];
        [input4 setTextColor:UIColorFromRGB(0x787878)];
        [input4 setFont:[UIFont systemFontOfSize:14]];
        [input4 setText:self.m_info[@"endTime"]];
        [cell addSubview:input4];
        
        
        UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
        [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
        [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:confirmBtn];
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
        picker.tag = indexPath.row;
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [inputBg addSubview:picker];
        input4.inputView = inputBg;
        
    }else if (indexPath.row == 5)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(2, 10, 80, 20)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setText:@"提醒时间:"];
        [cell addSubview:tip];
        
        input5= [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, 10, MAIN_WIDTH-15-CGRectGetMaxX(tip.frame), 20)];
        [input5 setTextColor:UIColorFromRGB(0x787878)];
        [input5 setFont:[UIFont systemFontOfSize:14]];
        [input5 setText:self.m_info[@"remindTime"]];
        [cell addSubview:input5];
        
        UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
        [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
        [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:confirmBtn];
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
        picker.tag = indexPath.row;
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [inputBg addSubview:picker];
        input5.inputView = inputBg;
    }
    else
    {
        smsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [smsbtn addTarget:self action:@selector(sendSmsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [smsbtn setFrame:CGRectMake(10, 5, 100, 30)];
        [smsbtn setTitle:@"短信发送" forState:UIControlStateNormal];
        smsbtn.selected = [self.m_info[@"sms"] boolValue] == YES;
        [smsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [smsbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [smsbtn setImage:[UIImage imageNamed:@"register_check_on@3x"] forState:UIControlStateSelected];
        [smsbtn setImage:[UIImage imageNamed:@"register_check_un@3x"] forState:UIControlStateNormal];
        [smsbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 30)];
        [cell addSubview:smsbtn];
    }
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)cancelBtnClicked:(UITextField *)input
{
    [input3 resignFirstResponder];
    [input4 resignFirstResponder];
    [input5 resignFirstResponder];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    [input3 resignFirstResponder];
    [input4 resignFirstResponder];
    [input5 resignFirstResponder];
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith2:[picker date]];
            if(picker.tag == 3)
            {
                [self.m_info setObject:time forKey:@"startTime"];
              
            }
            else if (picker.tag == 4)
            {
                 [self.m_info setObject:time forKey:@"endTime"];
            }
            else
            {
                 [self.m_info setObject:time forKey:@"remindTime"];
            }
              [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:picker.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


- (void)sendSmsBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
}






@end
