//
//  AddNewFaultViewController.m
//  jianye
//
//  Created by points on 2017/7/2.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNewFaultViewController.h"

@interface AddNewFaultViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *m_input0;
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
    UITextField *m_input4;
    UITextField *m_input5;
    UITextField *m_input6;
    UIView *headVeiw;
    
}
@end

@implementation AddNewFaultViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"故障申报"];
    [self createFooterView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5,100, 40)];
    _title.numberOfLines = 0;
    [_title setTextColor:[UIColor blackColor]];
    [_title setFont:[UIFont systemFontOfSize:14]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:_title];
    
    if(indexPath.row== 0){
        [_title setText:@"标题:"];
        if(m_input0 == nil){
            m_input0 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input0.delegate = self;
        m_input0.layer.cornerRadius = 2;
        m_input0.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input0.layer.borderWidth = 0.5;
        [cell addSubview:m_input0];
        
    }else if (indexPath.row == 1){
        [_title setText:@"部门:"];
        if(m_input1 == nil){
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input1.delegate = self;
        m_input1.layer.cornerRadius = 2;
        m_input1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input1.layer.borderWidth = 0.5;
        [cell addSubview:m_input1];
        
    }else if (indexPath.row == 2){
        [_title setText:@"房间号:"];
        if(m_input2 == nil){
        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input2.delegate = self;
        m_input2.layer.cornerRadius = 2;
        m_input2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input2.layer.borderWidth = 0.5;
        [cell addSubview:m_input2];
    }else if (indexPath.row == 3){
        [_title setText:@"联系人:"];
        if(m_input3 == nil){
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input3.delegate = self;
        m_input3.layer.cornerRadius = 2;
        [cell addSubview:m_input3];
        m_input3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input3.layer.borderWidth = 0.5;
    }else if (indexPath.row == 4){
        [_title setText:@"电话:"];
        if(m_input4 == nil){
        m_input4 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input4.delegate = self;
        m_input4.layer.cornerRadius = 2;
        [cell addSubview:m_input4];
        m_input4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input4.layer.borderWidth = 0.5;
    }else if (indexPath.row == 5){
        [_title setText:@"建议上门时间:"];
        if(m_input5 == nil){
        m_input5 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input5.delegate = self;
        m_input5.layer.cornerRadius = 2;
        [cell addSubview:m_input5];
        m_input5.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input5.layer.borderWidth = 0.5;
        m_input5.inputView = [self getSelectTimePicker:indexPath];
    }else if (indexPath.row == 6){
        [_title setText:@"故障描述:"];
        if(m_input6 == nil){
        m_input6 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_title.frame)+10)-10, 30)];
        }
        m_input6.delegate = self;
        m_input6.layer.cornerRadius = 2;
        [cell addSubview:m_input6];
        m_input6.layer.borderColor = [UIColor lightGrayColor].CGColor;
        m_input6.layer.borderWidth = 0.5;
    }else if (indexPath.row == 7){
        [_title setText:@"解决方案:"];
    }else if (indexPath.row == 8){
        [_title setText:@"其他建议和意见:"];
    }
    
    
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep  setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:sep];
    return  cell;
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
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
            [dateFormatter setTimeZone:timeZone];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:[picker date]];
            [m_input5 setText:dateString];
        }
    }
    [self reloadDeals];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)createFooterView
{
    
    if(headVeiw){
        [headVeiw removeFromSuperview];
        headVeiw = nil;
    }
    headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0,MAIN_HEIGHT-50, MAIN_WIDTH, 50)];

    int width = 40;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"保存" forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake((MAIN_WIDTH/2)-40, 10, width, 30)];
    [btn1 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    btn1.layer.borderWidth = 0.5;
    btn1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    btn1.layer.cornerRadius = 4;
    [headVeiw addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"提交" forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, width, 30)];
    [btn2 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    btn2.layer.borderWidth = 0.5;
    btn2.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    btn2.layer.cornerRadius = 4;
    [headVeiw addSubview:btn2];

    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width,  self.tableView.frame.size.height-50)];
    [self.view addSubview:headVeiw];
}

- (void)saveClicked
{
    
}

- (void)commitClicked
{
    
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-50)];
    headVeiw.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), MAIN_WIDTH, 50);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-50)];
    headVeiw.frame = CGRectMake(0,MAIN_HEIGHT-50, MAIN_WIDTH, 50);
}




@end
