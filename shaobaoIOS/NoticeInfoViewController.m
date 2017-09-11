//
//  NoticeInfoViewController.m
//  officeMobile
//
//  Created by Points on 15-3-15.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "NoticeInfoViewController.h"
#import "FilePreviewViewController.h"
#import "ContactViewController.h"
@interface NoticeInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ContactViewControllerDelegate,UITextViewDelegate>
{
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
    UITextField *m_input4;
    UITextField *m_input5;
    UITextField *m_input6;
    UILabel *m_input7;
    UITextView *m_input8;
    UITextField *m_input9;
}

@property(nonatomic,strong) NSString *input1;
@property(nonatomic,strong) NSString *input2;
@property(nonatomic,strong) NSString *input3;
@property(nonatomic,strong) NSString *input4;
@property(nonatomic,strong) NSString *input5;
@property(nonatomic,strong) NSString *input6;
@property(nonatomic,strong) NSString *input7;
@property(nonatomic,strong) NSString *input8;
@property(nonatomic,strong) NSString *noticeId;
@property(nonatomic,copy) NSMutableArray *m_arrFile;
@property(assign)BOOL isFeedbacked;

@property(nonatomic,strong) NSMutableDictionary *m_detailInfo;
@property(nonatomic,copy) NSDictionary *m_noticeInfo;
@property(nonatomic,strong) NSMutableString *m_strRecUsers;
@property(nonatomic,strong) NSMutableString *m_strRecUserIds;
@property(nonatomic,strong) NSArray *m_arrRecUserIds;

@property(nonatomic,strong)NSArray *m_arrSelected;
@property(assign)BOOL m_isCanFeedback;

@property(assign)BOOL isSendedNotice;
@end

@implementation NoticeInfoViewController
- (id)initWithInfo:(NSDictionary *)info isSendedNotice:(BOOL)isSendedNotice
{
    self.m_isCanFeedback = NO;
    self.isSendedNotice = isSendedNotice;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    BOOL isFeedback = [info[@"isFeedback"]integerValue] == 1;
    self.isFeedbacked = isFeedback;
    
    if(info[@"detailId"]){
        [HTTP_MANAGER confirmReceivedNotice:info[@"detailId"]
                             successedBlock:^(NSDictionary *succeedResult) {
                                 
                                 [self.m_delegate onNeedRefreshTableView:self.view.tag];
                                 
                             } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                 
                             }];
    }
 
    if(!isFeedback)
    {

      
        
    }
    else
    {
        if([info[@"status"]integerValue] == 0)
        {
        }
        else if ([info[@"status"]integerValue] == 1)
        {
            
        }
        else if ([info[@"status"]integerValue] == 2)
        {
            self.isFeedbacked = YES;
        }
        else
        {
            
        }
    }
    self.m_info = info;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self requestData:YES];
        
        
        
        
        
        if(!isFeedback)
        {
            
            
            
        }
        else
        {
            if([info[@"status"]integerValue] == 0 || [info[@"status"]integerValue] == 1)
            {
                if(!isSendedNotice)
                {
                    self.m_isCanFeedback = YES;
                    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 60)];
                    self.tableView.tableFooterView = vi;
                    
                    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [confirmBtn setFrame:CGRectMake(5, 5, MAIN_WIDTH/2-10, 50)];
                    [confirmBtn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
                    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
                    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [vi addSubview:confirmBtn];
                    
                    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [cancelBtn setFrame:CGRectMake(5+MAIN_WIDTH/2, 5, MAIN_WIDTH/2-10, 50)];
                    [cancelBtn setBackgroundColor:[UIColor redColor]];
                    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [vi addSubview:cancelBtn];   
                }
               
            }
            else if ([info[@"status"]integerValue] == 2)
            {
            }
            else
            {
                
            }
        }
        
        
    }
    return self;
}


- (void)confirmBtnClicked
{
    if(m_input8.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"反馈信息不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.m_arrSelected.count == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"与会人员不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER saveInfoPersons:self.m_arrRecUserIds
                         noticeId:[self.m_info
                                   stringWithFilted:@"noticeId"]
                         detailId:[self.m_info stringWithFilted:@"detailId"]
                   successedBlock:^(NSDictionary *succeedResult) {
                       
                       [HTTP_MANAGER feedbackNotice:m_input8.text
                                           detailId:[self.m_info stringWithFilted:@"detailId"]
                                         isfeedback:true
                                     successedBlock:^(NSDictionary *feedbackResult) {
                           
                                         [self removeWaitingView];
                                         NSDictionary *ret = [feedbackResult[@"DATA"] mutableObjectFromJSONString];
                                         
                                         if([ret[@"resultCode"] integerValue] == 0)
                                         {
                                             [self.m_delegate onNeedRefreshTableView:self.view.tag];
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
                       
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
        
    }];
    
    
}

- (void)cancelBtnClicked
{
    [self backBtnClicked];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"通知详情"];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSInteger num =  self.isSendedNotice ? 8 : 10;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-50)];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-50)];
    
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getNoticeInfo:[self.m_info stringWithFilted:@"noticeId"]
                 successedBlock:^(NSDictionary *retDic){
                     
                     [self removeWaitingView];
                     NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
                     self.m_noticeInfo = ret[@"result"];
                     NSArray *arr = ret[@"result"][@"accessory"];
                     if(arr.count > 0)
                     {
                         self.m_arrFile = [NSMutableArray arrayWithArray:arr];
                     }
                     [self reloadDeals];
                     
                 } failedBolck:FAILED_BLOCK{
                     
                     [self removeWaitingView];
                     [self reloadDeals];
                     
                 }];
    
    

    
    if(self.isFeedbacked)
    {
        [self showWaitingView];
        [HTTP_MANAGER getNoticeDetail:[self.m_info stringWithFilted:@"detailId"]
                       successedBlock:^(NSDictionary *retDic){
                           [self removeWaitingView];
                           NSDictionary *ret = [retDic[@"DATA"] mutableObjectFromJSONString];
                           self.m_detailInfo = [NSMutableDictionary dictionaryWithDictionary:ret[@"result"]];
                           [self reloadDeals];
                           
                       } failedBolck:FAILED_BLOCK{
                           
                           [self removeWaitingView];
                           [self reloadDeals];
                           
                           
                       }];
        
        [self showWaitingView];
        [HTTP_MANAGER getNoticeUserList:[self.m_info stringWithFilted:@"detailId"]
                               noticeId:[self.m_info stringWithFilted:@"noticeId"]
                         successedBlock:^(NSDictionary *succeedResult) {
                             [self removeWaitingView];
                             NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                             self.m_strRecUsers = [NSMutableString string];
                             NSArray *arr = ret[@"result"];
                             for(NSDictionary *info in arr)
                             {
                                 [self.m_strRecUsers appendFormat:@"%@,",info[@"userName"]];
                             }
                             
                             [self reloadDeals];
                             
                         } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                             
                             
                             [self removeWaitingView];
                             [self reloadDeals];
                             
                         }];

    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate

- (NSInteger)getHigh:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6 || indexPath.row == 8  || indexPath.row == 9)
    {
        if(indexPath.row == 8 && !self.isFeedbacked)
        {
            return 0;
        }
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
    return self.isSendedNotice ? 8 : 10;
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
        m_input1.userInteractionEnabled = NO;
        m_input1.text = self.m_noticeInfo[@"title"];
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
        m_input2.userInteractionEnabled = NO;
        m_input2.text = self.m_noticeInfo[@"noticeTypeName"];
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
        m_input3.userInteractionEnabled = NO;
        m_input3.text = self.m_noticeInfo[@"place"];
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
        [m_input4 setText:self.m_noticeInfo[@"sendUserName"]];
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
        m_input5.userInteractionEnabled = NO;
        NSString *time = [LocalTimeUtil timeWithTimeIntervalString:[self.m_noticeInfo[@"startDate"]longLongValue]];
        m_input5.text = [time substringToIndex:time.length-3];
        [m_input5 setTextAlignment:NSTextAlignmentLeft];
        [m_input5 setTextColor:[UIColor blackColor]];
        [m_input5 setFont:[UIFont systemFontOfSize:14]];
        [m_input5 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input5];
    }
    else if (indexPath.row == 5)
    {
        [_title setText:@"结束时间:"];
        m_input6 = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, MAIN_WIDTH-110, 20)];
        m_input6.delegate = self;
        m_input6.userInteractionEnabled = NO;
        NSString *time = [LocalTimeUtil timeWithTimeIntervalString:[self.m_noticeInfo[@"endDate"]longLongValue]];
        m_input6.text =  [time substringToIndex:time.length-3];
        [m_input6 setTextAlignment:NSTextAlignmentLeft];
        [m_input6 setTextColor:[UIColor blackColor]];
        [m_input6 setFont:[UIFont systemFontOfSize:14]];
        [m_input6 setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:m_input6];
    }
    else if (indexPath.row == 6)
    {
        [_title setFrame:CGRectMake(10,10, 80,14)];
        [_title setText:@"内容摘要:"];
        
        m_input7 = [[UILabel alloc]initWithFrame:CGRectMake(10,35, MAIN_WIDTH-20, 65)];
        m_input7.numberOfLines = 0;
        m_input7.text = self.m_noticeInfo[@"content"];
        m_input7.layer.cornerRadius = 5;
        m_input7.layer.borderWidth = 0.5;
        m_input7.layer.borderColor = UIColorFromRGB(0xD4D4D4).CGColor;
        [m_input7 setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        [cell addSubview:m_input7];
        
        if(self.m_arrFile && self.isFeedbacked && self.m_arrFile.count > 0)
        {
            UIButton *addFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [addFileBtn addTarget:self action:@selector(addFileBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [addFileBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMaxY(m_input7.frame)+5, 90, 30)];
            [addFileBtn setTitle:@"附件" forState:UIControlStateNormal];
            [addFileBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
            [addFileBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
            [cell addSubview:addFileBtn];
        }
      
    }
    else if (indexPath.row == 7)
    {
        if(self.m_arrFile.count > 0)
        {
            for(NSDictionary *info in self.m_arrFile)
            {
                UIButton *addFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addFileBtn.tag = [self.m_arrFile indexOfObject:info];
                [addFileBtn addTarget:self action:@selector(addFileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [addFileBtn setFrame:CGRectMake(10,5+[self.m_arrFile indexOfObject:info]*60,MAIN_WIDTH-20, 50)];
                [addFileBtn setTitle:info[@"filename"] forState:UIControlStateNormal];
                [addFileBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
                [addFileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                [addFileBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, UIRectEdgeLeft, 0, 0)];
                [cell addSubview:addFileBtn];
            }
           
        }
    }
    else if (indexPath.row == 8)
    {
        if(self.isFeedbacked)
        {
            [_title setFrame:CGRectMake(10,10, 80,14)];
            [_title setText:@"反馈信息:"];
            m_input8 = [[UITextView alloc]initWithFrame:CGRectMake(10,35, MAIN_WIDTH-20,95)];
            m_input8.delegate = self;
            [m_input8 setFont:[UIFont systemFontOfSize:14]];
            m_input8.text = self.isFeedbacked ? self.m_detailInfo[@"answer"] : self.input8;
            m_input8.layer.cornerRadius = 5;
            m_input8.layer.borderWidth = 0.5;
            m_input8.layer.borderColor = UIColorFromRGB(0xD4D4D4).CGColor;
            [m_input8 setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
            m_input8.userInteractionEnabled = self.m_isCanFeedback;
            [cell addSubview:m_input8];
        }

    }
    else if (indexPath.row == 9)
    {
        if(self.isFeedbacked)
      {
        [_title setFrame:CGRectMake(10,10, 80,14)];
        [_title setText:@"与会人员:"];
        m_input9 = [[UITextField alloc]initWithFrame:CGRectMake(10,35, MAIN_WIDTH-20, 95)];
        m_input9.delegate = self;
        m_input9.userInteractionEnabled = NO;
        [m_input9 setFont:[UIFont systemFontOfSize:14]];
        m_input9.text = self.m_strRecUsers;
        m_input9.layer.cornerRadius = 5;
        m_input9.layer.borderWidth = 0.5;
        m_input9.layer.borderColor = UIColorFromRGB(0xD4D4D4).CGColor;
        [m_input9 setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        [cell addSubview:m_input9];
        
          if(self.m_isCanFeedback){
              UIButton *addRecUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
              [addRecUserBtn addTarget:self action:@selector(addRecUserBtn) forControlEvents:UIControlEventTouchUpInside];
              [addRecUserBtn setFrame:CGRectMake(MAIN_WIDTH-60,0, 50, 30)];
              [addRecUserBtn setTitle:@"添加" forState:UIControlStateNormal];
              [addRecUserBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
              [addRecUserBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
              [addRecUserBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
              [cell addSubview:addRecUserBtn];
          }
          
        }
  
    }
    else
    {
        
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self getHigh:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)addRecUserBtn
{
    ContactViewController *vc = [[ContactViewController alloc]initForSelectContact];
    vc.m_selectDelegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)addFileBtnClicked:(UIButton *)btn
{
    [self showWaitingView];

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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView == m_input8)
    {
        self.input8 = textView.text;
        [self.m_detailInfo setValue:self.input8 forKey:@"answer"];
        [self reloadDeals];
    }
    return YES;
}


#pragma mark - ContactViewControllerDelegate

- (void)onSelected:(NSArray *)arrContacter
{
    self.m_arrSelected = arrContacter;
    self.m_strRecUsers = [NSMutableString string];
    self.m_strRecUserIds = [NSMutableString string];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(ADTContacterInfo *info in arrContacter)
    {
        [self.m_strRecUsers appendFormat:@"%@,",info.m_strUserName];
        [self.m_strRecUserIds appendFormat:@"%@,",info.m_strUserID];
        [arr addObject: [NSNumber numberWithInteger:[info.m_strUserID integerValue]]];
    }
    self.m_arrRecUserIds = arr;
    [self reloadDeals];
}


@end

