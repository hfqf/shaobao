//
//  AddNewMeetingViewController.m
//  jianye
//
//  Created by points on 2017/2/13.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNewMeetingViewController.h"
#import "MeetingSelectRoomViewController.h"
@interface AddNewMeetingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MeetingSelectRoomViewControllerDelegate>
{
    
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
    UITextField *m_input4;
    UILabel *m_input5;
    UITextField *m_input6;
    UITextField *m_input7;
    UITextField *m_input8;
    UITextField *m_input9;
    UITextField *m_input10;
    
    BOOL    m_isCanPushSelectRoom;
}
@property(nonatomic,strong) NSString *input1;
@property(nonatomic,strong) NSString *input2;
@property(nonatomic,strong) NSString *input3;
@property(nonatomic,strong) NSString *input4;
@property(nonatomic,strong) NSString *input5;
@property(nonatomic,strong) NSString *input6;
@property(nonatomic,strong) NSString *input7;
@property(nonatomic,strong) NSString *input8;
@property(nonatomic,strong) NSString *input9;
@property(nonatomic,strong) NSString *input10;


@property(nonatomic,assign) NSInteger tableSetType;
@property(nonatomic,strong) NSArray *arrMeetingSetType;
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,assign) BOOL isLarge;
@property(nonatomic,strong) NSString *demand;
@property(nonatomic,strong) NSDictionary *m_roomInfo;



@end

@implementation AddNewMeetingViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"申请"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    m_isCanPushSelectRoom = YES;
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,15,100, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont systemFontOfSize:14]];
    [tip setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip];
    
    if(indexPath.row == 0){
        [tip setText:@"登记日期:"];
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input1.delegate= self;
        [m_input1 setInputView:[self getSelectTimePicker:indexPath]];
        m_input1.text = self.input1;
        [m_input1 setTextAlignment:NSTextAlignmentLeft];
        [m_input1 setTextColor:[UIColor blackColor]];
        [m_input1 setFont:[UIFont systemFontOfSize:14]];
        [m_input1 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input1];
    }
    else if (indexPath.row == 1){
        [tip setText:@"会议主题:"];
        
        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input2.delegate= self;
        m_input2.text = self.input2;
        [m_input2 setTextAlignment:NSTextAlignmentLeft];
        [m_input2 setTextColor:[UIColor blackColor]];
        [m_input2 setFont:[UIFont systemFontOfSize:14]];
        [m_input2 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input2];
        m_input2.returnKeyType = UIReturnKeyDone;

    }
    else if (indexPath.row == 2){
        [tip setText:@"开始时间:"];
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input3.delegate= self;
        m_input3.text = self.input3;
        [m_input3 setTextAlignment:NSTextAlignmentLeft];
        [m_input3 setTextColor:[UIColor blackColor]];
        [m_input3 setFont:[UIFont systemFontOfSize:14]];
        [m_input3 setBackgroundColor:[UIColor clearColor]];
        [m_input3 setInputView:[self getSelectTimePicker:indexPath]];
        [cell addSubview:m_input3];
    }
    else if (indexPath.row == 3){
        [tip setText:@"结束时间:"];
        
        m_input4 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input4.delegate= self;
        m_input4.text = self.input4;
        [m_input4 setTextAlignment:NSTextAlignmentLeft];
        [m_input4 setTextColor:[UIColor blackColor]];
        [m_input4 setFont:[UIFont systemFontOfSize:14]];
        [m_input4 setBackgroundColor:[UIColor clearColor]];
        [m_input4 setInputView:[self getSelectTimePicker:indexPath]];
        [cell addSubview:m_input4];

    }
    else if (indexPath.row == 4){
        [tip setText:@"会议地点:"];
        m_input5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 0, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 50)];
        [m_input5 setTextAlignment:NSTextAlignmentLeft];
        [m_input5 setText:self.input5];
        [m_input5 setFont:[UIFont systemFontOfSize:14]];
        [m_input5 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input5];
    }
    else if (indexPath.row == 5){
        [tip setText:@"联 系 人:"];
        
        m_input6 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input6.delegate= self;
        m_input6.text = self.input6;
        [m_input6 setTextAlignment:NSTextAlignmentLeft];
        [m_input6 setTextColor:[UIColor blackColor]];
        [m_input6 setFont:[UIFont systemFontOfSize:14]];
        [m_input6 setBackgroundColor:[UIColor clearColor]];
        m_input6.returnKeyType = UIReturnKeyDone;
        [cell addSubview:m_input6];
    }
    else if (indexPath.row == 6){
        [tip setText:@"联系电话:"];
        
        m_input7 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input7.delegate= self;
        m_input7.text = self.input7;
        m_input7.returnKeyType = UIReturnKeyDone;
        [m_input7 setTextAlignment:NSTextAlignmentLeft];
        [m_input7 setTextColor:[UIColor blackColor]];
        [m_input7 setFont:[UIFont systemFontOfSize:14]];
        [m_input7 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input7];
    }
    else if (indexPath.row == 7){
        [tip setText:@"会议人数:"];
        
        m_input8 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input8.delegate= self;
        m_input8.text = self.input8;
        [m_input8 setTextAlignment:NSTextAlignmentLeft];
        [m_input8 setTextColor:[UIColor blackColor]];
        [m_input8 setFont:[UIFont systemFontOfSize:14]];
        [m_input8 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input8];
    }
    else if (indexPath.row == 8){
        [tip setText:@"主办单位:"];
        
        m_input9 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input9.delegate= self;
        m_input9.text = [LoginUserUtil orgName];
        [m_input9 setTextAlignment:NSTextAlignmentLeft];
        [m_input9 setTextColor:[UIColor blackColor]];
        [m_input9 setFont:[UIFont systemFontOfSize:14]];
        [m_input9 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input9];
        m_input9.returnKeyType = UIReturnKeyDone;

    }
    else if (indexPath.row == 9){
        [tip setText:@"会议要求:"];
        
        
        m_input10 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)-20, 15, MAIN_WIDTH-CGRectGetMaxX(tip.frame)-20, 20)];
        m_input10.delegate= self;
        m_input10.text = self.input10;
        [m_input10 setTextAlignment:NSTextAlignmentLeft];
        [m_input10 setTextColor:[UIColor blackColor]];
        [m_input10 setFont:[UIFont systemFontOfSize:14]];
        [m_input10 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input10];
        m_input10.returnKeyType = UIReturnKeyDone;

    }
    else if (indexPath.row == 10){
        [tip setText:@"桌椅安排:"];
        NSInteger type = self.tableSetType;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"课桌型" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(100, 5, 80, 40)];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setImage:[UIImage imageNamed:type == 1? @"checkbox_checked" : @"checkbox_unchecked"] forState:UIControlStateNormal];
        [cell addSubview:btn1];
        
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn2 setTitle:@"口字型" forState:UIControlStateNormal];
        [btn2 setFrame:CGRectMake(220, 5, 80, 40)];
        [btn2 setImage:[UIImage imageNamed:type == 2? @"checkbox_checked" : @"checkbox_unchecked"] forState:UIControlStateNormal];
        [cell addSubview:btn2];
        
    }
    else if (indexPath.row == 11){
        [tip setText:@"会议布置要求:"];
        BOOL is1 = [self.arrMeetingSetType containsObject:@"7"];
        BOOL is2 = [self.arrMeetingSetType containsObject:@"2"];
        BOOL is3 = [self.arrMeetingSetType containsObject:@"5"];
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"会标" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(100, 5, 60, 40)];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:btn1];
        
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn2 setTitle:@"话筒" forState:UIControlStateNormal];
        [btn2 setFrame:CGRectMake(170, 5, 60, 40)];
        [cell addSubview:btn2];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn3.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn3 setTitle:@"投影仪" forState:UIControlStateNormal];
        [btn3 setFrame:CGRectMake(240, 5, 80, 40)];
        [cell addSubview:btn3];
        
        [btn1 setImage:[UIImage imageNamed:is1 ?  @"checkbox_checked": @"checkbox_unchecked"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:is2 ?  @"checkbox_checked": @"checkbox_unchecked"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:is3 ?  @"checkbox_checked": @"checkbox_unchecked"] forState:UIControlStateNormal];
        
    }
    else if (indexPath.row == 12){
        [tip setText:@"是否公开:"];
        
        BOOL isNoOpen = self.isOpen;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(openBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:@"不公开" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(100, 5, 80, 40)];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setImage:[UIImage imageNamed:isNoOpen? @"checkbox_checked" : @"checkbox_unchecked"] forState:UIControlStateNormal];
        [cell addSubview:btn1];
    }
    else if (indexPath.row == 13){
        [tip setText:@"大型会议:"];
        
        BOOL isLarge = self.isLarge;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(largeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:@"是" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(80, 5, 80, 40)];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setImage:[UIImage imageNamed:isLarge? @"checkbox_checked" : @"checkbox_unchecked"] forState:UIControlStateNormal];
        [cell addSubview:btn1];
    }
    else{
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"提交" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(5, 5,MAIN_WIDTH-10, 40)];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
        [cell addSubview:btn1];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4){
        [self selectRoom];
    }
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
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [inputBg addSubview:picker];
    return inputBg;
}

- (void)cancelBtnClicked:(UITextField *)input
{
    [input resignFirstResponder];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    [input resignFirstResponder];

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
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                self.input1 = dateString;
            }else if (picker.tag == 2)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                self.input3 = dateString;
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                if([LocalTimeUtil isValid2:self.input3 endTime:dateString])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self.tableView withDuration:1];
                }
                else
                {
                    self.input4 = dateString;
                    m_isCanPushSelectRoom = NO;
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == m_input2)
    {
        self.input2 = textField.text;
    }
    else if (textField == m_input6)
    {
        self.input6 = textField.text;
    }
    else if (textField == m_input7)
    {
        self.input7 = textField.text;
    }
    else if (textField == m_input8)
    {
        self.input8 = textField.text;
    }
    else if (textField == m_input10)
    {
        self.input10 = textField.text;
    }
    
    return YES;
}

- (void)selectRoom
{
    if(self.input3.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input4.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能为空" inSuperView:self.view  withDuration:1];
        return ;
    }
    
    
    MeetingSelectRoomViewController *addVc = [[MeetingSelectRoomViewController alloc]initWithStartTime:self.input3 endTime:self.input4];
    addVc.m_selectDelegate = self;
    [self.navigationController pushViewController:addVc animated:YES];
}



#pragma mark - MeetingSelectRoomViewControllerDelegate

- (void)onSelectedRoom:(NSDictionary *)info
{
    self.m_roomInfo = info;
    self.input5 = info[@"roomAddress"];
    
    NSString *tableType = [info[@"tableSetType"]substringToIndex:1];
    self.tableSetType = [tableType integerValue];
    self.demand = info[@"facilityInfo"];
    NSArray *arrMeetingType = [info[@"facilityInfo"]componentsSeparatedByString:@","];
    self.arrMeetingSetType = arrMeetingType;
    [self reloadDeals];
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


- (void)openBtnClicked
{
    self.isOpen = !self.isOpen;
    [self reloadDeals];
}


- (void)largeBtnClicked
{
    self.isLarge = !self.isLarge;
    [self reloadDeals];
}


- (void)saveBtnClicked
{
    if(self.input1.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"登记时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input2.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"会议主题不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input3.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input4.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input5.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"会议地点不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input6.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"联系人不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input7.length != 11)
    {
        [PubllicMaskViewHelper showTipViewWith:@"联系电话位数不对" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input8.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"会议人数不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    NSInteger reqPeopleNum = [self.m_roomInfo[@"peolpeNum"]integerValue];
    if(self.input8.integerValue > reqPeopleNum)
    {
        [PubllicMaskViewHelper showTipViewWith:@"参会人数不能大于会议室人数，请重新选择会议室" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input10.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"会议要求不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    [self showWaitingView];
    

    [HTTP_MANAGER applyMeetingRoomWithApplyDate:[LocalTimeUtil getTimestamp1:self.input1]
                                    applyStatus:[NSNumber numberWithInteger:1]
                                    auditUserId:[LoginUserUtil userId]
                                   cancelStatus:[NSNumber numberWithInteger:0]
                                   cancelUserId:[NSNumber numberWithInteger:1]
                                       contacts:self.input6
                                    contactsTel:self.input7
                                     createDate:[LocalTimeUtil getTimestamp1:self.input1]
                                   createDeptId:[LoginUserUtil deptId]
                                 createDeptName:[LoginUserUtil deptName]
                                    createOrgId:[LoginUserUtil orgId]
                                  createOrgName:[LoginUserUtil orgName]
                                   createUserId:[LoginUserUtil userId]
                                 createUserName:[LoginUserUtil userName]
                                       hostUnit:[LoginUserUtil orgName]
                                      isConfirm:[NSNumber numberWithInteger:0]
                                        isLarge:[NSNumber numberWithInteger:self.isLarge ? 1 : 0]
                                         isOpen:[NSNumber numberWithInteger:self.isOpen ? 1 : 0]
                                        leaders:@""
                                 meetingDateEnd:[LocalTimeUtil getTimestamp1:self.input4]
                               meetingDateStart:[LocalTimeUtil getTimestamp1:self.input3]
                                  meetingDemand:self.demand
                                    meetingName:self.input2
                                   noticeStatus:[NSNumber numberWithInteger:0]
                                      peolpeNum:self.input8
                                    roomAddress:self.m_roomInfo[@"roomAddress"]
                                         roomId:self.m_roomInfo[@"roomId"]
                                  specialDemand:self.input10
                                   tableSetType:[NSString stringWithFormat:@"%ld,",self.tableSetType]
                                      useStatus:[NSNumber numberWithInteger:0]
                                 successedBlock:^(NSDictionary *succeedResult) {
                                     
                                     
                                     [self removeWaitingView];
                                     if([succeedResult[@"resultCode"] integerValue] == 0)
                                     {
                                         [self.m_delegate onNeedRefreshTableView];
                                         [PubllicMaskViewHelper showTipViewWith:@"申请成功" inSuperView:self.view withDuration:1];
                                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                                     }
                                     else
                                     {
                                         [PubllicMaskViewHelper showTipViewWith:@"申请失败" inSuperView:self.view withDuration:1];
                                     }
    
                                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
    
                                     [self removeWaitingView];
                                     [PubllicMaskViewHelper showTipViewWith:@"申请失败" inSuperView:self.view withDuration:1];
                                     
                                 }];
    
}

@end
