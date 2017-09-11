//
//  NewAbsenceViewController.m
//  officeMobile
//
//  Created by Points on 15-3-17.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "NewAbsenceViewController.h"
#import "ContactViewController.h"
@interface NewAbsenceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ContactViewControllerDelegate>
{
    UITextField *input0;
    UITextField *input1;
    UITextField *input2;
    UITextField *input3;
    UITextField *input4;
    UITextField *input5;
    UITextField *input6;
    UITextField *input7;
    
    BOOL m_isCommit;
    
}

@property (nonatomic,strong)NSMutableDictionary *m_uploadInfo;

@property (nonatomic,strong)NSString *m_absenceType;

@property (nonatomic,strong)UITextField *m_startInput;

@property (nonatomic,strong)UITextField *m_endInput;

@property (nonatomic,strong)UITextField *m_currentInput;

@property (nonatomic,assign)NSInteger   m_type;

@end

@implementation NewAbsenceViewController

- (id)initWithInfo:(NSDictionary *)info withType:(NSInteger)type
{
    self.m_type = type;
    self.m_info = [NSMutableDictionary dictionaryWithDictionary:info];
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.m_uploadInfo = [NSMutableDictionary dictionary];
        if(self.m_info)
        {
            [self.m_uploadInfo setObject:[self.m_info  stringWithFilted:@"id"] forKey:@"id"];
        
        }
        self.m_absenceType = @"事假";
        [self.m_uploadInfo setObject:@"事假" forKey:@"3"];
        self.m_absenceType = @"事假";
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_info.allKeys.count > 0 ? self.m_info[@"subject"] : @"请假申请"];
    [self reloadDeals];
    UIView *headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 50)];
    
    if(self.m_type == 2)
    {
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn addTarget:self action:@selector(saveBtnClickde) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setFrame:CGRectMake((MAIN_WIDTH/2)-80, 10, 60, 30)];
        [saveBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        saveBtn.layer.borderWidth = 0.5;
        saveBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        saveBtn.layer.cornerRadius = 4;
        [headVeiw addSubview:saveBtn];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, 60, 30)];
        [commitBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        commitBtn.layer.borderWidth = 0.5;
        commitBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        commitBtn.layer.cornerRadius = 4;
        [headVeiw addSubview:commitBtn];
        self.tableView.tableFooterView = headVeiw;

    }
    else
    {
        if([self.m_info[@"status"]integerValue] == 0)
        {
            [self.m_uploadInfo setObject:[self.m_info stringWithFilted:@"id"] forKey:@"id"];
            int width = 40;
            UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [saveBtn addTarget:self action:@selector(saveBtnClickde) forControlEvents:UIControlEventTouchUpInside];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            [saveBtn setFrame:CGRectMake((MAIN_WIDTH/2)-width*2-20, 10, width, 30)];
            [saveBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            saveBtn.layer.borderWidth = 0.5;
            saveBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
            saveBtn.layer.cornerRadius = 4;
            [headVeiw addSubview:saveBtn];
            
            UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [commitBtn setFrame:CGRectMake((MAIN_WIDTH/2)-20, 10, width, 30)];
            [commitBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            commitBtn.layer.borderWidth = 0.5;
            commitBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
            commitBtn.layer.cornerRadius = 4;
            [headVeiw addSubview:commitBtn];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
            [cancelBtn setFrame:CGRectMake((MAIN_WIDTH-40)/2+width+40, 10, 60, 30)];
            [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            cancelBtn.layer.borderWidth = 0.5;
            cancelBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
            cancelBtn.layer.cornerRadius = 4;
            [headVeiw addSubview:cancelBtn];
            self.tableView.tableFooterView = headVeiw;
            
        }
        else if([self.m_info[@"status"]integerValue] == 2)
        {
            [self.m_uploadInfo setObject:[self.m_info stringWithFilted:@"id"] forKey:@"id"];
            if([self.m_info[@"userId"]integerValue] == [[LoginUserUtil userId] integerValue] )
            {
                UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
                [cancelBtn setFrame:CGRectMake(MAIN_WIDTH/2-20, 10, 40, 30)];
                [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                cancelBtn.layer.borderWidth = 0.5;
                cancelBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                cancelBtn.layer.cornerRadius = 4;
                [headVeiw addSubview:cancelBtn];
                self.tableView.tableFooterView = headVeiw;
            }
            else
            {
                [self.m_uploadInfo setObject:[self.m_info stringWithFilted:@"id"] forKey:@"id"];
                UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [commitBtn addTarget:self action:@selector(agreeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [commitBtn setTitle:@"通过" forState:UIControlStateNormal];
                [commitBtn setFrame:CGRectMake((MAIN_WIDTH/2)-100, 10, 60, 30)];
                [commitBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                commitBtn.layer.borderWidth = 0.5;
                commitBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                commitBtn.layer.cornerRadius = 4;
                [headVeiw addSubview:commitBtn];
                
                UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelBtn addTarget:self action:@selector(disagreeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [cancelBtn setTitle:@"不通过" forState:UIControlStateNormal];
                [cancelBtn setFrame:CGRectMake(MAIN_WIDTH/2+40, 10, 60, 30)];
                [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                cancelBtn.layer.borderWidth = 0.5;
                cancelBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                cancelBtn.layer.cornerRadius = 4;
                [headVeiw addSubview:cancelBtn];
                self.tableView.tableFooterView = headVeiw;
                
            }
            
        }
        else if([self.m_info[@"status"]integerValue] == 1)
        {
            
        }
        else if([self.m_info[@"status"]integerValue] == -1)
        {
            
        }
        else
        {
            
        }
    }
  



}

- (void)agreeBtnClicked
{
    [self allResignFirstResponder];
    [self.m_uploadInfo setObject:self.m_info.allKeys.count == 0 ? @"" : [self.m_info stringWithFilted:@"id"] forKey:@"id"];
    [HTTP_MANAGER agreeAbsence:self.m_uploadInfo
               successedBlock:^(NSDictionary *retDic){
                   if([retDic[@"resultCode"]integerValue] == 0)
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"操作成功" inSuperView:self.view withDuration:1];
                       [self.m_delegate onNeedRefreshTableView:1];
                       [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                        ];
                   }
                   else
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                       
                   }
                   
               } failedBolck:FAILED_BLOCK{
                   
                   
                   [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   
                   
               }];
}

- (void)disagreeBtnClicked
{
    [self allResignFirstResponder];
    
   NSString * tit = [input7.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if(tit.length == 0 || [tit isEqualToString:@" "] )
    {
        [PubllicMaskViewHelper showTipViewWith:@"意见不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    [self.m_uploadInfo setObject:self.m_info.allKeys.count == 0 ? @"" : [self.m_info stringWithFilted:@"id"] forKey:@"id"];

    [HTTP_MANAGER disagree:self.m_uploadInfo
                successedBlock:^(NSDictionary *retDic){
                    if([retDic[@"resultCode"]integerValue] == 0)
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"操作成功" inSuperView:self.view withDuration:1];
                        [self.m_delegate onNeedRefreshTableView:1];
                        [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                         ];
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                        
                    }
                    
                } failedBolck:FAILED_BLOCK{
                    
                    
                    [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                    
                    
                }];
}

- (void)cancelBtnClicked
{
    [self allResignFirstResponder];
    [HTTP_MANAGER deleAbense:self.m_info[@"id"]
               successedBlock:^(NSDictionary *retDic){
                   if([retDic[@"resultCode"]integerValue] == 0)
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"撤销成功" inSuperView:self.view withDuration:1];
                       [self.m_delegate onNeedRefreshTableView];
                       [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                        ];
                   }
                   else
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"撤销失败" inSuperView:self.view withDuration:1];
                       
                   }
                   
               } failedBolck:FAILED_BLOCK{
                   
                   
                   [PubllicMaskViewHelper showTipViewWith:@"撤销失败" inSuperView:self.view withDuration:1];
                   
                   
               }];
}

- (void)saveBtnClickde
{
    [self allResignFirstResponder];
    m_isCommit = NO;
    if(input2.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"标题不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input3.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"类型不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input4.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"事由不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input6.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(![LocalTimeUtil isValid:input5.text endTime:input6.text])
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于开始时间" inSuperView:self.view withDuration:1];
        return;
    }

 
    [self reloadDeals];
    
    
    [HTTP_MANAGER saveAbsence:self.m_uploadInfo
               successedBlock:^(NSDictionary *retDic){
                   if([retDic[@"resultCode"]integerValue] == 0)
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"保存成功" inSuperView:self.view withDuration:1];
                       [self.m_delegate onNeedRefreshTableView:0];
                       [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                        ];
                   }
                   else
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];
                       
                   }
                   
               } failedBolck:FAILED_BLOCK{
               
               
                   [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];

                   
               }];
}

- (void)commitBtnClicked
{
    [self allResignFirstResponder];
    m_isCommit = YES;
    if(input2.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"标题不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input3.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"类型不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input4.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"事由不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input6.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(![LocalTimeUtil isValid:input5.text endTime:input6.text])
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于开始时间" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(input7.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"意见不可为空" inSuperView:self.view withDuration:1];
        return;
    }
    ContactViewController *vc = [[ContactViewController alloc]initForSelectSingleContact];
    vc.m_selectDelegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"请假时间:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"请假时间:"];
        [cell addSubview:titleLab];
        
        input0 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input0.returnKeyType = UIReturnKeyDone;
        input0.tag = indexPath.row;
        NSString *time = [LocalTimeUtil getCurrentTime];
        if(time.length > 10)
        {
            time = [time substringToIndex:10];
        }
        
        if(self.m_type == 2)
        {
            [input0 setText:time];
        }
        else
        {
            [input0 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"absenceDate"] : time];

        }
        
        
        
        input0.delegate = self;
        [input0 setFont:[UIFont systemFontOfSize:14]];
        [input0 setTextColor:[UIColor blackColor]];
        [cell addSubview:input0];
    }
    else if (indexPath.row == 1)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"申请人名称:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"申请人名称:"];
        [cell addSubview:titleLab];
        
        input1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input1.delegate = self;
        input1.returnKeyType = UIReturnKeyDone;
        if(self.m_type == 2)
        {
            [input1 setText:[LoginUserUtil nameOfCurrentLoginer]];
        }
        else
        {
            [input1 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"userName"] : [LoginUserUtil nameOfCurrentLoginer]];
        }
        // [input setText:self.m_info ?self.m_info[@"userName"] : self.m_uploadInfo[@"1"]];
        input1.tag = indexPath.row;
        [input1 setFont:[UIFont systemFontOfSize:14]];
        [input1 setTextColor:[UIColor blackColor]];
        [cell addSubview:input1];
        [self.m_uploadInfo setObject:input1.text forKey:[NSString stringWithFormat:@"%ld",(long)input1.tag]];
    }
    else if (indexPath.row == 2)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"标题:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"标题:"];
        [cell addSubview:titleLab];
        
        input2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input2.delegate = self;
        input2.returnKeyType = UIReturnKeyDone;

        if(self.m_type == 2)
        {
            [input2 setText:self.m_uploadInfo[@"2"]];
        }
        else
        {
            [input2 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"subject"] : self.m_uploadInfo[@"2"]];

        }

        input2.tag = indexPath.row;
        [input2 setFont:[UIFont systemFontOfSize:14]];
        [input2 setTextColor:[UIColor blackColor]];
        [cell addSubview:input2];
        [self.m_uploadInfo setObject:input2.text forKey:[NSString stringWithFormat:@"%ld",(long)input2.tag]];
    }
    else if (indexPath.row == 3)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"类型:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"类型:"];
        [cell addSubview:titleLab];
        
        input3 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input3.delegate = self;
        input3.returnKeyType = UIReturnKeyDone;
        
        if(self.m_type == 2)
        {
             [input3 setText:self.m_absenceType];
        }
        else
        {
            [input3 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"absenceType"] : self.m_absenceType];
        }
        input3.tag = indexPath.row;
        [input3 setFont:[UIFont systemFontOfSize:14]];
        [input3 setTextColor:[UIColor blackColor]];
        [cell addSubview:input3];
        [self.m_uploadInfo setObject:input3.text forKey:[NSString stringWithFormat:@"%ld",(long)input3.tag]];
    }
    else if (indexPath.row == 4)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"事由:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"事由:"];
        [cell addSubview:titleLab];
        
        input4 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input4.delegate = self;
        input4.tag = indexPath.row;
        input4.returnKeyType = UIReturnKeyDone;
        
        if(self.m_type == 2)
        {
            [input4 setText:self.m_uploadInfo[@"4"]];
        }
        else
        {
            [input4 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"absenceRemark"] : self.m_uploadInfo[@"4"]];
        }
        [input4 setFont:[UIFont systemFontOfSize:14]];
        [input4 setTextColor:[UIColor blackColor]];
        [cell addSubview:input4];
        [self.m_uploadInfo setObject:input4.text forKey:[NSString stringWithFormat:@"%ld",(long)input4.tag]];
    }
    else if (indexPath.row == 5)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"开始时间:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"开始时间:"];
        [cell addSubview:titleLab];
        
        input5 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input5.delegate = self;
        input5.returnKeyType = UIReturnKeyDone;
        input5.tag = indexPath.row;
        
        if(self.m_type == 2)
        {
            
            NSString *time = self.m_uploadInfo[@"5"];
            [input5 setText:time == nil ? [LocalTimeUtil getCurrentTime] : time];
        }
        else
        {
            [input5 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"absenceStartDate"] : [LocalTimeUtil getCurrentTime]];
        }
        [input5 setFont:[UIFont systemFontOfSize:14]];
        [input5 setTextColor:[UIColor blackColor]];
        [cell addSubview:input5];
        
        UILabel *selecteLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-80, 10,80, 20)];
        [selecteLab setTextColor:KEY_COMMON_CORLOR];
        [selecteLab setFont:[UIFont boldSystemFontOfSize:14]];
        [selecteLab setBackgroundColor:[UIColor clearColor]];
        [selecteLab setText:@"选择日期"];
        [cell addSubview:selecteLab];
        [self.m_uploadInfo setObject:input5.text forKey:[NSString stringWithFormat:@"%ld",(long)input5.tag]];
        
    }
    else if (indexPath.row == 6)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"结束时间:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"结束时间:"];
        [cell addSubview:titleLab];
        
        input6 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input6.delegate = self;
        input6.returnKeyType = UIReturnKeyDone;
        
        if(self.m_type == 2)
        {
            [input6 setText:self.m_uploadInfo[@"6"]];
        }
        else
        {
            [input6 setText:self.m_info.allKeys.count > 0 ?self.m_info[@"absenceEndDate"] : self.m_uploadInfo[@"6"]];
        }
        input6.tag = indexPath.row;
        [input6 setFont:[UIFont systemFontOfSize:14]];
        [input6 setTextColor:[UIColor blackColor]];
        [cell addSubview:input6];
        
        UILabel *selecteLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-80, 10,80, 20)];
        [selecteLab setTextColor:KEY_COMMON_CORLOR];
        [selecteLab setFont:[UIFont boldSystemFontOfSize:14]];
        [selecteLab setBackgroundColor:[UIColor clearColor]];
        [selecteLab setText:@"选择日期"];
        [cell addSubview:selecteLab];
        [self.m_uploadInfo setObject:input6.text forKey:[NSString stringWithFormat:@"%ld",(long)input6.tag]];
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:@"意见:" withFont:[UIFont boldSystemFontOfSize:12]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:@"意见:"];
        [cell addSubview:titleLab];
        
        input7 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+5, 12, MAIN_WIDTH-(CGRectGetMaxX(titleLab.frame)+5), 15)];
        input7.delegate = self;
        input7.tag = indexPath.row;
        input7.returnKeyType = UIReturnKeyDone;
        if(self.m_type == 2)
        {
            [input7 setText:self.m_uploadInfo[@"7"]];
        }
        else
        {
            [input7 setText:self.m_info.allKeys.count > 0 ?[self.m_info stringWithFilted:@"opinion"] : self.m_uploadInfo[@"7"]];

        }
        [input7 setFont:[UIFont systemFontOfSize:14]];
        [input7 setTextColor:[UIColor blackColor]];
        [cell addSubview:input7];
        [self.m_uploadInfo setObject:input7.text forKey:[NSString stringWithFormat:@"%ld",(long)input7.tag]];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, MAIN_WIDTH, 0.5)];
    sep.alpha = 0.2;
    [sep setBackgroundColor:[UIColor grayColor]];
    [cell addSubview:sep];
    return  cell;
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


#pragma mark - 

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.m_currentInput = textField;
     if (textField.tag == 3)
     {
         UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"移动办公" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"事假",@"病假",@"其他", nil];
         [act showInView:self.view];
         return NO;
     }
     else if (textField.tag == 5)
     {
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
         picker.tag = 5;
         picker.datePickerMode = UIDatePickerModeDateAndTime;
         [inputBg addSubview:picker];
         textField.inputView = inputBg;
     }
     else if (textField.tag == 6)
     {
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
         picker.tag = 6;
         picker.datePickerMode = UIDatePickerModeDateAndTime;
         [inputBg addSubview:picker];
         textField.inputView = inputBg;
     }
    else
    {
        
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        
    }
    else if (textField.tag == 1)
    {
        [self.m_uploadInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    }
    else if (textField.tag == 2)
    {
        [self.m_uploadInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    }
    else if (textField.tag == 3)//类型
    {
        [self.m_uploadInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];

    }
    else if (textField.tag == 4)//事由
    {
        [self.m_uploadInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];

    }
    else if (textField.tag == 5)
    {
        
    }
    else if (textField.tag == 6)
    {
        
    }
    else if (textField.tag == 7)
    {
        [self.m_uploadInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    }
    else
    {
        
    }
    self.m_currentInput = nil;
    SpeLog(@"info->%@",self.m_uploadInfo);
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
         [self.m_uploadInfo setObject:@"事假" forKey:@"3"];
         self.m_absenceType = @"事假";
    }
    else if(buttonIndex == 1)
    {
         [self.m_uploadInfo setObject:@"病假" forKey:@"3"];
         self.m_absenceType = @"病假";
    }
    else
    {
         [self.m_uploadInfo setObject:@"其他" forKey:@"3"];
         self.m_absenceType = @"其他";
    }
    if(self.m_info.allKeys.count > 0)
    {
        [self.m_info setObject:self.m_absenceType forKey:@"absenceType"];

    }

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)cancelBtnClicked:(UITextField *)input
{
    [self allResignFirstResponder];
    input5.inputView = nil;
    input6.inputView = nil;

}

- (void)confirmBtnClicked:(UITextField *)input
{
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith3:[picker date]];

            if(picker.tag == 5)
            {
                [self.m_uploadInfo setObject:time forKey:@"5"];
                [self.m_info setObject:time forKey:@"absenceStartDate"];
            }
            else
            {
                [self.m_uploadInfo setObject:time forKey:@"6"];
                [self.m_info setObject:time forKey:@"absenceEndDate"];
            }
            [self allResignFirstResponder];
            input5.inputView = nil;
            input6.inputView = nil;
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:picker.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }

}

- (void)allResignFirstResponder
{
    [input0 resignFirstResponder];
    [input1 resignFirstResponder];
    [input2 resignFirstResponder];
    [input3 resignFirstResponder];
    [input4 resignFirstResponder];
    [input5 resignFirstResponder];
    [input6 resignFirstResponder];
    [input7 resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma MARK - 
- (void)onSelected:(NSArray *)arrContacter
{
    [self showWaitingView];
    ADTContacterInfo *contact = [arrContacter firstObject];
    [self.m_uploadInfo setObject:contact.m_strUserID forKey:@"receiveUserId"];
    [self.m_uploadInfo setObject:contact.m_strUserName forKey:@"receiveUserName"];
    [self.m_uploadInfo setObject:self.m_info.allKeys.count == 0 ? @"" : [self.m_info stringWithFilted:@"id"] forKey:@"id"];
    [HTTP_MANAGER postAbsence:self.m_uploadInfo
               successedBlock:^(NSDictionary *retDic){
                   
                    [self removeWaitingView];
                   if([retDic[@"resultCode"]integerValue] == 0)
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"保存成功" inSuperView:self.view withDuration:1];
                       [self.m_delegate onNeedRefreshTableView:m_isCommit ? 1 : 0];
                       [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                        ];
                   }
                   else
                   {
                       [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];
                       
                   }
                   

                   
               } failedBolck:FAILED_BLOCK{
                   
                   [self removeWaitingView];
                   [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];
                   
                   
               }];
    
}

- (void)backBtnClicked
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
