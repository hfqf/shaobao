//
//  AddNewNoticeViewController.m
//  jianye
//
//  Created by points on 2017/2/23.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNewNoticeViewController.h"
#import "AddNoticeGroupViewController.h"
#import "ADTGropuInfo.h"
#import "FilePreviewViewController.h"
@interface AddNewNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddNoticeGroupViewController,UIActionSheetDelegate
>
{
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
    UITextField *m_input4;
    UITextField *m_input5;
    UITextField *m_input6;
    UITextField *m_input7;
}

@property(nonatomic,strong) NSString *input1;
@property(nonatomic,strong) NSString *input2;
@property(nonatomic,strong) NSString *input3;
@property(nonatomic,strong) NSString *input4;
@property(nonatomic,strong) NSString *input5;
@property(nonatomic,strong) NSString *input6;
@property(nonatomic,strong) NSString *input7;
@property(nonatomic,strong) NSString *noticeId;
@property(nonatomic,strong) NSMutableArray *m_arrFile;
@property(assign)BOOL isToCompany;
@property(assign)BOOL isNeedFeedback;

@property(nonatomic,strong) NSMutableString *recUnitIds;
@property(nonatomic,strong) NSMutableString *recUnitNames;

@end

@implementation AddNewNoticeViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.isNeedFeedback = YES;
        self.noticeId = [LoginUserUtil get32BitString];
        self.m_arrFile = [NSMutableArray array];
        [self reloadDeals];
        
        self.recUnitNames = [NSMutableString string];
        self.recUnitIds = [NSMutableString string];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"新增通知"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableViewDelegate

- (NSInteger)getHigh:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6)
    {
        return 140;
    }
    else if (indexPath.row == 7)
    {
        return self.m_arrFile.count == 0 ? 60 :  self.m_arrFile.count*60;
    }
    else{
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHigh:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10,20,80, 20)];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setTextColor:UIColorFromRGB(0x313131)];
    [_title setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:_title];
    
    if(indexPath.row == 0)
    {
        [_title setText:@"标题:"];
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(100,20, MAIN_WIDTH-110, 20)];
        m_input1.text = self.input1;
        [m_input1 setTextAlignment:NSTextAlignmentLeft];
        [m_input1 setTextColor:[UIColor blackColor]];
        [m_input1 setFont:[UIFont systemFontOfSize:14]];
        [m_input1 setBackgroundColor:[UIColor clearColor]];
        m_input1.delegate = self;
        [cell addSubview:m_input1];
    }
    else if (indexPath.row == 1)
    {
        [_title setText:@"类型:"];
        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input2.delegate = self;
        m_input2.text = self.input2;
        [m_input2 setTextAlignment:NSTextAlignmentLeft];
        [m_input2 setTextColor:[UIColor blackColor]];
        [m_input2 setFont:[UIFont systemFontOfSize:14]];
        [m_input2 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input2];
    }
    else if (indexPath.row == 2)
    {
        [_title setText:@"地点:"];
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input3.delegate = self;
        m_input3.text = self.input3;
        [m_input3 setTextAlignment:NSTextAlignmentLeft];
        [m_input3 setTextColor:[UIColor blackColor]];
        [m_input3 setFont:[UIFont systemFontOfSize:14]];
        [m_input3 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input3];
    }
    else if (indexPath.row == 3)
    {
        [_title setText:@"发送人:"];
        m_input4 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input4.userInteractionEnabled =NO;
        [m_input4 setText:[LoginUserUtil userName]];
        m_input4.delegate = self;
        [m_input4 setTextAlignment:NSTextAlignmentLeft];
        [m_input4 setTextColor:[UIColor blackColor]];
        [m_input4 setFont:[UIFont systemFontOfSize:14]];
        [m_input4 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input4];
    }
    else if (indexPath.row == 4)
    {
        [_title setText:@"开始时间:"];
        m_input5 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input5.delegate = self;
        m_input5.text = self.input5;
        [m_input5 setTextAlignment:NSTextAlignmentLeft];
        [m_input5 setTextColor:[UIColor blackColor]];
        [m_input5 setFont:[UIFont systemFontOfSize:14]];
        [m_input5 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input5];
        [m_input5 setInputView:[self getSelectTimePicker:indexPath]];
    }
    else if (indexPath.row == 5)
    {
        [_title setText:@"结束时间:"];
        m_input6 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input6.delegate = self;
        m_input6.text = self.input6;
        [m_input6 setTextAlignment:NSTextAlignmentLeft];
        [m_input6 setTextColor:[UIColor blackColor]];
        [m_input6 setFont:[UIFont systemFontOfSize:14]];
        [m_input6 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input6];
        [m_input6 setInputView:[self getSelectTimePicker:indexPath]];
    }
    else if (indexPath.row == 6)
    {
        [_title setFrame:CGRectMake(10,10, 80,14)];
        [_title setText:@"内容摘要:"];
        
        m_input7 = [[UITextField alloc]initWithFrame:CGRectMake(10,35, MAIN_WIDTH-20, 65)];
        m_input7.delegate = self;
        m_input7.layer.cornerRadius = 5;
        m_input7.layer.borderWidth = 0.5;
        m_input7.layer.borderColor = UIColorFromRGB(0xD4D4D4).CGColor;
        [m_input7 setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        [m_input7 setText:self.input7];
        [cell addSubview:m_input7];
        
        UIButton *addFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addFileBtn addTarget:self action:@selector(addFileBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addFileBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMaxY(m_input7.frame)+5, 90, 30)];
        [addFileBtn setTitle:@"添加附件" forState:UIControlStateNormal];
        [addFileBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
        [cell addSubview:addFileBtn];
    }
    else if (indexPath.row == 7)
    {
        if(self.m_arrFile.count > 0)
        {
            for(NSDictionary *info in self.m_arrFile)
            {
                NSInteger index = [self.m_arrFile indexOfObject:info];
                UIButton *addFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addFileBtn.tag = index;
                [addFileBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [addFileBtn setFrame:CGRectMake(5,5+index*60,MAIN_WIDTH-80,50)];
                [addFileBtn setTitle:info[@"filename"] forState:UIControlStateNormal];
                [addFileBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
                [cell addSubview:addFileBtn];
                
                UIButton *delFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                delFileBtn.tag = index;
                [delFileBtn addTarget:self action:@selector(delFileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [delFileBtn setFrame:CGRectMake(MAIN_WIDTH-50,5+index*60,40,50)];
                [delFileBtn setImage:[UIImage imageNamed:@"notice_delete"] forState:UIControlStateNormal];
                [delFileBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
                [cell addSubview:delFileBtn];
            }
           
        }
    }
    else if (indexPath.row == 8)
    {
        [_title setText:@"发送目标:"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(toCompanyClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = self.isToCompany;
        [btn setFrame:CGRectMake(90, 5, 120, 50)];
        [btn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
        [btn setTitle:@"发送至单位" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [cell addSubview:btn];
    }
    else if (indexPath.row == 9)
    {
        [_title setText:@"是否反馈:"];
        
        BOOL isCanChange = [self.input2 isEqualToString:@"会议通知"];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(isFeedbackClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn1.selected = self.isNeedFeedback;
        btn1.userInteractionEnabled = !isCanChange;
        [btn1 setFrame:CGRectMake(90, 5, 50, 50)];
        [btn1 setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        [btn1 setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
        [btn1 setTitle:@"是" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [cell addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 addTarget:self action:@selector(isFeedbackClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn2.selected = !self.isNeedFeedback;
        btn2.userInteractionEnabled = !isCanChange;
        [btn2 setFrame:CGRectMake(MAIN_WIDTH/2+40, 5, 50, 50)];
        [btn2 setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        [btn2 setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
        [btn2 setTitle:@"否" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [cell addSubview:btn2];
    }
    else
    {
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setFrame:CGRectMake(10, 10, MAIN_WIDTH-20, 40)];
        [sendBtn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [cell addSubview:sendBtn];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self getHigh:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}


- (void)addFileBtnClicked
{
    [LocalImageHelper selectPhotoFromLibray:self];
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
    [self reloadDeals];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith4:[picker date]];
            if(picker.tag  == 4)
            {
                self.input5 = time;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if (picker.tag == 5)
            {
                self.input6 = time;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                
            }
        }
    }
    
    
}


- (void)fileBtnClicked:(UIButton *)btn
{
    NSDictionary *attach = [self.m_arrFile objectAtIndex:btn.tag];
    [HTTP_MANAGER downloadFileWithUrl:[attach stringWithFilted:@"filetype"]
                             fileName:[attach stringWithFilted:@"filename"]
                               params:
     @{
       @"typeid":[NSNumber numberWithInteger:0],
       @"resultCode":@"0",
       @"filename":[attach stringWithFilted:@"filename"],
       @"recordid":@"",
       @"filetype":[attach stringWithFilted:@"filetype"],
       @"rettype":[NSNumber numberWithInteger:0],
       @"fileid" :[attach stringWithFilted:@"fileid"],
       @"userid" : [LoginUserUtil userId],
       @"doctype" : @(2),
       @"filebody":[attach stringWithFilted:@"filename"],
       @"token"   : [LoginUserUtil accessToken]
       }
                         successBlock:^(NSDictionary *retDic){
                             
                             [self removeWaitingView];
                             FilePreviewViewController *infoVc = [[FilePreviewViewController alloc]init];
                             infoVc.fileLocalUrl = retDic[@"path"];
                             infoVc.currentTitle = [attach stringWithFilted:@"filename"];
                             [self.navigationController pushViewController:infoVc animated:YES];
                             
                         }
                          failedBolck:FAILED_BLOCK{
                              
                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
}


- (void)delFileBtnClicked:(UIButton *)btn
{
    NSDictionary *info = [self.m_arrFile objectAtIndex:btn.tag];
    [HTTP_MANAGER deleteFile:[info stringWithFilted:@"fileid"]
                     docType:2
              successedBlock:^(NSDictionary *succeedResult) {
                  
                  
                  
              } failedBolck:FAILED_BLOCK{
                  
              }];
    [self.m_arrFile removeObjectAtIndex:btn.tag];
    [self reloadDeals];
}
#pragma mark - private

- (void)sendBtnClicked
{
    if(self.input1.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"标题不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input2.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"类型不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input3.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"地点不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input5.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input6.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"结束时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.input7.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"内容摘要不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(!self.isToCompany)
    {
        [PubllicMaskViewHelper showTipViewWith:@"不能发送至个人" inSuperView:self.view  withDuration:1];
        return;
    }
    
    [self showWaitingView];
    

    NSArray *arr = self.m_arrFile.count == 0 ? @[] : self.m_arrFile;
    
    [HTTP_MANAGER addNewNotice:self.input1
                          type:self.input2
                       address:self.input3
                     startTime:self.input5
                       endTime:self.input6
                          desc:self.input7
                          file:arr
                    isFeedfile:arr.count != 0
                      isperson:NO
                        isunit:NO
              receiveUnitNames:self.recUnitNames
                receiveUnitIds:self.recUnitIds
                      noticeId:self.noticeId
                isNeedFeedBack:self.isNeedFeedback
                successedBlock:^(NSDictionary *succeedResult) {
                    
                    [self removeWaitingView];
                    NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                    if([ret[@"resultCode"]integerValue] == 0)
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"新增成功" inSuperView:self.view  withDuration:1];
                        [self.m_delegate onNeedRefreshTableView:3];
                        [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"新增失败" inSuperView:self.view  withDuration:1];

                    }

        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"新增失败" inSuperView:self.view  withDuration:1];
        
    }];
}


- (void)toCompanyClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isToCompany = btn.selected;
    
    if(self.isToCompany)
    {
        AddNoticeGroupViewController *groupVc = [[AddNoticeGroupViewController alloc]init];
        groupVc.m_delegate = self;
        [self.navigationController pushViewController:groupVc animated:YES];
    }
}

- (void)isFeedbackClicked:(UIButton *)btn
{
    self.isNeedFeedback = !self.isNeedFeedback;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == m_input2)
    {
        [m_input1 resignFirstResponder];
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择通知类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"会议通知",@"活动通知",@"培训通知",@"其他通知", nil];
        [act showInView:self.view];
        return NO;
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
       self.input2 = @"会议通知";
    }
    else if (buttonIndex == 1)
    {
       self.input2 = @"活动通知";
    }
    else if (buttonIndex == 2)
    {
        self.input2 = @"培训通知";
    }else
    {
        self.input2 = @"其他通知";
    }
    
    self.isNeedFeedback = buttonIndex==0;
    [self reloadDeals];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == m_input1)
    {
        self.input1 = textField.text;
    }
    else if(textField == m_input2)
    {
        self.input2 = textField.text;
    }
    else if(textField == m_input3)
    {
        self.input3 = textField.text;
    }
    else if(textField == m_input5)
    {
        
    }
    else if(textField == m_input6)
    {
        
    }
    else if(textField == m_input7)
    {
        self.input7 = textField.text;
    }
    
    return YES;
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSArray *sep = [[info[@"UIImagePickerControllerReferenceURL"]absoluteString]componentsSeparatedByString:@"="];
    NSString *fileName = [[[sep objectAtIndex:1]componentsSeparatedByString:@"&"]firstObject];
    if(fileName == nil)
    {
        fileName = [LocalTimeUtil getCurrentTime];
    }
    
    [self showWaitingView];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image,0.01);
    NSString *path = [LocalImageHelper saveImage:image];
    
    [HTTP_MANAGER uploadFileWithPath:data
                              params:@{
                                       @"filename" : path,
                                       @"fileid" : [LoginUserUtil get32BitString],
                                       @"doctype" : @(2),
                                       @"recordid" :self.noticeId,
                                       @"userid" : [LoginUserUtil userId],
                                       @"token" : [LoginUserUtil accessToken],
                                       @"filebody":path,
                                       
                                       } successBlock:^(NSDictionary *retDic){
                                           
                                           [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_UPLOADING_FILE];
                                           
                                           [self removeWaitingView];
                                           if(retDic == nil)
                                           {
                                               [PubllicMaskViewHelper showTipViewWith:@"上传失败" inSuperView:self.view  withDuration:1];
                                           }
                                           else
                                           {
                                               NSMutableDictionary *insertInfo = [NSMutableDictionary dictionary];
                                               [insertInfo setObject:retDic[@"upload"] forKey:@"fileid"];
                                               [insertInfo setObject:path forKey:@"filename"];
                                               [insertInfo setObject:self.noticeId forKey:@"recordid"];
                                               [insertInfo setObject:@(2) forKey:@"doctype"];
                                               [insertInfo setObject:@"image/jpg" forKey:@"filetype"];
                                               [self.m_arrFile addObject:insertInfo];
                                           }
                                          
                                           [self reloadDeals];
                                           
                                       } failedBolck:FAILED_BLOCK{
                                           [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_UPLOADING_FILE];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [self removeWaitingView];
                                               
                                               [PubllicMaskViewHelper showTipViewWith:@"上传失败" inSuperView:self.view withDuration:1];
                                               
                                               
                                           });
                                           
                                       }];
    
    
    [self dismissViewControllerAnimated:NO completion:NULL];
}

#pragma mark - AddNoticeGroupViewController

- (void)onSelectedUnits:(NSArray *)arr
{
   for(ADTGropuInfo *info in arr)
   {
       [self.recUnitIds appendFormat:@"%@,",info.m_strDepId];
       [self.recUnitNames appendFormat:@"%@,",info.m_strDeptName];
   }
    
    
    
}


@end
