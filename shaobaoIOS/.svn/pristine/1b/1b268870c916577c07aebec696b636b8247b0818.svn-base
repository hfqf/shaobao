//
//  DepartmentReceiveArticeInfoViewController.m
//  jianye
//
//  Created by points on 2017/6/15.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "DepartmentReceiveArticeInfoViewController.h"
#import "FilePreviewViewController.h"
@interface DepartmentReceiveArticeInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)NSDictionary *m_articelInfo;
@property(nonatomic,strong)UIView *m_bottomView;
@property(assign)BOOL m_isSigned;
@property(nonatomic,strong)UIView *m_bottom;

@property(assign)NSInteger  m_typeIndex;
@end

@implementation DepartmentReceiveArticeInfoViewController

-(id)initWith:(NSDictionary *)info with:(BOOL)isSigned
{
    self.m_isSigned = isSigned;
    self.m_info = info;
    self.m_typeIndex = 0;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)-50)];
        self.m_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-50, MAIN_WIDTH, 50)];
        [self.m_bottom setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.m_bottom];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 1)];
        sep.backgroundColor = [UIColor lightGrayColor];
        [self.m_bottom addSubview:sep];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((MAIN_WIDTH-100)/2, 5, 100, 40)];
        [btn setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [btn setTitle:@"签收" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(updateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.m_bottom addSubview:btn];
        self.m_bottom.hidden = isSigned;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"单位收文"];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-50)];
    self.m_bottom.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), MAIN_WIDTH, 50);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-50)];
    self.m_bottom.frame = CGRectMake(0,MAIN_HEIGHT-50, MAIN_WIDTH, 50);
    
}

- (void)updateBtnClicked
{
    NSArray *arr = self.m_articelInfo[@"docRecList"];
    NSDictionary *type = [arr objectAtIndex:self.m_typeIndex];
    NSString *appId = type[@"appId"];
    [HTTP_MANAGER updateDepartmentReceiveArticleInfo:self.m_articelInfo[@"documentId"]
                                               appId:appId
                                      successedBlock:^(NSDictionary *succeedResult) {
                                          
                                          NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                          [self.m_delegate onUpdateInfo:ret[@"result"]];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"签收失败" inSuperView:self.view withDuration:1];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getDepartmentReceiveArticleInfo:[self.m_info stringWithFilted:@"documentId"]
                                        receiveId:[self.m_info stringWithFilted:@"receiveId"]
                                   successedBlock:^(NSDictionary *succeedResult) {
                                       NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                       self.m_articelInfo = ret[@"result"];
                                       [self removeWaitingView];
                                       [self reloadDeals];
                                       self.m_bottomView.hidden = [self.m_articelInfo[@"status"]integerValue] == 1;

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
                    [self removeWaitingView];
                    [self reloadDeals];
        
    }];
}


#pragma mark - TableViewDelegate

- (NSInteger)high:(NSIndexPath *)path
{
    if(self.m_isSigned){
        NSArray *arr = self.m_articelInfo[@"fileList"];
        return path.row == 7 ? arr.count *40 +20: 60;
        
    }else{
        
        if(path.row ==  6){
            return 50;
        }
        NSArray *arr = self.m_articelInfo[@"fileList"];
        return path.row == 5 ? arr.count *40 +20: 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_isSigned ? 8 :6;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.m_typeIndex = buttonIndex;
    [self reloadDeals];
}

- (void)typeBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]init];
    NSArray *arr = self.m_articelInfo[@"docRecList"];
    act.delegate = self;
    for(NSDictionary *info in arr){
        [act addButtonWithTitle:info[@"name"]];
    }
    [act showInView:self.view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *info = self.m_articelInfo;
    
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(10,20,100, 28)];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setTextColor:UIColorFromRGB(0x323232)];
    [_title setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:_title];
    
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(120,25, MAIN_WIDTH-130, 18)];
    [desc setTextAlignment:NSTextAlignmentLeft];
    [desc setTextColor:UIColorFromRGB(0x8a8a8a)];
    [desc setFont:[UIFont systemFontOfSize:14]];
   
    
    UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(self.m_isSigned){
        
        if(indexPath.row == 0){
            
            [cell addSubview:desc];
            [_title setText:@"收文类型:"];
            
            NSArray *arr = self.m_articelInfo[@"docRecList"];
            if(arr.count > self.m_typeIndex){
                NSDictionary *type = [arr objectAtIndex:self.m_typeIndex];
                if(type){
                    [fileBtn setTitle:type[@"name"] forState:UIControlStateNormal];
                    [fileBtn setTitleColor:UIColorFromRGB(0x8a8a8a) forState:UIControlStateNormal];
//                    [fileBtn addTarget:self action:@selector(typeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                    fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [fileBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
                    [fileBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, 0)];
                    [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    [fileBtn setFrame:CGRectMake(120,13, 140, 40)];
                    [cell addSubview:fileBtn];
                }
            }
            
            
            
        }
        else if(indexPath.row == 1){
            [cell addSubview:desc];
            [_title setText:@"标题:"];
            [desc setText:info[@"subject"]];
        }else if (indexPath.row == 2){
            [cell addSubview:desc];
            [_title setText:@"来文单位:"];
            [desc setText:info[@"sendDeptName"]];
        }else if (indexPath.row == 3){
            [cell addSubview:desc];
            [_title setText:@"来文日期:"];
            [desc setText:info[@"sendDate"]];
        }else if (indexPath.row == 4){
            [cell addSubview:desc];
            [_title setText:@"签收人:"];
            [desc setText:info[@"receiveUserName"]];
        }else if (indexPath.row == 5){
            [cell addSubview:desc];
            [_title setText:@"签收日期:"];
            [desc setText:info[@"receiveDate"]];
        }
        else if (indexPath.row == 6){
            NSDictionary *documentInfo = info[@"fileBodyBean"];
            [fileBtn setTitle:documentInfo[@"filename"] forState:UIControlStateNormal];
            [fileBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [fileBtn addTarget:self action:@selector(documentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
            fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [fileBtn setFrame:CGRectMake(120,15, MAIN_WIDTH-130, 40)];
            [_title setText:@"正文:"];
            [cell addSubview:fileBtn];
        }else
        {
            [_title setText:@"附件:"];
            NSArray *arr = self.m_articelInfo[@"fileList"];
            for(NSDictionary *_info in arr){
                UIButton *_fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _fileBtn.tag = [arr  indexOfObject:_info];
                [_fileBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_fileBtn setTitle:_info[@"filename"] forState:UIControlStateNormal];
                [_fileBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [_fileBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [_fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                _fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_fileBtn setFrame:CGRectMake(120,15+40*[arr indexOfObject:_info], MAIN_WIDTH-130, 40)];
                [cell addSubview:_fileBtn];
            }
        }

        
        
    }else{
        
        if(indexPath.row == 0){
            
            [cell addSubview:desc];
            [_title setText:@"收文类型:"];
            
            NSArray *arr = self.m_articelInfo[@"docRecList"];
            if(arr.count > self.m_typeIndex){
                NSDictionary *type = [arr objectAtIndex:self.m_typeIndex];
                if(type){
                    [fileBtn setTitle:type[@"name"] forState:UIControlStateNormal];
                    [fileBtn setTitleColor:UIColorFromRGB(0x8a8a8a) forState:UIControlStateNormal];
                    [fileBtn addTarget:self action:@selector(typeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                    fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [fileBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
                    [fileBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, 0)];
                    [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    [fileBtn setFrame:CGRectMake(120,13, 140, 40)];
                    [cell addSubview:fileBtn];
                }
            }
            
            
            
        }
        else if(indexPath.row == 1){
            [cell addSubview:desc];
            [_title setText:@"标题:"];
            [desc setText:info[@"subject"]];
        }else if (indexPath.row == 2){
            [cell addSubview:desc];
            [_title setText:@"来文单位:"];
            [desc setText:info[@"sendDeptName"]];
        }else if (indexPath.row == 3){
            [cell addSubview:desc];
            [_title setText:@"来文日期:"];
            [desc setText:info[@"sendDate"]];
        }else if (indexPath.row == 4){
            NSDictionary *documentInfo = info[@"fileBodyBean"];
            [fileBtn setTitle:documentInfo[@"filename"] forState:UIControlStateNormal];
            [fileBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [fileBtn addTarget:self action:@selector(documentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
            fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [fileBtn setFrame:CGRectMake(120,15, MAIN_WIDTH-130, 40)];
            [_title setText:@"正文:"];
            [cell addSubview:fileBtn];
        }else if(indexPath.row == 5)
        {
            [_title setText:@"附件:"];
            NSArray *arr = self.m_articelInfo[@"fileList"];
            for(NSDictionary *_info in arr){
                UIButton *_fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _fileBtn.tag = [arr  indexOfObject:_info];
                [_fileBtn addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_fileBtn setTitle:_info[@"filename"] forState:UIControlStateNormal];
                [_fileBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [_fileBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [_fileBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                _fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_fileBtn setFrame:CGRectMake(120,15+40*[arr indexOfObject:_info], MAIN_WIDTH-130, 40)];
                [cell addSubview:_fileBtn];
            }
        }
        
        
        
    }
    

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)documentBtnClicked
{
    NSDictionary *attach = self.m_articelInfo[@"fileBodyBean"];

    [self showWaitingView];
    [HTTP_MANAGER downloadFileWithUrl:[attach stringWithFilted:@"filetype"]
                             fileName:[attach stringWithFilted:@"filename"]
                               params:
     @{
       @"typeid":[NSNumber numberWithInteger:0],
       @"resultCode":@"0",
       @"filename":[attach stringWithFilted:@"filename"],
       @"recordid":[attach stringWithFilted:@"recordid"],
       @"filetype":[attach stringWithFilted:@"filetype"],
       @"rettype":[NSNumber numberWithInteger:0],
       @"fileid" :[attach stringWithFilted:@"fileid"],
       @"userid" : [LoginUserUtil userId],
       @"doctype" : @([[attach stringWithFilted:@"doctype"]integerValue]),
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
                              [PubllicMaskViewHelper showTipViewWith:@"文件下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
}

- (void)fileBtnClicked:(UIButton *)btn
{
    NSArray *arr = self.m_articelInfo[@"fileList"];
    NSDictionary *attach = [arr objectAtIndex:btn.tag];
    
    [self showWaitingView];
    [HTTP_MANAGER downloadFileWithUrl:[attach stringWithFilted:@"filetype"]
                             fileName:[attach stringWithFilted:@"filename"]
                               params:
     @{
       @"typeid":[NSNumber numberWithInteger:0],
       @"resultCode":@"0",
       @"filename":[attach stringWithFilted:@"filename"],
       @"recordid":[attach stringWithFilted:@"recordid"],
       @"filetype":[attach stringWithFilted:@"filetype"],
       @"rettype":[NSNumber numberWithInteger:0],
       @"fileid" :[attach stringWithFilted:@"fileid"],
       @"userid" : [LoginUserUtil userId],
       @"doctype" : @([[attach stringWithFilted:@"doctype"]integerValue]),
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
                              [PubllicMaskViewHelper showTipViewWith:@"文件下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
}

@end
