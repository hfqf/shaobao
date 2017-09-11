//
//  SendEmailViewController.m
//  officeMobile
//
//  Created by Points on 15-3-22.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SendEmailViewController.h"
#import "ContactViewController.h"
#import "OpenUDID.h"
#import "ADTGropuInfo.h"
#import "FilePreviewViewController.h"
#import "MWPhotoBrowser.h"
#import "ContactForGroupSelectViewController.h"
@interface SendEmailViewController ()<MWPhotoBrowserDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ContactViewControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UITextView *m_titleInput;
    UITextField *m_receiverInput;
    UITextField *m_receiverBTW;
    UITextField *m_receiverSecret;
    UITextView *m_content;
}

@property (nonatomic,strong)NSArray *m_arrReceiver;
@property (nonatomic,strong)NSArray *m_arrReceiverBTW;
@property (nonatomic,strong)NSArray *m_arrReceiverSecret;

@property (nonatomic,strong)NSMutableArray *m_arrFile;

@property (nonatomic,assign)NSInteger currentType;
@property (nonatomic,strong)NSString *m_uuid;

@property (nonatomic,assign)BOOL m_isFromSaveBox;

@property (nonatomic,strong) MWPhoto *m_expandPhoto;
@end

@implementation SendEmailViewController

-(id)initWithInfo:(NSDictionary *)emialInfo WithType:(enum_email_type)type isSaveBox:(BOOL)falg
{
    self.m_isFromSaveBox = falg;
    self.m_currentType = type;
    self.m_info = [NSMutableDictionary dictionaryWithDictionary:emialInfo];
    if(type == email_feedback)
    {
        for(NSDictionary *fileInfo in  self.m_info[@"accessory"])
        {
            [HTTP_MANAGER deleteFile:[fileInfo stringWithFilted:@"fileid"]
                             docType:2
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          
                          
                      } failedBolck:FAILED_BLOCK{
                          
                      }];
        }
        [self.m_info setObject:@[] forKey:@"accessory"];
        
        NSMutableArray *arr = [NSMutableArray array];
        ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
        info.m_strUserID = emialInfo[@"senderId"];
        info.m_strUserName = emialInfo[@"senderName"];
        [arr addObject:info];
        self.m_arrReceiver= arr;
        [self.m_info setObject:@"" forKey:@"content"];
    }else if (type == email_repost)
    {
        self.m_arrReceiver= nil;
        self.m_arrReceiverBTW = nil;
        self.m_arrReceiverSecret = nil;
        
        
        
        
        
    }
    else
    {
        NSArray *arrIds = [[emialInfo stringWithFilted:@"mainIds"]componentsSeparatedByString:@","];
        NSArray *arrNames = [[emialInfo stringWithFilted:@"mainNames"]componentsSeparatedByString:@","];
        if(arrIds.count > 0 && arrNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrIds objectAtIndex:[arrNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiver= arr;
        }
        
        NSArray *arrBtIds = [[emialInfo stringWithFilted:@"copyIds"]componentsSeparatedByString:@","];
        NSArray *arrBtNames = [[emialInfo stringWithFilted:@"copyNames"]componentsSeparatedByString:@","];
        if(arrBtIds.count > 0 && arrBtNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrBtNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrBtIds objectAtIndex:[arrBtNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiverBTW= arr;
        }
        
        NSArray *arrSecretIds = [[emialInfo stringWithFilted:@"blindIds"]componentsSeparatedByString:@","];
        NSArray *arrSecretNames = [[emialInfo stringWithFilted:@"blindNames"]componentsSeparatedByString:@","];
        if(arrSecretIds.count > 0 && arrSecretNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrSecretNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrSecretIds objectAtIndex:[arrSecretNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiverSecret= arr;
        }
    }
    
    
    if(type == email_repost)
    {
        [self.m_info setObject:[NSString stringWithFormat:@"------转发邮件信息------\n%@",[self.m_info stringWithFilted: @"content"]] forKey:@"content"];
    }
    
    
    
    
    if(type == email_draft)
    {
        self.m_arrReceiver = nil;
    }
    
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrFile = [NSMutableArray array];
        NSArray *arr = self.m_info[@"accessory"];
        if(arr.count > 0)
        {
            [self.m_arrFile addObjectsFromArray:arr];
        }
    }
    return self;
}

-(id)initWithInfo:(NSDictionary *)emialInfo WithType:(enum_email_type)type
{
    self.m_isFromSaveBox = NO;
    self.m_currentType = type;
    self.m_info = [NSMutableDictionary dictionaryWithDictionary:emialInfo];
    if(type == email_feedback)
    {
        for(NSDictionary *fileInfo in  self.m_info[@"accessory"])
        {
            [HTTP_MANAGER deleteFile:[fileInfo stringWithFilted:@"fileid"]
                             docType:2
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          
                          
                      } failedBolck:FAILED_BLOCK{
                          
                      }];
        }
        [self.m_info setObject:@[] forKey:@"accessory"];
        
        NSMutableArray *arr = [NSMutableArray array];
        ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
        info.m_strUserID = emialInfo[@"senderId"];
        info.m_strUserName = emialInfo[@"senderName"];
        [arr addObject:info];
        self.m_arrReceiver= arr;
        [self.m_info setObject:@"" forKey:@"content"];
    
    }else if (type == email_repost)
    {
        self.m_arrReceiver= nil;
        self.m_arrReceiverBTW = nil;
        self.m_arrReceiverSecret = nil;
    }
    else
    {
        NSArray *arrIds = [[emialInfo stringWithFilted:@"mainIds"]componentsSeparatedByString:@","];
        NSArray *arrNames = [[emialInfo stringWithFilted:@"mainNames"]componentsSeparatedByString:@","];
        if(arrIds.count > 0 && arrNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrIds objectAtIndex:[arrNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiver= arr;
        }
        
        NSArray *arrBtIds = [[emialInfo stringWithFilted:@"copyIds"]componentsSeparatedByString:@","];
        NSArray *arrBtNames = [[emialInfo stringWithFilted:@"copyNames"]componentsSeparatedByString:@","];
        if(arrBtIds.count > 0 && arrBtNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrBtNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrBtIds objectAtIndex:[arrBtNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiverBTW= arr;
        }
        
        NSArray *arrSecretIds = [[emialInfo stringWithFilted:@"blindIds"]componentsSeparatedByString:@","];
        NSArray *arrSecretNames = [[emialInfo stringWithFilted:@"blindNames"]componentsSeparatedByString:@","];
        if(arrSecretIds.count > 0 && arrSecretNames.count > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            for(NSString *str in arrSecretNames)
            {
                ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
                info.m_strUserID =  [arrSecretIds objectAtIndex:[arrSecretNames indexOfObject:str]];
                info.m_strUserName = str;
                [arr addObject:info];
            }
            
            self.m_arrReceiverSecret= arr;
        }
    }

    
    if(type == email_repost)
    {
        [self.m_info setObject:[NSString stringWithFormat:@"------转发邮件信息------\n%@",[self.m_info stringWithFilted: @"content"]] forKey:@"content"];
    }
    

  
    
    if(type == email_draft)
    {
        self.m_arrReceiver = nil;
    }
    
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrFile = [NSMutableArray array];
        NSArray *arr = self.m_info[@"accessory"];
        if(arr.count > 0)
        {
            [self.m_arrFile addObjectsFromArray:arr];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.m_uuid =  [OpenUDID uuid];
    
    UIView *headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 50)];
    
    int width = 40;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveBtnClickde) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setFrame:CGRectMake((MAIN_WIDTH/2)-width-20, 10, width, 30)];
    [saveBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    saveBtn.layer.borderWidth = 0.5;
    saveBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    saveBtn.layer.cornerRadius = 4;
    [headVeiw addSubview:saveBtn];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"发送" forState:UIControlStateNormal];
    [commitBtn setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, width, 30)];
    [commitBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    commitBtn.layer.borderWidth = 0.5;
    commitBtn.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    commitBtn.layer.cornerRadius = 4;
    [headVeiw addSubview:commitBtn];
    self.tableView.tableFooterView = headVeiw;
    
    [title setText:@"写邮件"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)saveBtnClickde
{
    
    NSString *tit = m_titleInput.text;
    tit = [tit stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.m_info setObject:tit forKey:@"subject"];
    [self.m_info setObject:m_content.text forKey:@"content"];
    
    if(m_titleInput.text.length == 0 || tit.length == 0 )
    {
        [PubllicMaskViewHelper showTipViewWith:@"主题不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_arrReceiver.count == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"主送不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentType == email_feedback)
    {
        [self.m_info setObject:self.m_uuid forKey:@"mailId"];
    }
    
    if([m_content.text isEqualToString:@"请输入邮件内容..."])
    {
        [self.m_info setObject:@"" forKey:@"content"];
    }
    else
    {
        [self.m_info setObject:m_content.text forKey:@"content"];
    }
    
    
    [HTTP_MANAGER dealwithEmail:1
                       withInfo:self.m_info
                   withReceiver:self.m_arrReceiver
                withReceiverBTW:self.m_arrReceiverBTW
             withReceiverSecret:self.m_arrReceiverSecret
                       withUUid:self.m_uuid
                 successedBlock:^(NSDictionary *retDic){

                     if([retDic[@"resultCode"]integerValue] == 0)
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"保存成功" inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                          ];
                     }
                     else
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];
                     }
                     
                 }
                    failedBolck:FAILED_BLOCK{
                        
                        
                    }];
}

- (void)commitBtnClicked
{
    NSString *tit = m_titleInput.text;
    tit = [tit stringByReplacingOccurrencesOfString:@" " withString:@""];

    [self.m_info setObject:tit forKey:@"subject"];

    if(m_titleInput.text.length == 0 || tit.length == 0 )
    {
        [PubllicMaskViewHelper showTipViewWith:@"主题不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_arrReceiver.count == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"主送不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    

    if([m_content.text isEqualToString:@"请输入邮件内容..."])
    {
        [self.m_info setObject:@"" forKey:@"content"];
    }
    else
    {
        [self.m_info setObject:m_content.text forKey:@"content"];
    }
    
    if(self.m_currentType == email_feedback)
    {
        [self.m_info setObject:self.m_uuid forKey:@"mailId"];
    }
    
    [HTTP_MANAGER dealwithEmail:0
                       withInfo:self.m_info
                   withReceiver:self.m_arrReceiver
                withReceiverBTW:self.m_arrReceiverBTW
             withReceiverSecret:self.m_arrReceiverSecret
                  withUUid:self.m_uuid
                 successedBlock:^(NSDictionary *retDic){
                 
                     if([retDic[@"resultCode"]integerValue] == 0)
                     {
                         if(self.m_sendDelegate && [self.m_sendDelegate respondsToSelector:@selector(onSendEmailSucceed)])
                         {
                             [self.m_sendDelegate onSendEmailSucceed];
                         }
                         [PubllicMaskViewHelper showTipViewWith:@"发送成功" inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                          ];
                     }
                     else
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"发送失败" inSuperView:self.view withDuration:1];
                     }
                 
                 }
                    failedBolck:FAILED_BLOCK{
                    
                    
                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (NSInteger)highOf:(int)row
{
    if(row == 3)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"content" withFont:[UIFont systemFontOfSize:14]];
        return size.height+120;
    }
    else if (row == 5)
    {
        id accrssory = self.m_info[@"accessory"];
        if([accrssory isKindOfClass:[NSString class]])
        {
            return 50;
        }
        else if([accrssory isKindOfClass:[NSArray class]])
        {
            NSArray *arr = self.m_info[@"accessory"];
            return arr.count<=2 ? 50 : arr.count*25;
        }
    }
    else if (row == 0)
    {
        NSString *STR = nil;
        if(self.m_currentType == email_repost)
        {
            STR = [NSString stringWithFormat:@"[转发]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else if (self.m_currentType == email_feedback)
        {
             STR =  [NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else if (self.m_currentType == email_draft)
        {
              STR = [NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else
        {
            STR = [self.m_info stringWithFilted: @"subject"];
            return 40;
        }
        
        CGSize size = [FontSizeUtil sizeOfString:@"主   题:" withFont:[UIFont systemFontOfSize:14]];
        
        CGSize contentSize = [FontSizeUtil sizeOfString:STR withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-size.width-10];
        return contentSize.height+10+30;

    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0)
    {
     
        NSInteger high = 0;
        NSString *STR = nil;
        if(self.m_currentType == email_repost)
        {
            STR = [NSString stringWithFormat:@"[转发]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else if (self.m_currentType == email_feedback)
        {
            STR =  [NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else if (self.m_currentType == email_draft)
        {
            STR = [NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]];
        }
        else
        {
            STR = [self.m_info stringWithFilted: @"subject"];
            high = 40;
        }
        
        CGSize size = [FontSizeUtil sizeOfString:@"主   题:" withFont:[UIFont systemFontOfSize:14]];
        
        CGSize contentSize = [FontSizeUtil sizeOfString:STR withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-size.width-10];
        high = contentSize.height+10+20;
        
        CGSize size1 = [FontSizeUtil sizeOfString:@"主   题:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10,(high-size1.height)/2,size1.width, size1.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"主   题:"];
        [cell addSubview:titleLab];
        
        
        
        m_titleInput = [[UITextView alloc]initWithFrame:CGRectMake(size.width+10,5,MAIN_WIDTH-size.width-10, high-10)];
        m_titleInput.tag = indexPath.row;
        m_titleInput.delegate = self;
        m_titleInput.layer.cornerRadius = 5;
       // m_titleInput.layer.borderWidth = 0.5;
        m_titleInput.layer.borderColor = [UIColor grayColor].CGColor;
        [m_titleInput setFont:[UIFont systemFontOfSize:14]];
        m_titleInput.showsVerticalScrollIndicator = YES;
        if(self.m_currentType == email_repost)
        {
            [m_titleInput setText:[NSString stringWithFormat:@"[转发]: %@",[self.m_info stringWithFilted: @"subject"]]];
        }
        else if (self.m_currentType == email_feedback)
        {
            [m_titleInput setText:[NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]]];
        }
        else if (self.m_currentType == email_draft)
        {
            [m_titleInput setText:[NSString stringWithFormat:@"[回复]: %@",[self.m_info stringWithFilted: @"subject"]]];
        }
        else
        {
            [m_titleInput setText:[self.m_info stringWithFilted: @"subject"]];
        }

        [m_titleInput setFrame:CGRectMake(size.width+10,5,MAIN_WIDTH-size.width-10, high-10)];
        [cell addSubview:m_titleInput];
        
    }
    else if (indexPath.row == 1)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"主   送:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"主   送:"];
        [cell addSubview:titleLab];
        
        m_receiverInput = [[UITextField alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        m_receiverInput.tag = indexPath.row;
        m_receiverInput.delegate = self;
        [m_receiverInput setFont:[UIFont systemFontOfSize:14]];
        
        NSMutableString *str = [NSMutableString string];
        for(ADTContacterInfo *info in self.m_arrReceiver)
        {
            [str appendFormat:@"%@,",info.m_strUserName];
        }
        
        if(str.length > 1)
        {
            str = [str substringToIndex:str.length-1];
        }
     
        [m_receiverInput setText:str];
        
       
        [cell addSubview:m_receiverInput];
        
        UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
        [add setImage:[UIImage imageNamed:@"mail_user_add.png"]];
        [cell addSubview:add];
    }
    else if (indexPath.row == 2)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"抄   送:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"抄   送:"];
        [cell addSubview:titleLab];
        
        m_receiverBTW = [[UITextField alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        m_receiverBTW.tag = indexPath.row;
        m_receiverBTW.delegate = self;
        [m_receiverBTW setFont:[UIFont systemFontOfSize:14]];
        NSMutableString *str = [NSMutableString string];
        for(ADTContacterInfo *info in self.m_arrReceiverBTW)
        {
            if(info.m_strUserName.length == 0)
            {
                continue;
            }
            [str appendFormat:@"%@,",info.m_strUserName];
        }
        
        if(str.length > 1)
        {
            str = [str substringToIndex:str.length-1];
        }
        
        [m_receiverBTW setText:str];
        [cell addSubview:m_receiverBTW];
        
        UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
        [add setImage:[UIImage imageNamed:@"mail_user_add.png"]];
        [cell addSubview:add];
    }
    else if (indexPath.row == 3)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"密   送:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"密   送:"];
        [cell addSubview:titleLab];
        
        m_receiverSecret = [[UITextField alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10,size.height)];
        m_receiverSecret.tag = indexPath.row;
        m_receiverSecret.delegate = self;
        [m_receiverSecret setFont:[UIFont systemFontOfSize:14]];
        NSMutableString *str = [NSMutableString string];
        for(ADTContacterInfo *info in self.m_arrReceiverSecret)
        {
            if(info.m_strUserName.length == 0)
            {
                continue;
            }
            [str appendFormat:@"%@,",info.m_strUserName];
        }
        
        if(str.length > 1)
        {
            str = [str substringToIndex:str.length-1];
        }
        
        [m_receiverSecret setText:str];
        [cell addSubview:m_receiverSecret];
        
        if(m_content == nil)
        {
            m_content = [[UITextView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(m_receiverSecret.frame)+5,MAIN_WIDTH-20,80)];
            m_content.delegate = self;
            m_content.returnKeyType = UIReturnKeyDone;
            m_content.layer.cornerRadius = 4;
            m_content.layer.borderWidth = 0.5;
            m_content.layer.borderColor =[UIColor grayColor].CGColor;
            [m_content setFont:[UIFont systemFontOfSize:14]];
        }
    
        
        if(self.m_isFromSaveBox)
        {
            [m_content setText:[self.m_info stringWithFilted: @"content"]];
        }
        else
        {
            if(m_content.text.length == 0)
            {
                [m_content setText:self.m_currentType == email_send ? @"请输入邮件内容..." : [self.m_info stringWithFilted: @"content"]];
            }
            else
            {
                [self.m_info setObject:m_content.text forKey:@"content"];
            }

        }
        [cell addSubview:m_content];
        
        UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
        [add setImage:[UIImage imageNamed:@"mail_user_add.png"]];
        [cell addSubview:add];
    }
    else if (indexPath.row == 4)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"附件: 每次只能上传单个附件" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"附件: 每次只能上传单个附件"];
        [cell addSubview:titleLab];
        
        UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
        [add setImage:[UIImage imageNamed:@"mail_user_add.png"]];
        [cell addSubview:add];

    }
    else if (indexPath.row == 5)
    {
        
        NSArray *arr = self.m_info[@"accessory"];
        if(arr.count ==  1)
        {
            NSDictionary *fileDic = [arr firstObject];
            CGSize size = [FontSizeUtil sizeOfString:fileDic[@"filename"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-25];
            UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            fileBtn.showsTouchWhenHighlighted = YES;
            [fileBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            fileBtn.tag = 0;
            [fileBtn setTitle:fileDic[@"filename"]  forState:UIControlStateNormal];
            [fileBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            fileBtn.titleLabel.numberOfLines = 0;
            [fileBtn setFrame:CGRectMake(5, 12.5, size.width,25)];
            [cell addSubview:fileBtn];
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.showsTouchWhenHighlighted = YES;
            deleteBtn.tag = 0;
            [deleteBtn setFrame:CGRectMake(MAIN_WIDTH-20,12, 20, 20)];
            [deleteBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
            [cell addSubview:deleteBtn];
            
            
        }
        else if (arr.count > 1)
        {
            for(NSDictionary *fileDic in arr)
            {
                CGSize size = [FontSizeUtil sizeOfString:fileDic[@"filename"] withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-25];
                UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                fileBtn.showsTouchWhenHighlighted = YES;
                [fileBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                fileBtn.tag = [arr indexOfObject:fileDic];
                [fileBtn setTitle:fileDic[@"filename"]  forState:UIControlStateNormal];
                [fileBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                fileBtn.titleLabel.numberOfLines = 0;
                [fileBtn setFrame:CGRectMake(5,[arr indexOfObject:fileDic]*25, MAIN_WIDTH-25,25)];
                [cell addSubview:fileBtn];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.showsTouchWhenHighlighted = YES;
                deleteBtn.tag = fileBtn.tag;
                [deleteBtn setFrame:CGRectMake(MAIN_WIDTH-20, [arr indexOfObject:fileDic]*25+2, 20, 20)];
                [deleteBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
                [cell addSubview:deleteBtn];
            }
        }
        else
        {
            
        }
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:@"content" withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-20];
        
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10,MAIN_WIDTH-20, size.height)];
        contentLab.numberOfLines = 0;
        contentLab.lineBreakMode= NSLineBreakByCharWrapping;
        [contentLab setText:self.m_info[@"content"]];
        [contentLab setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:contentLab];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath.row]-0.5, MAIN_WIDTH, 0.5)];
    sep.alpha = 0.2;
    [sep setBackgroundColor:[UIColor grayColor]];
    [cell addSubview:sep];
    return  cell;
}

- (void)fileBtnClicked:(UIButton *)btn
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除文件",@"查看文件", nil];
    act.tag = btn.tag;
    [act showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 4)//添加附件
    {
        
        UIActionSheet *act  = [[UIActionSheet alloc]initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库",@"拍照", nil];
        act.tag = 1000;
        [act showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 0 )
    {
        [self.m_info setObject:textField.text == nil ? @"" : textField.text forKey:@"subject"];
    }
    
    if(textField.tag == 3)
    {
      [self.m_info setObject:textField.text == nil ? @"" : textField.text forKey:@"content"];
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView == m_titleInput )
    {
        [self.m_info setObject:textView.text == nil ? @"" : textView.text forKey:@"subject"];
    }

    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if(textView == m_content)
    {
        if([textView.text isEqualToString:@"请输入邮件内容..."])
        {
           [textView setText:nil];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1 || textField.tag == 2 || textField.tag == 3)
    {
        self.currentType = textField.tag;
        
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择联系人" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按部门",@"按分组", nil];
        act.tag = 10000;
        [act showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        return NO;
    }
    return YES;
}

#pragma mark - SelectContactViewControllerDelegate

- (void)onSelectContact:(NSArray *)arrContact type:(enum_contact_type)currentType
{
    if(currentType == contact_receive)
    {
        self.m_arrReceiver = arrContact;
    }
    else if (currentType == contact_btw)
    {
        self.m_arrReceiverBTW = arrContact;
    }
    else
    {
        self.m_arrReceiverSecret = arrContact;
    }
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath_3=[NSIndexPath indexPathForRow:3 inSection:0];
    

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_1,indexPath_2,indexPath_3, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(actionSheet.tag == 1000)
       {
           if(buttonIndex == 0)
           {
               [LocalImageHelper selectPhotoFromLibray:self];
           }
           else if (buttonIndex == 1)
           {
               [LocalImageHelper selectPhotoFromCamera:self];
           }
           else if (buttonIndex == 2)
           {
               
           }
           else
           {
               
           }
       }
        else if (actionSheet.tag == 10000)
        {
            if(buttonIndex == 0)
            {
                ContactViewController *vc = [[ContactViewController alloc]initForSelectContact];
                vc.m_selectDelegate = self;
                [self.navigationController presentViewController:vc animated:YES completion:NULL];

            }
            else if (buttonIndex == 1)
            {
                [HTTP_MANAGER getGroupList:nil
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                          
                          if([ret[@"resultCode"]integerValue] == 0)
                          {

                              NSArray *arr = ret[@"result"];
                              if(arr==nil || arr.count == 0)
                              {
                                  [PubllicMaskViewHelper showTipViewWith:@"暂无分组" inSuperView:self.view withDuration:1];
                              }
                              else
                              {
                                  ContactForGroupSelectViewController *groupVc = [[ContactForGroupSelectViewController alloc]initForSelectContact];
                                  groupVc.m_selectDelegate = self;
                                  [self.navigationController presentViewController:groupVc animated:YES completion:NULL];
                              }
                          }
                          
                      } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                          
                          
                      }];
                
            }
            
        }
        else
        {
            NSArray *arr = self.m_info[@"accessory"];
            NSDictionary *dic = [arr objectAtIndex:actionSheet.tag];
            if(buttonIndex == 0)
            {
                NSMutableArray *arrNew = [NSMutableArray array];
                for(NSDictionary *dicNew in arr)
                {
                    if(dicNew != dic)
                    {
                        [arrNew addObject:dicNew];
                    }
                    else
                    {
                        [self.m_arrFile removeObjectAtIndex:actionSheet.tag];
                        
                        [HTTP_MANAGER deleteFile:[dicNew stringWithFilted:@"fileid"]
                                         docType:2
                                  successedBlock:^(NSDictionary *succeedResult) {
                                      
                                      
                            
                        } failedBolck:FAILED_BLOCK{
                        
                        }];
                    }
                }
                [self.m_info setObject:arrNew forKey:@"accessory"];
                [self reloadDeals];
            }
            else if (buttonIndex == 1)
            {

                
                BOOL iosFile = [dic[@"rettype"]integerValue] == 1;
                [HTTP_MANAGER downloadFileWithUrl:dic[@"filetype"]
                                           params:
                 iosFile ? @{
                             @"filepath" : [dic stringWithFilted:@"filepath"],
                             @"fileid"   : dic[@"filebody"],
                             @"userid"   : [LoginUserUtil userId],
                             @"doctype"  : dic[@"doctype"],
                             @"token"    : [LoginUserUtil accessToken]
                             }
                                                 :
                 @{
                   @"fileid" :dic[@"fileid"],
                   @"userid" : [LoginUserUtil userId],
                   @"doctype" : dic[@"doctype"],
                   @"token"   : [LoginUserUtil accessToken]
                   }
                                     successBlock:^(NSDictionary *retDic){
                                         [self removeWaitingView];
                                         [PubllicMaskViewHelper showTipViewWith:@"下载完毕" inSuperView:self.view withDuration:1];
                                         SpeLog(@"%@",retDic);
                                         FilePreviewViewController *info = [[FilePreviewViewController alloc]init];
                                         info.fileLocalUrl = retDic[@"path"];
                                         NSData *data = [NSData dataWithContentsOfFile:info.fileLocalUrl];
                                         
                                         
                                         self.m_expandPhoto =  [MWPhoto photoWithURL:[NSURL fileURLWithPath:info.fileLocalUrl]];
                                         
                                         MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                                         browser.displayActionButton = YES;
                                         browser.displayNavArrows = NO;
                                         browser.displaySelectionButtons = NO;
                                         browser.alwaysShowControls = NO;
                                         browser.zoomPhotosToFill = YES;
                                         browser.enableGrid = NO;
                                         browser.startOnGrid = NO;
                                         browser.delayToHideElements = 0;
                                         browser.enableSwipeToDismiss = YES;
                                         [browser setCurrentPhotoIndex:0];
                                         browser.isPresent = YES;
                                         browser.isMyself = YES;
                                         browser.isQXPhoto = YES;
                                         // 添加动画
                                         browser.view.layer.opacity = .2;
                                         [CATransaction begin];
                                         [CATransaction setValue:@(.25) forKey: kCATransactionAnimationDuration];
                                         [CATransaction setValue:@NO forKey: kCATransactionDisableActions];
                                         browser.view.layer.opacity = 1.0;
                                         [CATransaction commit];
                                         [self presentViewController:browser animated:YES completion:^{}];
                                         
                                     }
                                      failedBolck:FAILED_BLOCK{
                                          
                                          [self removeWaitingView];
                                          [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                                          
                                      }];
                
            }
            else
            {
                
            }
        }
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
                                       @"filename" : fileName,
                                       @"token" : [LoginUserUtil accessToken],
                                       @"userid" : [LoginUserUtil userId],
                                       @"fileid" : @"",
                                       @"doctype" : @(2),
                                       @"rettype" : @(1),
                                       @"recordid" :self.m_info[@"mailId"] == nil ?  self.m_uuid : self.m_info[@"mailId"]
                                       
                                       } successBlock:^(NSDictionary *retDic){
                                           
                                           [self removeWaitingView];

                                           [self.m_arrFile addObject:@{
                                                                    @"fileid":retDic[@"fileid"],
                                                                    @"filename":fileName,
                                                                    @"filebody":retDic[@"filepath"],
                                                                    @"recordid":self.m_info[@"mailId"] == nil ?self.m_uuid : self.m_info[@"mailId"],
                                                                    @"doctype":@(2),
                                                                    @"rettype" : @(1),
                                                                    }];
                                           [self.m_info setObject:self.m_arrFile forKey:@"accessory"];
                                           [self reloadDeals];
                                       
                                       } failedBolck:FAILED_BLOCK{
                                       
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [self removeWaitingView];

                                               [PubllicMaskViewHelper showTipViewWith:@"上传失败" inSuperView:self.view withDuration:1];

                                               
                                           });
                                       
                                       }];
    
    
    [self dismissViewControllerAnimated:NO completion:NULL];
}

#pragma mark - 
- (void)onSelected:(NSArray *)arrContacter
{
    
    if(self.currentType == 1)
    {
        self.m_arrReceiver = arrContacter;
    }
    else if(self.currentType == 2)
    {
        self.m_arrReceiverBTW = arrContacter;
    }
    else
    {
        self.m_arrReceiverSecret = arrContacter;
    }
    
    
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath_3=[NSIndexPath indexPathForRow:3 inSection:0];
    
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_1,indexPath_2,indexPath_3, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return self.m_expandPhoto;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    return 0;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return NO;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
