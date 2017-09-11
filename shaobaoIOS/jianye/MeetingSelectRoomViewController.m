//
//  MeetingSelectRoomViewController.m
//  jianye
//
//  Created by points on 2017/2/26.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "MeetingSelectRoomViewController.h"

@interface MeetingSelectRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *startTimeInput;
    UITextField *endTimeInput;
    
    UITextField *minPersonInput;
    UITextField *maxPersonInput;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    
}
@property(nonatomic,strong) NSString *m_start;
@property(nonatomic,strong) NSString *m_end;
@end

@implementation MeetingSelectRoomViewController

- (id)initWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    self.m_start = startTime;
    self.m_end = endTime;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)requestData:(BOOL)isRefresh
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
    UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 20, 20)];
    [icon1 setImage:[UIImage imageNamed:@"meeting_date"]];
    [vi addSubview:icon1];
    
    startTimeInput = [[UITextField alloc]initWithFrame:CGRectMake(40, 15, MAIN_WIDTH/2-50, 20)];
    [startTimeInput setFont:[UIFont systemFontOfSize:14]];
    [startTimeInput setText:self.m_start];
    [startTimeInput setTextAlignment:NSTextAlignmentLeft];
    [startTimeInput setTextColor:UIColorFromRGB(0xdedede)];
    startTimeInput.inputView = [self getSelectTimePicker:0];
    [vi addSubview:startTimeInput];
    
    UILabel *to1 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 10, 20, 30)];
    [to1 setText:@"至"];
    [to1 setTextColor:UIColorFromRGB(0x7D7D7D)];
    [vi addSubview:to1];
    [to1 setTextAlignment:NSTextAlignmentLeft];
    [to1 setFont:[UIFont systemFontOfSize:20]];
    
    endTimeInput = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+40, 15, MAIN_WIDTH/2-50, 20)];
    [endTimeInput setText:self.m_end];
    [endTimeInput setFont:[UIFont systemFontOfSize:14]];
    [endTimeInput setTextAlignment:NSTextAlignmentLeft];
    [endTimeInput setTextColor:UIColorFromRGB(0xdedede)];
    endTimeInput.inputView = [self getSelectTimePicker:1];
    [vi addSubview:endTimeInput];
    
    UIView *sep1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH, 0.5)];
    [sep1 setBackgroundColor:UIColorFromRGB(0XE7E7E7)];
    [vi addSubview:sep1];
    
    
    UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 65, 20, 20)];
    [icon2 setImage:[UIImage imageNamed:@"meeting_manager"]];
    [vi addSubview:icon2];
    
    minPersonInput = [[UITextField alloc]initWithFrame:CGRectMake(40, 65, MAIN_WIDTH/2-50, 20)];
    [minPersonInput setFont:[UIFont systemFontOfSize:14]];
    [minPersonInput setTextAlignment:NSTextAlignmentLeft];
    [minPersonInput setTextColor:UIColorFromRGB(0xdedede)];
    [vi addSubview:minPersonInput];
    
    UILabel *to2 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 60, 20, 30)];
    [to2 setText:@"至"];
    [to2 setTextColor:UIColorFromRGB(0x7D7D7D)];
    [vi addSubview:to2];
    [to2 setTextAlignment:NSTextAlignmentLeft];
    [to2 setFont:[UIFont systemFontOfSize:20]];
    
    maxPersonInput = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+40, 65, MAIN_WIDTH/2-50, 20)];
    [maxPersonInput setFont:[UIFont systemFontOfSize:14]];
    [maxPersonInput setTextAlignment:NSTextAlignmentLeft];
    [maxPersonInput setTextColor:UIColorFromRGB(0xdedede)];
    [vi addSubview:maxPersonInput];
    
    UIView *sep2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, MAIN_WIDTH, 0.5)];
    [sep2 setBackgroundColor:UIColorFromRGB(0XE7E7E7)];
    [vi addSubview:sep2];
    
    
    NSInteger type = 1;
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"会标" forState:UIControlStateNormal];
    [btn1 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(0, 105, MAIN_WIDTH/3, 40)];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn1 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    [vi addSubview:btn1];
    
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(btn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn2 setTitle:@"话筒" forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(MAIN_WIDTH/3, 105, MAIN_WIDTH/3, 40)];
    [btn2 setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    [vi addSubview:btn2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 addTarget:self action:@selector(btn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateNormal];
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn3 setTitle:@"投影仪" forState:UIControlStateNormal];
    [btn3 setFrame:CGRectMake(MAIN_WIDTH/3*2,105, MAIN_WIDTH/3, 40)];
    [btn3 setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    [vi addSubview:btn3];
    
    UIView *sep3 = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, MAIN_WIDTH, 0.5)];
    [sep3 setBackgroundColor:UIColorFromRGB(0XE7E7E7)];
    [vi addSubview:sep3];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(queryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(5, 155,MAIN_WIDTH-10, 40)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
    [vi addSubview:btn];
    
    self.tableView.tableHeaderView = vi;
   
    
    [self queryBtnClicked];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"选择会议地址"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btn1Clicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)btn2Clicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)btn3Clicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, MAIN_WIDTH/2, 18)];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setTextColor:UIColorFromRGB(0x000000)];
    [tip1 setFont:[UIFont boldSystemFontOfSize:18]];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setText:info[@"roomAddress"]];
    [cell addSubview:tip1];
    
    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, MAIN_WIDTH/2, 18)];
    [tip2 setTextAlignment:NSTextAlignmentLeft];
    [tip2 setTextColor:UIColorFromRGB(0x797979)];
    [tip2 setFont:[UIFont systemFontOfSize:14]];
    [tip2 setBackgroundColor:[UIColor clearColor]];
    [tip2 setText:info[@"manageDept"]];
    [cell addSubview:tip2];
    
    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, MAIN_WIDTH/2, 18)];
    [tip3 setTextAlignment:NSTextAlignmentLeft];
    [tip3 setTextColor:UIColorFromRGB(0x797979)];
    [tip3 setFont:[UIFont systemFontOfSize:14]];
    [tip3 setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip3];
    
    NSArray *arr = [info[@"facilityInfo"]componentsSeparatedByString:@","];
    NSMutableString *str = [NSMutableString string];
    for(NSString *type in arr)
    {
        if(type.length == 0)
        {
            continue;
        }
        NSInteger _type = [type integerValue];
        if(_type == 2)
        {
            [str appendString:@"话筒 "];
        }
        else if(_type == 5)
        {
            [str appendString:@"投影仪 "];
        }
        else if(_type == 7)
        {
            [str appendString:@"会标 "];
        }
            
    }
    [tip3 setText:str];
    
    
    UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 45, 100, 18)];
    [tip4 setTextAlignment:NSTextAlignmentLeft];
    [tip4 setTextColor:UIColorFromRGB(0x797979)];
    [tip4 setFont:[UIFont systemFontOfSize:14]];
    [tip4 setBackgroundColor:[UIColor clearColor]];
    [tip4 setText:[NSString stringWithFormat:@"可容纳%d人",[info[@"peolpeNum"]intValue]]];
    [cell addSubview:tip4];
    
    UILabel *tip5 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-110, 45, 100, 18)];
    [tip5 setTextAlignment:NSTextAlignmentRight];
    [tip5 setText:[NSString stringWithFormat:@"%dmm",[info[@"area"]intValue]]];
    [tip5 setTextColor:UIColorFromRGB(0x797979)];
    [tip5 setFont:[UIFont systemFontOfSize:14]];
    [tip5 setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip5];
    
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 109.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    [self.m_selectDelegate onSelectedRoom:info];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)queryBtnClicked
{
    
    [startTimeInput resignFirstResponder];
    [endTimeInput resignFirstResponder];
    [minPersonInput resignFirstResponder];
    [maxPersonInput resignFirstResponder];
    if(startTimeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(endTimeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    NSMutableString *facilityInfo = [NSMutableString string];
    if(btn1.selected)
    {
        [facilityInfo appendFormat:@"7,"];
    }
    
    if(btn2.selected)
    {
        [facilityInfo appendFormat:@"2,"];
    }
    
    if(btn3.selected)
    {
        [facilityInfo appendFormat:@"5,"];
    }
    
    [self showWaitingView];
    [HTTP_MANAGER getMeetingRooms:startTimeInput.text
                          endTime:endTimeInput.text
                       peopleNum1:minPersonInput.text
                       peopleNum2:maxPersonInput.text
                     facilityInfo:facilityInfo
                   successedBlock:^(NSDictionary *succeedResult) {
                       
                       [self removeWaitingView];
                       NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                       self.m_arrData = ret[@"result"];
                       [self reloadDeals];
                       
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       
                       
                       [self removeWaitingView];
                       
                   }];
}


- (UIView *)getSelectTimePicker:(NSInteger )index
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
    picker.tag = index;
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
                self.m_start = dateString;
                [startTimeInput setText:self.m_start];
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                if([LocalTimeUtil isValid2:self.m_start endTime:dateString])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self.tableView withDuration:1];
                }
                else
                {
                    self.m_end = dateString;
                    [endTimeInput setText:self.m_end];
                }
            }
        }
    }
    [startTimeInput resignFirstResponder];
    [endTimeInput resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == startTimeInput)
    {
        self.m_start = textField.text;
    }
    else
    {
        self.m_end = textField.text;
    }
    
    [self reloadDeals];

    return YES;
}


@end
