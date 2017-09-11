//
//  TodoInfoViewController.m
//  officeMobile
//
//  Created by Points on 15-3-24.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "TodoInfoViewController.h"
#import "ADTGovermentFileInfo.h"
#import "FilePreviewViewController.h"
#import "ContactViewController.h"
#import "ADTGropuInfo.h"
#import "TodoProcessInfoViewController.h"
#import "TodoCheckInfoViewController.h"
#import "TodoCommitContactsViewController.h"
#import "AdtContacterInfo.h"

#import <SignPDFSDK/SignPDFViewController.h>

@interface TodoInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ContactViewControllerDelegate,UITextViewDelegate,TodoCommitContactsViewControllerDelegate,UIActionSheetDelegate>
{
    UITextView *contentLab;
    NSInteger m_index;
    UIView *headVeiw;
}

@property (nonatomic,strong) NSString *m_pathFile;
@property (nonatomic,copy) NSDictionary *m_retInfo;
@property (nonatomic,strong) ADTCommitButtonInfo *m_currentButton;

@end

@implementation TodoInfoViewController

- (id)init:(id )todoInfo withIndex:(NSInteger)index
{
    m_index = index;
    if([todoInfo isKindOfClass:[ADTGovermentFileInfo class]])
    {
        self.m_infoData = todoInfo;
    }
    else
    {
        self.m_info = todoInfo;
    }
    
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.view.tag = index;

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (iAppPDFAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)requestData:(BOOL)isRefresh
{
    if(self.m_infoData == nil)
    {
        [self showWaitingView];
        [HTTP_MANAGER getTodoInfo:self.m_info[@"messageid"] == nil ? self.m_infoData.m_strMessageId : self.m_info[@"messageid"]
                   successedBlock:^(NSDictionary *retDic){
                       
                       ADTGovermentFileInfo *info = [ADTGovermentFileInfo getInfoFrom:retDic];
                       self.m_infoData = info;
                       [title setText:self.m_infoData.m_strSubject];
                       [self reloadDeals];
                       [self removeWaitingView];
                       [self createFooterView];
                       
                   } failedBolck:FAILED_BLOCK{
                       
                       [self reloadDeals];
                       [self removeWaitingView];
                       
                   }];
    }
    else
    {
        [title setText:self.m_infoData.m_strSubject];
        [self reloadDeals];
        [self createFooterView];
    }

}


- (void)createFooterView
{
    
    
    
    UIView *processBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 40)];
    UIButton *btnprocessBg1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnprocessBg1 addTarget:self action:@selector(processInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnprocessBg1 setTitle:@"处理过程" forState:UIControlStateNormal];
    [btnprocessBg1 setFrame:CGRectMake(10, 10, MAIN_WIDTH/2-20, 30)];
    [btnprocessBg1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnprocessBg1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnprocessBg1 setBackgroundColor:KEY_COMMON_CORLOR];
    btnprocessBg1.layer.borderWidth = 0.5;
    btnprocessBg1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    btnprocessBg1.layer.cornerRadius = 4;
    [processBg addSubview:btnprocessBg1];
    
    UIButton *btnprocessBg2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnprocessBg2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnprocessBg2 addTarget:self action:@selector(checkInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnprocessBg2 setTitle:@"阅知情况" forState:UIControlStateNormal];
    [btnprocessBg2 setFrame:CGRectMake((MAIN_WIDTH/2)+10, 10,  MAIN_WIDTH/2-20, 30)];
    [btnprocessBg2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnprocessBg2 setBackgroundColor:KEY_COMMON_CORLOR];
    btnprocessBg2.layer.borderWidth = 0.5;
    btnprocessBg2.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    btnprocessBg2.layer.cornerRadius = 4;
    [processBg addSubview:btnprocessBg2];
    self.tableView.tableFooterView = processBg;
    
    if(self.m_infoData.m_isReadOnly)
    {
        return;
    }
    
    if(headVeiw){
        [headVeiw removeFromSuperview];
        headVeiw = nil;
    }
    headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0,MAIN_HEIGHT-50, MAIN_WIDTH, 50)];
    
    if(m_index == 0)
    {
        if(self.m_infoData.m_arrNextButton.count  == 0)
        {
            
            
            if(self.m_infoData.m_isCanBack)
            {
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
                [btn2 addTarget:self action:@selector(giveUpClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn2 setTitle:@"退回" forState:UIControlStateNormal];
                [btn2 setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, width, 30)];
                [btn2 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                btn2.layer.borderWidth = 0.5;
                btn2.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                btn2.layer.cornerRadius = 4;
                [headVeiw addSubview:btn2];
            }
            else
            {
                int width = 40;
                UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn1 addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn1 setTitle:@"保存" forState:UIControlStateNormal];
                [btn1 setFrame:CGRectMake((MAIN_WIDTH-width)/2, 10, width, 30)];
                [btn1 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                btn1.layer.borderWidth = 0.5;
                btn1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                btn1.layer.cornerRadius = 4;
                [headVeiw addSubview:btn1];
            }
  
        }
        else
        {
            
            
            if(self.m_infoData.m_isCanBack)
            {
                int width = 40;
                UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn1 addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn1 setTitle:@"保存" forState:UIControlStateNormal];
                [btn1 setFrame:CGRectMake((MAIN_WIDTH/2)-80, 10, width, 30)];
                [btn1 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                btn1.layer.borderWidth = 0.5;
                btn1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                btn1.layer.cornerRadius = 4;
                [headVeiw addSubview:btn1];
                
                UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn2 addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn2 setTitle:@"提交" forState:UIControlStateNormal];
                [btn2 setFrame:CGRectMake((MAIN_WIDTH/2)-20, 10, width, 30)];
                [btn2 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                btn2.layer.borderWidth = 0.5;
                btn2.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                btn2.layer.cornerRadius = 4;
                [headVeiw addSubview:btn2];
                
                UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn3 addTarget:self action:@selector(giveUpClicked) forControlEvents:UIControlEventTouchUpInside];
                [btn3 setTitle:@"退回" forState:UIControlStateNormal];
                [btn3 setFrame:CGRectMake((MAIN_WIDTH/2)+40, 10, width, 30)];
                [btn3 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
                btn3.layer.borderWidth = 0.5;
                btn3.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
                btn3.layer.cornerRadius = 4;
                [headVeiw addSubview:btn3];
            }
            else
            {
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
            }
            
      
        }
    
    }
    else
    {
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
    }
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width,MAIN_HEIGHT-64-50)];
    [self.view addSubview:headVeiw];
    

    
   
}

- (void)processInfoBtnClicked
{
    TodoProcessInfoViewController *process = [[TodoProcessInfoViewController alloc]initWithInfo:self.m_infoData.m_arrFlowLog];
    [self.navigationController pushViewController:process animated:YES];
}

- (void)checkInfoBtnClicked
{
    TodoCheckInfoViewController *process = [[TodoCheckInfoViewController alloc]initWithInfo:self.m_infoData.m_arrReadInfo];
    [self.navigationController pushViewController:process animated:YES];
}

- (void)saveClicked
{
    NSString *str = [contentLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(contentLab.text.length == 0 || str.length == 0 || [contentLab.text isEqualToString:@"请输入您的意见"])
    {
        [PubllicMaskViewHelper showTipViewWith:@"意见内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER saveTodoFile:contentLab.text
                      WithInfo:self.m_infoData
                successedBlock:^(NSDictionary *retDic){
                    [self removeWaitingView];
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
                
                } failedBolck:FAILED_BLOCK{
                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"保存失败" inSuperView:self.view withDuration:1];
                
                }];
}


- (void)commitClicked
{
    NSString *str = [contentLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(contentLab.text.length == 0 || str.length == 0 || [contentLab.text isEqualToString:@"请输入您的意见"])
    {
        [PubllicMaskViewHelper showTipViewWith:@"意见内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_infoData.m_arrNextButton.count == 1)
    {
        ADTCommitButtonInfo *nextInfo = [self.m_infoData.m_arrNextButton firstObject];
        [self getContact:nextInfo];
        return;
    }
    
    
    MLTableAlert *alert = [[MLTableAlert alloc]initWithTitle:@"流程选择" row:(int)(self.m_infoData.m_arrNextButton.count)
                                           cancelButtonTitle:@"关闭"
                                                numberOfRows:^NSInteger (NSInteger section)
                           {
                               return self.m_infoData.m_arrNextButton.count;
                           }
                                                    andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                           {
                               
                               static NSString *CellIdentifier = @"Cell";
                               
                               UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                               
                               if (cell == nil) {
                                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                               }
                               [cell setBackgroundColor:[UIColor clearColor]];
                               ADTCommitButtonInfo *nextInfo = [self.m_infoData.m_arrNextButton objectAtIndex:indexPath.row];
                               [cell.textLabel setText:nextInfo.m_strActionName];
                               [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                               return cell;
                               
                           }];
    
    
    [alert configureSelectionBlock:^(NSIndexPath *selectedIndex)
     {
         ADTCommitButtonInfo *nextInfo = [self.m_infoData.m_arrNextButton objectAtIndex:selectedIndex.row];
         [self getContact:nextInfo];
         
     }
                andCompletionBlock:^
     {
         
     }
     ];
    
    [alert show];

}

- (void)giveUpClicked
{
    
    NSString *str = [contentLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(contentLab.text.length == 0 || str.length == 0 || [contentLab.text isEqualToString:@"请输入您的意见"])
    {
        [PubllicMaskViewHelper showTipViewWith:@"意见内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    [self showWaitingView];
    [HTTP_MANAGER giveUpTodo:@{
                             @"userId":[LoginUserUtil userId],
                             @"messageId":self.m_infoData.m_strMessageId,
                             @"important":@(0),
                             @"opinion":contentLab.text == nil ? @"" : contentLab.text
                           } successedBlock:^(NSDictionary *retDic){
                               [self removeWaitingView];
                               if([retDic[@"resultCode"]integerValue] == 0)
                               {
                                   NSDictionary *ret = [retDic[@"DATA"]mutableObjectFromJSONString];
                                   if([ret[@"resultCode"]integerValue] == 0)
                                   {
                                       [PubllicMaskViewHelper showTipViewWith:@"退回成功" inSuperView:self.view withDuration:1];
                                       [self performSelector:@selector(backBtnClicked) withObject:self afterDelay:1];
                                   }
                                   else
                                   {
                                       [PubllicMaskViewHelper showTipViewWith:ret[@"resultDesc"] inSuperView:self.view withDuration:1];
                                   }
                               }
                               else
                               {
                                   [PubllicMaskViewHelper showTipViewWith:retDic[@"退回失败"] inSuperView:self.view withDuration:1];
                               }
                           
                           } failedBolck:FAILED_BLOCK{
                               [self removeWaitingView];
                               [PubllicMaskViewHelper showTipViewWith:@"退回失败" inSuperView:self.view withDuration:1];
                           
                           }];
}

#pragma mark - 提交待办

//直接提交
- (void)commitDirectly:(NSDictionary *)reqDic
{
    [self showWaitingView];
    [HTTP_MANAGER commitTodo:reqDic
              successedBlock:^(NSDictionary *retDic){
                  [self removeWaitingView];
                  if([retDic[@"resultCode"]integerValue] == 0)
                  {
                      NSDictionary *ret = [retDic[@"DATA"]mutableObjectFromJSONString];
                      if([ret[@"resultCode"]integerValue] == 0)
                      {
                          [PubllicMaskViewHelper showTipViewWith:@"提交成功" inSuperView:self.view withDuration:1];
                          [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1
                           ];
                          if(self.m_infoDelegate && [self.m_infoDelegate respondsToSelector:@selector(onCommitCompleted)])
                          {
                              [self.m_infoDelegate onCommitCompleted];
                          }
                      }
                      else
                      {
                          [PubllicMaskViewHelper showTipViewWith:ret[@"resultDesc"] inSuperView:self.view withDuration:1];
                      }
                  }
                  else
                  {
                      [PubllicMaskViewHelper showTipViewWith:retDic[@"提交失败"] inSuperView:self.view withDuration:1];
                  }
                  
                  
              } failedBolck:FAILED_BLOCK{
                  [self removeWaitingView];
                  [PubllicMaskViewHelper showTipViewWith:@"提交失败" inSuperView:self.view withDuration:1];
                  
              }];
}

//只选一个联系人提交
- (void)commitWithSinglContact:(NSArray *)arr
{
    
    MLTableAlert *alert = [[MLTableAlert alloc]initWithTitle:@"环节人员选择" row:(int)(arr.count)
                                           cancelButtonTitle:@"关闭"
                                                numberOfRows:^NSInteger (NSInteger section)
                           {
                               return arr.count;
                           }
                                                    andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                           {
                               
                               static NSString *CellIdentifier = @"Cell";
                               UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                               [cell setBackgroundColor:[UIColor clearColor]];
                               NSDictionary  *Info = [arr objectAtIndex:indexPath.row];
                               [cell.textLabel setText:Info[@"name"]];
                               [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                               return cell;
                               
                           }];
    
    
    [alert configureSelectionBlock:^(NSIndexPath *selectedIndex)
     {
         
         NSDictionary  *Info = [arr objectAtIndex:selectedIndex.row];
         
         [self commitDirectly:@{
                                @"receiverslist":@[
                                                 @{
                                                     @"id" : @"1",
                                                     @"nodeId":self.m_retInfo[@"linknodeid"],
                                                     @"nodeType":self.m_retInfo[@"linknodetype"],
                                                     @"userId":[Info stringWithFilted:@"id"],
                                                     @"name":[Info stringWithFilted:@"name"],
                                                     @"actorType":@"Worker_",
                                                     @"receiveType": @"",
                                                     @"waittype":self.m_retInfo[@"waittype"]
                                                  },
                                                ],
                                @"linknodeid":self.m_retInfo[@"linknodeid"],
                                @"linknodetype":self.m_retInfo[@"linknodetype"],
                                @"actionid" :self.m_currentButton.m_strActionId,
                                @"userid" :[LoginUserUtil userId],
                                @"flowmodelid":self.m_infoData.m_strFlowModelId,
                                @"messageid":self.m_infoData.m_strMessageId,
                                @"important" : @(0),
                                @"subject":self.m_infoData.m_strSubject,
                                @"form" : self.m_infoData.m_arrOriginalForm,
                                @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                @"cansms" : @(0)
                                }];
         
     }
                andCompletionBlock:^
     {
         
     }
     ];
    
    [alert show];
}


//获取提交对象
- (void)getContact:(ADTCommitButtonInfo *)nextInfo
{
    [self showWaitingView];

    self.m_currentButton = nextInfo;
    [HTTP_MANAGER getTodoContact:@{
                              @"userId":[LoginUserUtil userId],
                              @"messageId":self.m_infoData.m_strMessageId,
                              @"flowmodelId":self.m_infoData.m_strFlowModelId,
                              @"actionId" : nextInfo.m_strActionId,
                              @"deptId":[LoginUserUtil orgId]
                              }
                  successedBlock:^(NSDictionary *retDic){
                  
                      [self removeWaitingView];
                      NSDictionary *ret  = [retDic[@"DATA"]mutableObjectFromJSONString];
                      self.m_retInfo = ret;
                      BOOL isCanCommitDirectly = [ret[@"cansubmit"]integerValue]== 1;
                      if(isCanCommitDirectly)//是需要直接提交的
                      {
                          
                          NSMutableDictionary *reqDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                        @"receiverslist":@[],
                                                                                                        @"userid" :[LoginUserUtil userId],
                                                                                                        @"actionid" :self.m_currentButton.m_strActionId,
                                                                                                        @"flowmodelid":self.m_infoData.m_strFlowModelId,
                                                                                                        @"messageid":self.m_infoData.m_strMessageId,
                                                                                                        @"important" : @(0),
                                                                                                        @"subject":self.m_infoData.m_strSubject,
                                                                                                        @"form" : self.m_infoData.m_arrOriginalForm,
                                                                                                        @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                                                                                        @"cansms" : @(0),
                                                                                                        }];
                          if(ret[@"linknodeid"]){
                              [reqDic setObject:ret[@"linknodeid"] forKey:@"linknodeid"];
                          }
                          if(ret[@"linknodetype"]){
                              [reqDic setObject:ret[@"linknodetype"] forKey:@"linknodetype"];
                          }
                          [self commitDirectly:reqDic];
                      }
                      else
                      {
                          NSArray *arr = ret[@"nodes"];
                          NSInteger contactType = [ret[@"linknodetype"]integerValue];

                          NSDictionary *retInfo =[arr firstObject];
                          arr = retInfo[@"workers"];
                          
             
                          if(arr == nil || arr.count  == 0)//服务器没有返回联系人，此时需要自己从组织架构中获取
                          {
                              ContactViewController *vc = [[ContactViewController alloc]initForSelectContact];
                              vc.m_selectDelegate = self;
                              [self.navigationController presentViewController:vc animated:YES completion:NULL];
                          }
                          else  if(arr.count == 1) //当只有一个联系人时，是直接提交
                          {
                              NSDictionary *Info = [arr firstObject];
                              NSDictionary *req = @{
                                                       @"receiverslist":@[
                                                               @{
                                                                   @"id" : @"1",
                                                                   @"nodeId":self.m_retInfo[@"linknodeid"],
                                                                   @"nodeType":self.m_retInfo[@"linknodetype"],
                                                                   @"userId":[Info stringWithFilted:@"id"],
                                                                   @"name":[Info stringWithFilted:@"name"],
                                                                   @"actorType":@"Worker_",
                                                                   @"receiveType": @"",
                                                                   @"waittype":self.m_retInfo[@"waittype"]
                                                                   },
                                                               ],
                                                       @"linknodeid":self.m_retInfo[@"linknodeid"],
                                                       @"linknodetype":self.m_retInfo[@"linknodetype"],
                                                       @"actionid" :self.m_currentButton.m_strActionId,
                                                       @"userid" :[LoginUserUtil userId],
                                                       @"flowmodelid":self.m_infoData.m_strFlowModelId,
                                                       @"messageid":self.m_infoData.m_strMessageId,
                                                       @"important" : @(0),
                                                       @"subject":self.m_infoData.m_strSubject,
                                                       @"form" : self.m_infoData.m_arrOriginalForm,
                                                       @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                                       @"cansms" : @(0)
                                                       };
                              [self commitDirectly:req];
                          }
                          else
                          {
                              if(contactType == 35 || contactType == 37) //可以多选联系人
                              {
                                  NSMutableArray *arrContact = [NSMutableArray array];
                                  for(NSDictionary *con in arr)
                                  {
                                      ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
                                      newCon.m_strUserID = [con stringWithFilted:@"id"];
                                      newCon.m_strUserName = [con stringWithFilted:@"name"];
                                      
                                      [arrContact addObject:newCon];
                                  }
                                  [self seleteMutilContacts:arrContact];
                              }
                              else
                              {
                                  [self commitWithSinglContact:arr];
                              }
                          }
                      }
                  }
                  failedBolck:FAILED_BLOCK{
                          
                          [self removeWaitingView];
                          
                      }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.m_infoData.m_arrForm.count)
    {
        return 100+40;
    }
    
    ADTFormInfo *form = [self.m_infoData.m_arrForm objectAtIndex:indexPath.row];
    if([form.m_strFieldChineseName isEqualToString:@"附件:"])
    {
        NSInteger high = 20;
        if(self.m_infoData.m_arrAttachment.count == 0)
        {
            return 50;
        }
        for(ADTAttachmentInfo *info in self.m_infoData.m_arrAttachment)
        {
            CGSize tipsize = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
            CGSize size = [FontSizeUtil sizeOfString:info.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(tipsize.width+5)-40];
            high+=size.height;
        }
        return high;
    }else if([form.m_strFieldChineseName isEqualToString:@"正文:"])
    {
        
        CGSize tipsize = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
        
        ADTMainBodyInfo *info = [self.m_infoData.m_arrDocument firstObject];
        CGSize size = [FontSizeUtil sizeOfString:info.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(tipsize.width+5)-40];
        if((int)size.height == 0)
        {
            return 20+30;
        }
       return 20+size.height;
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
        CGSize contentSize = [FontSizeUtil sizeOfString:form.m_strFieldValue withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-( size.width+5+5)];
        return 30+contentSize.height;
        
    }

    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_infoData.m_arrForm.count+(self.m_infoData.m_isReadOnly ? 0 : 1);
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == self.m_infoData.m_arrForm.count )
    {
        if(self.m_infoData.m_arrForm.count> 0)
        {
            contentLab = [[UITextView alloc]initWithFrame:CGRectMake(10,0,MAIN_WIDTH-20,100)];
            contentLab.delegate = self;
            if(self.m_infoData.m_strOption.length > 0)
            {
                [contentLab setText:self.m_infoData.m_strOption];

            }
            else
            {
                [contentLab setText:@"请输入您的意见"];

            }
            contentLab.returnKeyType = UIReturnKeyDone;
            [contentLab setBackgroundColor:UIColorFromRGB(0Xf9f9f9)];
            contentLab.layer.cornerRadius = 4;
            contentLab.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
            contentLab.layer.borderWidth = 0.5;
            [contentLab setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:contentLab];

            UIButton *savePhraseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [savePhraseBtn setFrame:CGRectMake(0, CGRectGetMaxY(contentLab.frame), MAIN_WIDTH/2, 30)];
            [savePhraseBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            [savePhraseBtn addTarget:self action:@selector(savePhraseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [savePhraseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
            [savePhraseBtn setTitle:@"添加到常用短语" forState:UIControlStateNormal];
            savePhraseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [savePhraseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:savePhraseBtn];

            UIButton *selectPhraseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectPhraseBtn addTarget:self action:@selector(selectPhraseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [selectPhraseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [selectPhraseBtn setFrame:CGRectMake(MAIN_WIDTH/2, CGRectGetMaxY(contentLab.frame), MAIN_WIDTH/2, 30)];
            [selectPhraseBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            selectPhraseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [selectPhraseBtn setTitle:@"选择常用短语" forState:UIControlStateNormal];
            [selectPhraseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:selectPhraseBtn];
        }
      
        return cell;
    }
    ADTFormInfo *form = [self.m_infoData.m_arrForm objectAtIndex:indexPath.row];
    
    CGSize size = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, size.width, 15)];
    [tipLab setBackgroundColor:[UIColor clearColor]];
    [tipLab setText:form.m_strFieldChineseName];
    [tipLab setFont:[UIFont systemFontOfSize:14]];
    [tipLab setTextColor:[UIColor blackColor]];
    [cell addSubview:tipLab];
    if([form.m_strFieldChineseName isEqualToString:@"正文:"])
    {
        
        for(ADTMainBodyInfo *attach in self.m_infoData.m_arrDocument)
        {
            CGSize size = [FontSizeUtil sizeOfString:attach.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(CGRectGetMaxY(tipLab.frame))-40];

            UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            if(!self.m_infoData.m_isHandSign)
//            {
                [fileBtn addTarget:self action:@selector(documentFileInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//            }
            if(size.width+CGRectGetMaxY(tipLab.frame)+10 > MAIN_WIDTH-40)
            {
                size = CGSizeMake(MAIN_WIDTH-40 - (CGRectGetMaxY(tipLab.frame)+10), size.height);
            }
            fileBtn.tag = [self.m_infoData.m_arrAttachment indexOfObject:attach];
            [fileBtn setTitle:attach.m_strFileName  forState:UIControlStateNormal];
            [fileBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            fileBtn.titleLabel.numberOfLines = 0;
            [fileBtn setFrame:CGRectMake(CGRectGetMaxY(tipLab.frame)+10,10,size.width,size.height)];
            [cell addSubview:fileBtn];
            
            
            if(m_index == 0 || m_index == 1)
            {
                UIButton *qpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                qpBtn.hidden = !self.m_infoData.m_isHandSign;
//                qpBtn.hidden = YES;
                [qpBtn addTarget:self action:@selector(documentBtnCLicked) forControlEvents:UIControlEventTouchUpInside];
                [qpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [qpBtn setFrame:CGRectMake(CGRectGetMaxX(fileBtn.frame),(CGRectGetHeight(fileBtn.frame) -35)/2+CGRectGetMinY(fileBtn.frame), 40, 35)];
                [qpBtn setTitle:@"签批" forState:UIControlStateNormal];
                [qpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                qpBtn.layer.cornerRadius = 4;
                qpBtn.layer.borderColor = [UIColor grayColor].CGColor;
                qpBtn.layer.borderWidth = 0.5;
                [cell addSubview:qpBtn];
            }

        }

        
    }
    else if ([form.m_strFieldChineseName isEqualToString:@"附件:"])
    {
        
        NSInteger lastY = 10;
        
        for(ADTAttachmentInfo *attach in self.m_infoData.m_arrAttachment)
        {
            
            CGSize size = [FontSizeUtil sizeOfString:attach.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(CGRectGetMaxY(tipLab.frame))-40];
            
            UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(size.width+CGRectGetMaxY(tipLab.frame)+10 > MAIN_WIDTH-40)
            {
                size = CGSizeMake(MAIN_WIDTH-40 - (CGRectGetMaxY(tipLab.frame)+10), size.height);
            }
            
            [fileBtn addTarget:self action:@selector(attachmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            fileBtn.tag = [self.m_infoData.m_arrAttachment indexOfObject:attach];
            [fileBtn setTitle:attach.m_strFileName  forState:UIControlStateNormal];
            [fileBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
            fileBtn.titleLabel.numberOfLines = 0;
            [fileBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [fileBtn setFrame:CGRectMake(CGRectGetMaxX(tipLab.frame)+10,lastY,size.width,size.height)];
            [cell addSubview:fileBtn];
            lastY = CGRectGetMaxY(fileBtn.frame);
        }
        lastY+=10;
        
        
        [tipLab setFrame:CGRectMake(tipLab.frame.origin.x,self.m_infoData.m_arrAttachment.count == 0 ?17.5 : (lastY-tipLab.frame.size.height)/2, tipLab.frame.size.width, tipLab.frame.size.height)];

        
    }
    else
    {
        CGSize contentSize = [FontSizeUtil sizeOfString:form.m_strFieldValue withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(CGRectGetMaxX(tipLab.frame)+5)];
        UILabel *input = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab.frame)+5, 15, MAIN_WIDTH-(CGRectGetMaxX(tipLab.frame)+5), contentSize.height)];
        input.numberOfLines = 0;
        input.lineBreakMode = NSLineBreakByCharWrapping;
        [input setText:form.m_strFieldValue];
        input.userInteractionEnabled = form.m_isCanEdit;
        [input setFont:[UIFont systemFontOfSize:14]];
       // input.hidden = form.m_isHidden;
        [cell addSubview:input];

        
    }
    
    NSInteger high = 0;
    if(indexPath.row == self.m_infoData.m_arrForm.count)
    {
        high = 100+40;
    }
    
    if([form.m_strFieldChineseName isEqualToString:@"附件:"])
    {
        NSInteger high = 20;
        if(self.m_infoData.m_arrAttachment.count == 0)
        {
            high = 50;
        }
        for(ADTAttachmentInfo *info in self.m_infoData.m_arrAttachment)
        {
            CGSize tipsize = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
            CGSize size = [FontSizeUtil sizeOfString:info.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(tipsize.width+5)-40];
            high+=size.height;
        }
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,high-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [cell addSubview:sep];
        
    }
    else if([form.m_strFieldChineseName isEqualToString:@"正文:"])
    {
        CGSize tipsize = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
        
        ADTMainBodyInfo *info = [self.m_infoData.m_arrDocument firstObject];
        CGSize size = [FontSizeUtil sizeOfString:info.m_strFileName withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-(tipsize.width+5)-40];
        if((int)size.height == 0)
        {
            high = 20+30;
        }
        else
        {
            high = 20+size.height;
        }
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,high-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [cell addSubview:sep];
        
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:form.m_strFieldChineseName withFont:[UIFont systemFontOfSize:14]];
        CGSize contentSize = [FontSizeUtil sizeOfString:form.m_strFieldValue withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-( size.width+5+5)];
        high = 30+contentSize.height;
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,high-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:[UIColor grayColor]];
        sep.alpha = 0.4;
        [cell addSubview:sep];
        
    }
    return  cell;
}

- (void)savePhraseBtnClicked
{
    [self showWaitingView];
  [HTTP_MANAGER savePhraseToServerList:contentLab.text
                        successedBlock:^(NSDictionary *succeedResult) {
                            [self removeWaitingView];
                            NSDictionary *ret = [succeedResult[@"DATA"]mutableObjectFromJSONString];
                            if([ret[@"resultCode"] integerValue] == 0){
                                [PubllicMaskViewHelper showTipViewWith:@"短语添加成功!" inSuperView:self.view withDuration:1];
                            }else{
                                [PubllicMaskViewHelper showTipViewWith:@"短语添加失败!" inSuperView:self.view withDuration:1];
                            }


  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"短语添加失败!" inSuperView:self.view withDuration:1];
  }];

}


- (void)selectPhraseBtnClicked
{
    [self showWaitingView];
    [HTTP_MANAGER getTodoPhraseServerList:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        NSDictionary *ret = [succeedResult[@"DATA"]mutableObjectFromJSONString];
        if([ret[@"resultCode"] integerValue] == 0){

            NSArray *arr =ret[@"result"];
            UIActionSheet *act = [[UIActionSheet alloc]init];
            act.title = @"选择短语";
            for(NSDictionary *_phrase in arr){
                [act addButtonWithTitle:_phrase[@"phrase"]];
            }
            act.delegate = self;
            [act addButtonWithTitle:@"取消"];
            [act showInView:self.view];

        }else{
            [PubllicMaskViewHelper showTipViewWith:@"获取短语失败!" inSuperView:self.view withDuration:1];
        }



    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"获取短语失败!" inSuperView:self.view withDuration:1];


    }];
}



- (void)keyboardWillShow:(NSNotification *)notification
{
    NSInteger num =  self.m_infoData.m_arrForm.count+(self.m_infoData.m_isReadOnly ? 0 : 1);
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-50)];
    headVeiw.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), MAIN_WIDTH, 50);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-50)];
    headVeiw.frame = CGRectMake(0,MAIN_HEIGHT-50, MAIN_WIDTH, 50);

}

- (void)documentBtnCLicked
{
    [self showWaitingView];
    ADTMainBodyInfo *attach = [self.m_infoData.m_arrDocument firstObject];
    
    
    [HTTP_MANAGER downloadQPFileWithUrl:@".pdf"
                               params:
                                     @{
                                       @"resultCode":@"0",
                                       @"rettype":@"0",
                                       @"filetype":@".pdf",
                                       @"filebody":attach.m_strFileBody,
                                       @"filesize":@"0",
                                       @"fileid" :[[self.m_info stringWithFilted:@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
                                       @"doctype" : @(3),
                                       @"token"   : [LoginUserUtil accessToken]
                                       }
                         successBlock:^(NSDictionary *retDic){
                             
                             [self removeWaitingView];
                             self.m_pathFile = retDic[@"path"];
                             NSData *data = [NSData dataWithContentsOfFile:self.m_pathFile];
                             if(data.length == 0){
                                 [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                                 return ;
                             }
                             
                             SignPDFViewController *signPDFViewController = [[SignPDFViewController alloc]init];
                             signPDFViewController.PDFFilePath = self.m_pathFile;
                             [signPDFViewController callBackOfSave:^{
                                 
                                 [PubllicMaskViewHelper showTipViewWith:@"保存中,请稍候" inSuperView:[UIApplication sharedApplication].keyWindow withDuration:2];
                                 [self onSaveEditPDFCallBack];
                                 NSLog(@"保存回调成功！");
                             }];
                             [self.navigationController pushViewController:signPDFViewController animated:YES];
//
                             
//                             iAppPDFContentViewController *iappContentCtroller = [[iAppPDFContentViewController alloc] init];
//                             iappContentCtroller.m_delegate = self;
//                             
//                             app.signatureNameAp = @"Signature2";
//                             app.authorNameAp = @"admin";
//                             app.isMeettingFile = NO;
//                             app.isHaveCamera = NO;
//                             app.isCanChangeAuthor = YES;
//                             app.isCountersigned = YES;
//                             app.isPushCamera = NO;
//                             app.fileNameStr = attach.m_strFileName;
//                             app.signatureNameAp = @"hg";
//                             app.fileNameStr = retDic[@"path"];
//                             iappContentCtroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//                             [self.view.window.rootViewController presentViewController:iappContentCtroller animated:YES completion:nil];
//                             [self removeWaitingView];
                         }
                          failedBolck:FAILED_BLOCK{
                              
                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
    
    
}

- (void)attachmentBtnClicked:(UIButton *)btn
{
    [self showWaitingView];
    ADTAttachmentInfo *attach = [self.m_infoData.m_arrAttachment objectAtIndex:btn.tag];
    
    [HTTP_MANAGER downloadFileWithUrl:attach.m_strFileName
                               params:
     @{
       @"fileid" :attach.m_strFileId,
       @"userid" : [LoginUserUtil userId],
       @"doctype" : attach.m_docType,
       @"token"   : [LoginUserUtil accessToken],
       @"filename":attach.m_strFileName,
       @"recordid":attach.m_strRecordId,
       }
                         successBlock:^(NSDictionary *retDic){
                             
                             [self removeWaitingView];
                             FilePreviewViewController *info = [[FilePreviewViewController alloc]init];
                             info.fileLocalUrl = retDic[@"path"];
                             [self.navigationController pushViewController:info animated:YES];

                         }
                          failedBolck:FAILED_BLOCK{
                              
                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
}

- (void)documentFileInfoBtnClicked
{
    [self showWaitingView];
    ADTMainBodyInfo *attach = [self.m_infoData.m_arrDocument firstObject];

    [HTTP_MANAGER downloadFileWithUrl:attach.m_strFilleType
                               params:
     @{
       @"fileid" :attach.m_strFileId,
       @"userid" : [LoginUserUtil userId],
       @"doctype" : attach.m_strDocType,
       @"token"   : [LoginUserUtil accessToken],
       @"filename":attach.m_strFileName,
       @"recordid":attach.m_strRecordId,
       @"filetype":attach.m_strFilleType
       }
                         successBlock:^(NSDictionary *retDic){
                             
                             [self removeWaitingView];
                             FilePreviewViewController *info = [[FilePreviewViewController alloc]init];
                             info.fileLocalUrl = retDic[@"path"];
                             [self.navigationController pushViewController:info animated:YES];
                             
                         }
                          failedBolck:FAILED_BLOCK{
                              
                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:@"下载失败" inSuperView:self.view withDuration:1];
                              
                          }];
}

#pragma mark - iAppPDFContentViewControllerDelegate

- (void)onSaveEditPDFCallBack
{
    [self showWaitingView];
    [HTTP_MANAGER uploadPDFFileWithPath:self.m_pathFile
                           withFileData:[NSData dataWithContentsOfFile:self.m_pathFile]
                                 params:@{
                                       @"fileid" :[[self.m_info stringWithFilted:@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
                                       @"doctype" : @(3),
                                       @"token"   : [LoginUserUtil accessToken],
                                       @"rettype" : @(1)
                                     }
                        successBlock:^(NSDictionary *retDic){
                            
                            [self removeWaitingView];
                            [self requestData:YES];
                            
                        } failedBolck:FAILED_BLOCK{

                            [self removeWaitingView];
                            [self requestData:YES];
                            
                        }];
}

#pragma mark - ContactViewControllerDelegate
- (void)onSelected:(NSArray *)arrContacter
{
//    NSString *actor = nil;
//    if([[self.m_info stringWithFilted:@"actorclass"] integerValue]== 0 || [[self.m_info stringWithFilted:@"actorclass"] integerValue]== 3)
//    {
//        actor = @"Worker_";
//    }
//    else if ([[self.m_info stringWithFilted:@"actorclass"] integerValue]== 1)
//    {
//       actor = @"Reader_";
//    }
//    else if ([[self.m_info stringWithFilted:@"actorclass"] integerValue]== 2)
//    {
//        actor = @"Assist_";
//    }
//    else
//    {
//        actor = @"Worker_";
//    }
//    
    NSMutableArray *arr = [NSMutableArray array];
    for(ADTContacterInfo *info in arrContacter)
    {
        
        [arr addObject:@{
                            @"id" : @([arrContacter indexOfObject:info]),
                            @"nodeId":[self.m_retInfo stringWithFilted: @"linknodeid"],
                            @"nodeType":[self.m_retInfo stringWithFilted:@"linknodetype"],
                            @"userId":info.m_strUserID,
                            @"name":info.m_strUserName,
                            @"actorType":@"Worker_",
                            @"receiveType": @"",
                            @"waittype":self.m_retInfo[@"waittype"]
                        }];
    }
    
    NSDictionary *req = @{
                          @"receiverslist": arr,
                          @"linknodeid":self.m_retInfo[@"linknodeid"],
                          @"linknodetype":self.m_retInfo[@"linknodetype"],
                          @"actionid" :self.m_currentButton.m_strActionId,
                          @"userid" :[LoginUserUtil userId],
                          @"flowmodelid":self.m_infoData.m_strFlowModelId,
                          @"messageid":self.m_infoData.m_strMessageId,
                          @"important" : @(0),
                          @"subject":self.m_infoData.m_strSubject,
                          @"form" : self.m_infoData.m_arrOriginalForm,
                          @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                          @"cansms" : @(0),
                          };
    [self commitDirectly:req];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入您的意见"])
    {
        [textView setText:@""];
        return YES;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)backBtnClicked
{
    if(self.m_infoDelegate && [self.m_infoDelegate respondsToSelector:@selector(onCommitCompleted)])
    {
        [self.m_infoDelegate onCommitCompleted];
        
        NSArray *arr = self.navigationController.viewControllers;
        for(UIViewController *vc in arr){
            if([vc isKindOfClass:NSClassFromString(@"DepartmentReceiveArticeViewController")]){
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TodoCommitContactsViewControllerDelegate

- (void)seleteMutilContacts:(NSArray *)arr
{
    TodoCommitContactsViewController *vc=  [[TodoCommitContactsViewController alloc]initWithSelectMode:NO withDataSource:arr];
    vc.m_selectDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onTodoCommitContactsViewControllerSelected:(NSArray *)arrContacts
{
    NSMutableArray *arr = [NSMutableArray array];
    for(ADTContacterInfo *info in arrContacts)
    {
        
        [arr addObject:@{
                         @"id" : @([arrContacts indexOfObject:info]),
                         @"nodeId":[self.m_retInfo stringWithFilted: @"linknodeid"],
                         @"nodeType":[self.m_retInfo stringWithFilted:@"linknodetype"],
                         @"userId":info.m_strUserID,
                         @"name":info.m_strUserName,
                         @"actorType":@"Worker_",
                         @"receiveType": @"",
                         @"waittype":self.m_retInfo[@"waittype"]
                         }];
    }
    
    NSDictionary *req = @{
                          @"receiverslist": arr,
                          @"linknodeid":self.m_retInfo[@"linknodeid"],
                          @"linknodetype":self.m_retInfo[@"linknodetype"],
                          @"actionid" :self.m_currentButton.m_strActionId,
                          @"userid" :[LoginUserUtil userId],
                          @"flowmodelid":self.m_infoData.m_strFlowModelId,
                          @"messageid":self.m_infoData.m_strMessageId,
                          @"important" : @(0),
                          @"subject":self.m_infoData.m_strSubject,
                          @"form" : self.m_infoData.m_arrOriginalForm,
                          @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                          @"cansms" : @(0),
                          };
    [self commitDirectly:req];
}
#pragma mark - SpePDFEditViewControllerDelegate

- (void)onSavedNewPDF:(NSString *)localFilePath
{
    [self showWaitingView];
    [HTTP_MANAGER uploadPDFFileWithPath:localFilePath
                           withFileData:[NSData dataWithContentsOfFile:localFilePath]
                                 params:@{
                                          @"fileid" :[[self.m_info stringWithFilted:@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
                                          @"doctype" : @(3),
                                          @"token"   : [LoginUserUtil accessToken],
                                          @"rettype" : @(1)
                                          }
                           successBlock:^(NSDictionary *retDic){
                               
                               [self removeWaitingView];
                               
                           } failedBolck:FAILED_BLOCK{
                               
                               
                               [self removeWaitingView];
                               
                           }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *_content = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([_content isEqualToString:@"取消"]){
        return;
    }

    self.m_infoData.m_strOption = _content;
    contentLab.text = _content;

}
@end
