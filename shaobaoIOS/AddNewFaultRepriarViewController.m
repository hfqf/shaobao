//
//  AddNewFaultRepriarViewController.m
//  jianye
//
//  Created by points on 2017/7/1.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNewFaultRepriarViewController.h"

#import "ADTGovermentFileInfo.h"
#import "FilePreviewViewController.h"
#import "ContactViewController.h"
#import "ADTGropuInfo.h"
#import "TodoProcessInfoViewController.h"
#import "TodoCheckInfoViewController.h"
#import "TodoCommitContactsViewController.h"
#import "AdtContacterInfo.h"

#import <SignPDFSDK/SignPDFViewController.h>

@interface AddNewFaultRepriarViewController ()<UITableViewDataSource,UITableViewDelegate,ContactViewControllerDelegate,UITextViewDelegate,TodoCommitContactsViewControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextView *contentLab;
    NSInteger m_index;
    UIView *headVeiw;
}

@property (nonatomic,strong) NSString *m_pathFile;
@property (nonatomic,copy) NSDictionary *m_retInfo;
@property (nonatomic,strong) ADTCommitButtonInfo *m_currentButton;
@property (nonatomic,strong)NSArray *m_arrCatelogList;
@property (nonatomic,strong)ADTFormInfo *m_form;
@property (nonatomic,assign)NSInteger m_CatelogListIndex;
@property (nonatomic,strong)UIPickerView *picer;
@end

@implementation AddNewFaultRepriarViewController

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
        [HTTP_MANAGER getTodoInfo:self.m_info[@"messageid"]
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
    int width = 100;
    UIButton *btnprocessBg1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnprocessBg1 addTarget:self action:@selector(processInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnprocessBg1 setTitle:@"处理过程" forState:UIControlStateNormal];
    [btnprocessBg1 setFrame:CGRectMake((MAIN_WIDTH/2)-width-20, 10, width, 30)];
    [btnprocessBg1 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    btnprocessBg1.layer.borderWidth = 0.5;
    btnprocessBg1.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
    btnprocessBg1.layer.cornerRadius = 4;
    [processBg addSubview:btnprocessBg1];
    
    UIButton *btnprocessBg2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnprocessBg2 addTarget:self action:@selector(checkInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnprocessBg2 setTitle:@"阅知情况" forState:UIControlStateNormal];
    [btnprocessBg2 setFrame:CGRectMake((MAIN_WIDTH/2)+20, 10, width, 30)];
    [btnprocessBg2 setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
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

    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width, MAIN_HEIGHT-64-50)];
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
    [self showWaitingView];
    [HTTP_MANAGER saveFaultRepair:nil
                    WithMessageId:self.m_infoData.m_strMessageId
                      WithInnerId:self.m_infoData.m_strInnerid
                  WithFlowmodelid:self.m_infoData.m_strFlowModelId
                        withForms:self.m_infoData.m_arrOriginalFormForFaultRepair
                successedBlock:^(NSDictionary *retDic){
                    [self removeWaitingView];
                    if([retDic[@"RESULT"]integerValue] == 0)
                    {
                        NSDictionary *ret  = [retDic[@"DATA"]mutableObjectFromJSONString];
                        
                        [HTTP_MANAGER getFaultRepairInfo:ret[@"result"]
                                          successedBlock:^(NSDictionary *retDic){
                                              
                                              [self removeWaitingView];
                                              ADTGovermentFileInfo *flow = [ADTGovermentFileInfo getInfoFrom:retDic];
                                              self.m_infoData = flow;
                                              [self createFooterView];
                                              [self reloadDeals];
                                              
                                          } failedBolck:FAILED_BLOCK{
                                              
                                              [self removeWaitingView];
                                              
                                          }];
                        
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

- (void)commitForDetail
{
    
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

- (void)commitClickedForAddNewRep{
    
    [self showWaitingView];
    [HTTP_MANAGER saveFaultRepair:nil
                    WithMessageId:self.m_infoData.m_strMessageId
                      WithInnerId:self.m_infoData.m_strInnerid
                  WithFlowmodelid:self.m_infoData.m_strFlowModelId
                        withForms:self.m_infoData.m_arrOriginalFormForFaultRepair
                   successedBlock:^(NSDictionary *retDic){
                       [self removeWaitingView];
                       if([retDic[@"RESULT"]integerValue] == 0)
                       {
                           NSDictionary *ret  = [retDic[@"DATA"]mutableObjectFromJSONString];
                           
                           [HTTP_MANAGER getFaultRepairInfo:ret[@"result"]
                                             successedBlock:^(NSDictionary *retDic){
                                                 
                                                 [self removeWaitingView];
                                                 ADTGovermentFileInfo *flow = [ADTGovermentFileInfo getInfoFrom:retDic];
                                                 self.m_infoData = flow;
                                                 
                                                 [self commitForDetail];
                                                 
                                             } failedBolck:FAILED_BLOCK{
                                                 
                                                 [self removeWaitingView];
                                                 
                                             }];
                           
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
    if(m_index == 0){//详情页
        [self commitForDetail];
        
    }else{//新增页
        
        [self commitClickedForAddNewRep];
    }
    
 
    
}

- (void)giveUpClicked
{

    [self showWaitingView];
    [HTTP_MANAGER giveUpTodo:@{
                               @"userId":[LoginUserUtil userId],
                               @"messageId":self.m_infoData.m_strMessageId,
                               @"important":@(0),
                               @"opinion":@""
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
    [HTTP_MANAGER commitFaultRepair:reqDic
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
                                @"form" : self.m_infoData.m_arrOriginalFormForFaultRepair,
                                @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                @"innerId":self.m_infoData.m_strInnerid
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
                                                                                                        @"form" : self.m_infoData.m_arrOriginalFormForFaultRepair,
                                                                                                        @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                                                                                        @"innerId":self.m_infoData.m_strInnerid

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
                                                    @"form" : self.m_infoData.m_arrOriginalFormForFaultRepair,
                                                    @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                                                    @"innerId":self.m_infoData.m_strInnerid

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

#define INPUT_HIGH 0;
#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.m_infoData.m_arrForm.count)
    {
        return INPUT_HIGH;
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
//            contentLab = [[UITextView alloc]initWithFrame:CGRectMake(10,0,MAIN_WIDTH-20,100)];
//            contentLab.delegate = self;
//            if(self.m_infoData.m_strOption.length > 0)
//            {
//                [contentLab setText:self.m_infoData.m_strOption];
//                
//            }
//            else
//            {
//                [contentLab setText:@" "];
//                
//            }
//            contentLab.returnKeyType = UIReturnKeyDone;
//            [contentLab setBackgroundColor:UIColorFromRGB(0Xf9f9f9)];
//            contentLab.layer.cornerRadius = 4;
//            contentLab.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
//            contentLab.layer.borderWidth = 0.5;
//            [contentLab setFont:[UIFont systemFontOfSize:14]];
//            [cell addSubview:contentLab];
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
        if(!form.m_isHidden){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab.frame)+5, 5, MAIN_WIDTH-(CGRectGetMaxX(tipLab.frame)+5)-10, 35)];
            input.tag = indexPath.row;
            input.delegate = self;
         
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setText:form.m_strFieldValue];
            if(form.m_filedType == enum_date){
                input.inputView = [self getSelectTimePicker:indexPath];
            }
            
            input.userInteractionEnabled = form.m_isCanEdit;
            if(form.m_isCanEdit){
                input.layer.cornerRadius = 2;
                input.layer.borderColor = [UIColor lightGrayColor].CGColor;
                input.layer.borderWidth = 0.5;
            }
            
            if(form.m_filedType == enum_investigate){
                self.m_CatelogListIndex = indexPath.row;
                self.m_form = form;
                self.m_arrCatelogList = form.m_arrCatelogList;
                
                
                for(NSDictionary *_info in self.m_arrCatelogList){
                    if([_info[@"dictCode"]integerValue] == [form.m_strFieldValue integerValue]){
                        [input setText:_info[@"catalogName"]];
                    }
                }

                 if(form.m_isCanEdit){
                     input.inputView = [self getInvestigateView:indexPath withData:self.m_arrCatelogList];
                 }
            }
            [cell addSubview:input];
        }
    }
    
    NSInteger high = 0;
    if(indexPath.row == self.m_infoData.m_arrForm.count)
    {
        high = 100;
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

- (void)cancelgetInvestigateBtnClicked
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.m_CatelogListIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (UIView *)getInvestigateView:(NSIndexPath *)indexPath withData:(NSArray *)arr
{
    UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelgetInvestigateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
    [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    [inputBg addSubview:cancelBtn];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked2) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
    [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    [inputBg addSubview:confirmBtn];
   
    self.picer = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH, 140)];
    self.picer.delegate = self;
    self.picer.dataSource = self;
    self.picer.showsSelectionIndicator = YES;
    [self.picer reloadAllComponents];
    [inputBg addSubview:self.picer];
    return inputBg;
}

- (void)confirmBtnClicked2
{
    NSMutableDictionary *info = [self.m_arrCatelogList objectAtIndex:[self.picer selectedRowInComponent:0]];
    self.m_form.m_strFieldValue = info[@"dictCode"];
   
    NSMutableDictionary *formDic = [self.m_infoData.m_arrOriginalFormForFaultRepair objectAtIndex:self.m_CatelogListIndex];
    [formDic setValue:self.m_form.m_strFieldValue forKey:@"fieldvalue"];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.m_CatelogListIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:[picker date]];
            
            
            if(self.m_infoData.m_arrForm.count > picker.tag){
            ADTFormInfo *form = [self.m_infoData.m_arrForm objectAtIndex:picker.tag];
            form.m_strFieldValue = dateString;
            
            NSMutableDictionary *formDic = [self.m_infoData.m_arrOriginalFormForFaultRepair objectAtIndex:picker.tag];
            [formDic setValue:dateString forKey:@"fieldvalue"];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:picker.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.m_infoData.m_arrForm.count > textField.tag ){
        ADTFormInfo *form = [self.m_infoData.m_arrForm objectAtIndex:textField.tag];
        if(form.m_filedType == enum_date || form.m_filedType == enum_investigate){
            return ;
        }
        form.m_strFieldValue = textField.text;
        NSMutableDictionary *formDic = [self.m_infoData.m_arrOriginalFormForFaultRepair objectAtIndex:textField.tag];
        [formDic setValue:textField.text forKey:@"fieldvalue"];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (void)documentBtnCLicked
{
    [self showWaitingView];
    ADTMainBodyInfo *attach = [self.m_infoData.m_arrDocument firstObject];
    
    
    [HTTP_MANAGER downloadQPFileWithUrl:@".pdf"
                                 params:
     @{
       @"fileid" :[self.m_info[@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
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
                                          @"fileid" :[self.m_info[@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
                                          @"doctype" : @(3),
                                          @"token"   : [LoginUserUtil accessToken],
                                          @"rettype" : @(1)
                                          }
                           successBlock:^(NSDictionary *retDic){
                               
                               [self removeWaitingView];
                               [[NSFileManager defaultManager]removeItemAtPath:self.m_pathFile error:nil];
                               self.m_infoData = nil;
                               [self requestData:YES];
                               
                               [self.navigationController popViewControllerAnimated:YES];
                           } failedBolck:FAILED_BLOCK{
                               [[NSFileManager defaultManager]removeItemAtPath:self.m_pathFile error:nil];
                               
                               [self removeWaitingView];
                               self.m_infoData = nil;
                               [self requestData:YES];
                               
                               [self.navigationController popViewControllerAnimated:YES];
                               
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
                          @"form" : self.m_infoData.m_arrOriginalFormForFaultRepair,
                          @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                          @"innerId":self.m_infoData.m_strInnerid

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
                          @"form" : self.m_infoData.m_arrOriginalFormForFaultRepair,
                          @"opinion" : contentLab.text == nil ? @"" : contentLab.text,
                          @"innerId":self.m_infoData.m_strInnerid
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
                                          @"fileid" :[self.m_info[@"apptype"]integerValue] == 10 ? [NSString stringWithFormat:@"%@_s_cebx_%@",self.m_infoData.m_strInnerid,self.m_infoData.m_strMessageId] : [NSString stringWithFormat:@"%@_r_cebx",self.m_infoData.m_strInnerid] ,
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.m_arrCatelogList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *info = [self.m_arrCatelogList objectAtIndex:row];
    return info[@"catalogName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
@end
