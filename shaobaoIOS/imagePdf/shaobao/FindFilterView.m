//
//  FindFilterView.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindFilterView.h"

@implementation FindFilterView

- (id)initWithFrame:(CGRect)frame
{

    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        m_table = [[UITableView alloc]initWithFrame:CGRectMake(60, 64, MAIN_WIDTH-60, MAIN_HEIGHT-64-50-50) style:UITableViewStylePlain];
        m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [m_table setBackgroundColor:[UIColor whiteColor]];
        m_table.dataSource = self;
        m_table.delegate = self;
        [m_table reloadData];
        self.m_type = @"1";
        [self addSubview:m_table];
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetBtn setBackgroundColor:UIColorFromRGB(0x53cfec)];
        [resetBtn addTarget:self action:@selector(resetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [resetBtn setFrame:CGRectMake(60, MAIN_HEIGHT-64-50, (MAIN_WIDTH-60)/2, 50)];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:resetBtn];

        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setBackgroundColor:UIColorFromRGB(0x53cfec)];
        [okBtn addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setFrame:CGRectMake(60+(MAIN_WIDTH-60)/2,MAIN_HEIGHT-64-50, (MAIN_WIDTH-60)/2, 50)];
        [okBtn setTitle:@"确认" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:okBtn];
    }
    return self;
}

- (void)setM_area:(NSMutableDictionary *)m_area
{
    _m_area = m_area;
    [m_table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)high:(NSIndexPath *)indexPath
{
    return indexPath.row == 5 ? 90 : 50;
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
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,18, 120, 18)];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont systemFontOfSize:16]];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:tip];

    if(indexPath.row == 0){
        [tip setText:@"类型"];
        NSInteger widht = 100;
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(sellerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setFrame:CGRectMake(MAIN_WIDTH-widht*2-20-60, 10, widht, [self high:indexPath]-20)];
        [btn1 setTitle:@"商家服务" forState:UIControlStateNormal];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setTitleColor:self.m_isSaller ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn1.layer.cornerRadius = 2;
        btn1.layer.borderColor= self.m_isSaller ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn1.layer.borderWidth = 0.5;
        [cell addSubview:btn1];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 addTarget:self action:@selector(sinalBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setFrame:CGRectMake(MAIN_WIDTH-widht-10-60, 10, widht, [self high:indexPath]-20)];
        [btn2 setTitle:@"个人需求" forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn2 setTitleColor:!self.m_isSaller ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn2.layer.borderColor= !self.m_isSaller ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn2.layer.borderWidth = 0.5;
        [cell addSubview:btn2];

    }else if(indexPath.row == 1){
        [tip setText:@"区域"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-230-60, ([self high:indexPath]-20)/2, 200, 20)];
        [content setTextAlignment:NSTextAlignmentRight];
        [content setFont:[UIFont systemFontOfSize:15]];

        NSDictionary *provice = self.m_area[@"provice"];
        NSDictionary *city = self.m_area[@"city"];
        NSDictionary *area = self.m_area[@"area"];
        [content setText:[NSString stringWithFormat:@"%@ %@ %@",provice == nil ? @"" : [provice stringWithFilted:@"name"],city==nil?@"" :[city stringWithFilted:@"name"],area==nil?@"":[area stringWithFilted:@"name"]]];
        [cell addSubview:content];
        [content setTextColor:UIColorFromRGB(0xcdcdcd)];

    }else if(indexPath.row == 2){
        [tip setText:@"分类"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150-60, ([self high:indexPath]-20)/2, 120, 20)];
        [content setTextAlignment:NSTextAlignmentRight];
        [content setFont:[UIFont systemFontOfSize:15]];
        NSInteger type = self.m_type.integerValue;
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
        [content setTextColor:UIColorFromRGB(0xcdcdcd)];

    }else if(indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [tip setText:@"起始时间"];
        m_startTime =   [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-60-100-30, 15, 100, 20)];
        [m_startTime setFont:[UIFont systemFontOfSize:14]];
        [m_startTime setText:self.m_startTime];
        [m_startTime setTextAlignment:NSTextAlignmentLeft];
        [m_startTime setTextColor:UIColorFromRGB(0xdedede)];
        m_startTime.inputView = [self getSelectTimePicker:0];
        [cell addSubview:m_startTime];
    }else if(indexPath.row == 4){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [tip setText:@"结束时间"];
        m_endTime = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-60-100-30, 15, 100, 20)];
        [m_endTime setFont:[UIFont systemFontOfSize:14]];
        [m_endTime setText:self.m_endTime];
        [m_endTime setTextAlignment:NSTextAlignmentLeft];
        [m_endTime setTextColor:UIColorFromRGB(0xdedede)];
        m_endTime.inputView = [self getSelectTimePicker:1];
        [cell addSubview:m_endTime];
    }else if(indexPath.row == 5){
        [tip setText:@"状态"];

        NSInteger width = (MAIN_WIDTH-60-100-40)/3;

        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 0;
        [btn1 addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setFrame:CGRectMake(110, 10, width,30)];
        [btn1 setTitle:@"未支付" forState:UIControlStateNormal];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn1 setTitleColor:self.m_state.integerValue == 0 ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn1.layer.cornerRadius = 2;
        btn1.layer.borderColor= self.m_state.integerValue == 0 ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn1.layer.borderWidth = 0.5;
        [cell addSubview:btn1];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 1;
        [btn2 addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, 10, width,30)];
        [btn2 setTitle:@"已支付" forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn2 setTitleColor:self.m_state.integerValue == 1 ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn2.layer.borderColor= self.m_state.integerValue == 1 ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn2.layer.borderWidth = 0.5;
        [cell addSubview:btn2];

        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 2;
        [btn3 addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+10, 10, width,30)];
        [btn3 setTitle:@"处理中" forState:UIControlStateNormal];
        [btn3.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn3 setTitleColor:self.m_state.integerValue == 2 ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn3.layer.borderColor= self.m_state.integerValue == 2 ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn3.layer.borderWidth = 0.5;
        [cell addSubview:btn3];

        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 3;
        [btn4 addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 setFrame:CGRectMake(110, 50, width,30)];
        [btn4 setTitle:@"已完成" forState:UIControlStateNormal];
        [btn4.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn4 setTitleColor:self.m_state.integerValue == 3 ? KEY_COMMON_CORLOR : UIColorFromRGB(0xcfcfcf) forState:UIControlStateNormal];
        btn4.layer.cornerRadius = 2;
        btn4.layer.borderColor= self.m_state.integerValue == 3 ? KEY_COMMON_CORLOR.CGColor : UIColorFromRGB(0xcfcfcf).CGColor;
        btn4.layer.borderWidth = 0.5;
        [cell addSubview:btn4];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(5, [self high:indexPath]-0.5, MAIN_WIDTH-65, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [cell addSubview:sep];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){

    }else if (indexPath.row == 1){
        [self.m_delegate onSelectArea];
    }else if (indexPath.row == 2){
//        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"叫人帮忙",@"律师侦探",@"护卫保镖",@"纠纷债务",@"个性需求", nil];
//        UIViewController *delegate = (UIViewController *)self.m_delegate;
//        [act showInView:delegate.view];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"选择类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"叫人帮忙",@"律师侦探",@"护卫保镖",@"纠纷债务",@"个性需求", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.m_type = [NSString stringWithFormat:@"%ld",buttonIndex+1];
    [m_table reloadData];
}

//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        self.m_type = @(buttonIndex);
        [m_table reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
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
    confirmBtn.tag = index;
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
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                self.m_startTime = dateString;
                [m_startTime setText:self.m_startTime];
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormatter stringFromDate:[picker date]];
                if([LocalTimeUtil isValid2:self.m_startTime endTime:dateString])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self withDuration:1];
                }
                else
                {
                    self.m_endTime = dateString;
                    [m_endTime setText:self.m_endTime];
                }
            }
        }
    }
    [m_startTime resignFirstResponder];
    [m_endTime resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == m_startTime)
    {
        self.m_startTime = textField.text;
    }
    else
    {
        self.m_endTime = textField.text;
    }

    [m_table reloadData];

    return YES;
}


- (void)resetBtnClicked
{
    self.m_type = @"";
    self.m_area = nil;
    self.m_startTime = nil;
    self.m_endTime = nil;
    self.m_state = @"";
    self.m_isSaller = NO;
    [m_table reloadData];
}

- (void)okBtnClicked
{
    self.m_state = self.m_state == nil ? @"" : self.m_state;
    self.m_type = self.m_type == nil ? @"" : self.m_type;

    [self.m_delegate onFindFilterViewDelegateSelected:self.m_isSaller withArea:self.m_area withType:self.m_type == nil ? @"0" :  self.m_type withStartTime:self.m_startTime withEndTime:self.m_endTime withState:self.m_state == nil ? @"0" : self.m_state];
}

- (void)sellerBtnClicked
{
    self.m_isSaller = YES;
    [m_table reloadData];
}
- (void)sinalBtnClicked
{
    self.m_isSaller = NO;
    [m_table reloadData];
}

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_state = [NSString stringWithFormat:@"%ld",btn.tag];
    [m_table reloadData];
}

@end
