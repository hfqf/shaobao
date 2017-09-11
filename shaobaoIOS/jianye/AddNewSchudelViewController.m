//
//  AddNewSchudelViewController.m
//  jianye
//
//  Created by points on 2017/2/22.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNewSchudelViewController.h"

@interface AddNewSchudelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *m_dayInput;
    UITextField *m_startInput;
    UITextField *m_endInput;
    UITextField *m_input3;
    UITextField *m_input4;
    UITextField *m_input5;
    UITextField *m_input6;
    UITextField *m_input7;
    
    
}
@property(nonatomic,strong)NSString *m_day;
@property(nonatomic,strong)NSString *m_start;
@property(nonatomic,strong)NSString *m_end;

@property(nonatomic,strong)NSString *m_week;
@property(nonatomic,strong)NSString *m_year;
@property(nonatomic,strong)NSString *m_id;
@end

@implementation AddNewSchudelViewController


- (id)initWith:(NSString *)week year:(NSString *)year scheduleId:(NSString *)scheduleId
{
    self.m_week = week;
    self.m_year = year;
    self.m_id = [LoginUserUtil get32BitString];
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [title setText:@"新建日程"];
    [self requestData:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
    [self addFooterView];
}

- (void)addFooterView
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 120)];
    [vi setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
    self.tableView.tableFooterView = vi;
    
    UIView *bottom  = [[UIView alloc]initWithFrame:CGRectMake(0,70,MAIN_WIDTH, 50)];
    [bottom setBackgroundColor:UIColorFromRGB(0xFFFFFD)];
    [vi addSubview:bottom];
    bottom.layer.borderColor = UIColorFromRGB(0x7CB5E5).CGColor;
    bottom.layer.borderWidth = 0.5;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(5, 5, MAIN_WIDTH-10, 40)];
    [btn setBackgroundColor:UIColorFromRGB(0x3A97ED)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:YES];
    [bottom addSubview:btn];
}

- (void)confirmBtnClicked
{
    if(self.m_day.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"日期不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.m_start.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.m_end.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(m_input3.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"地点不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(m_input4.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"内容不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(m_input5.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"参会人员不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(m_input6.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"主办单位不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    [self showWaitingView];
    [HTTP_MANAGER addNewDaySchedule:m_input3.text
                          agentDate:self.m_day
                            content:m_input4.text
                            endTime:self.m_end
                       hostUnitName:m_input6.text
                           leaderId:[LoginUserUtil userId]
                         leaderName:[LoginUserUtil userName]
                        participant:m_input5.text
                          startTime:self.m_start
                          whichWeek:self.m_week
                          whichYear:self.m_year
                         scheduleId:self.m_id
                     successedBlock:^(NSDictionary *succeedResult) {
        
                         [self removeWaitingView];
                         NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                         if([ret[@"resultCode"] integerValue] == 0)
                         {
                             [self.m_delegate onNeedRefreshTableView];
                             [PubllicMaskViewHelper showTipViewWith:@"添加成功" inSuperView:self.view withDuration:1];
                             [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                         }
                         else
                         {
                             [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
                         }
                         
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,15,80, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont systemFontOfSize:14]];
    [tip setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip];
    

    if(indexPath.row == 0){
        [tip setText:@"日期:"];

        m_dayInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_dayInput.delegate = self;
        [m_dayInput setTextAlignment:NSTextAlignmentLeft];
        [m_dayInput setTextColor:[UIColor blackColor]];
        [m_dayInput setFont:[UIFont systemFontOfSize:14]];
        [m_dayInput setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_dayInput];
        [m_dayInput setInputView:[self getSelectDayPicker:indexPath]];
        if(self.m_day.length > 0)
        {
            [m_dayInput setText:self.m_day];
        }
    }
    else if (indexPath.row == 1){
        [tip setText:@"开始时间:"];
        
        m_startInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_startInput.delegate = self;
        [m_startInput setTextAlignment:NSTextAlignmentLeft];
        [m_startInput setTextColor:[UIColor blackColor]];
        [m_startInput setFont:[UIFont systemFontOfSize:14]];
        [m_startInput setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_startInput];
        [m_startInput setInputView:[self getSelectTimePicker:indexPath]];
        if(self.m_start.length > 0)
        {
            [m_startInput setText:self.m_start];
        }
    }
    else if (indexPath.row == 2){
        [tip setText:@"结束时间:"];
        
        m_endInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_endInput.delegate = self;
        [m_endInput setTextAlignment:NSTextAlignmentLeft];
        [m_endInput setTextColor:[UIColor blackColor]];
        [m_endInput setFont:[UIFont systemFontOfSize:14]];
        [m_endInput setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_endInput];
        [m_endInput setInputView:[self getSelectTimePicker:indexPath]];
        
        if(self.m_end.length > 0)
        {
            [m_endInput setText:self.m_end];
        }
    }
    else if (indexPath.row == 3){
        [tip setText:@"地点:"];
        
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_input3.delegate = self;
        [m_input3 setTextAlignment:NSTextAlignmentLeft];
        [m_input3 setTextColor:[UIColor blackColor]];
        [m_input3 setFont:[UIFont systemFontOfSize:14]];
        [m_input3 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input3];
    }
    else if (indexPath.row == 4){
        [tip setText:@"内容:"];
        
        m_input4 = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_input4.delegate = self;
        [m_input4 setTextAlignment:NSTextAlignmentLeft];
        [m_input4 setTextColor:[UIColor blackColor]];
        [m_input4 setFont:[UIFont systemFontOfSize:14]];
        [m_input4 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input4];
    }
    else if (indexPath.row == 5){
        [tip setText:@"参会人员:"];
        
        m_input5 = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_input5.delegate = self;
        [m_input5 setTextAlignment:NSTextAlignmentLeft];
        [m_input5 setTextColor:[UIColor blackColor]];
        [m_input5 setFont:[UIFont systemFontOfSize:14]];
        [m_input5 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input5];
    }
    else{
        [tip setText:@"主办单位:"];
        
        m_input6 = [[UITextField alloc]initWithFrame:CGRectMake(100,15,MAIN_WIDTH-120, 20)];
        m_input6.delegate = self;
        [m_input6 setTextAlignment:NSTextAlignmentLeft];
        [m_input6 setTextColor:[UIColor blackColor]];
        [m_input6 setFont:[UIFont systemFontOfSize:14]];
        [m_input6 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input6];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
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


- (UIView *)getSelectDayPicker:(NSIndexPath *)indexPath
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
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH, 140)];
    picker.tag = indexPath.row;
    picker.datePickerMode = UIDatePickerModeDate;
    [inputBg addSubview:picker];
    return inputBg;
}


- (UIView *)getSelectTimePicker:(NSIndexPath *)indexPath
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
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH, 140)];
    picker.tag = indexPath.row;
    picker.datePickerMode = UIDatePickerModeTime;
    [inputBg addSubview:picker];
    return inputBg;
}


- (void)cancelBtnClicked:(UITextField *)input
{
    [m_startInput resignFirstResponder];
    [m_dayInput resignFirstResponder];
    [m_endInput resignFirstResponder];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    [m_startInput resignFirstResponder];
    [m_dayInput resignFirstResponder];
    [m_endInput resignFirstResponder];
    UIView *bg = input.superview;
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            if(picker.tag == 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                self.m_day = dateString;
            }else if (picker.tag == 1)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                self.m_start = dateString;
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                if(![LocalTimeUtil isValid2:m_startInput.text endTime:dateString])
                {
                    self.m_end = nil;
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self.tableView withDuration:1];
                }
                else
                {
                    self.m_end = dateString;
                }
            }
        }
    }
    [self reloadDeals];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
