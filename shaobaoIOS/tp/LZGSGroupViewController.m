//
//  LZGSGroupViewController.m
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "LZGSGroupViewController.h"
#import "AddLZGSGroupViewController.h"
#import "AddStaffViewController.h"

@interface LZGSGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@end

@implementation LZGSGroupViewController
- (id)initWith:(ADTGroupItem *)parent{
    self.m_currentGroup = parent;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"下属机构",@"下属员工"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH/self.m_arrCategory.count, 40)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+36, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame)-HEIGHT_MAIN_BOTTOM)];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestData:YES];
    
    
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == btn.tag)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_currentGroup.m_name == nil ? @"廉政公署":self.m_currentGroup.m_name];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 80, 44)];
    [rightBtn setTitle:@"新增" forState:UIControlStateNormal];
    [navigationBG addSubview:rightBtn];
    [self createButtons];
}



- (void)rightBtnClicked{
    if(![self.m_currentGroup.m_orgId isEqualToString:@"0"]){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新增下属机构",@"新增机构员工", nil];
        [act showInView:self.view];
    }else{
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新增下属机构", nil];
        [act showInView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestData:(BOOL)isRefresh
{
    NSString *orgId = @"0";
    if(self.m_currentIndex == 0){
        [self showWaitingView];

        if(isRefresh){
            
        }else{
            ADTGroupItem *group = [self.m_arrData lastObject];
            orgId = group.m_orgId;
        }
        [HTTP_MANAGER getOrgList:self.m_currentGroup.m_orgId
                           orgId:orgId
                        pageSize:@"10"
                  successedBlock:^(NSDictionary *succeedResult) {
                      if([succeedResult[@"ret"]integerValue]==0){
                          NSArray *arrRet = succeedResult[@"data"];
                          if(isRefresh){
                              NSMutableArray *arr = [NSMutableArray array];
                              for(NSDictionary *info in arrRet){
                                  ADTGroupItem *_group = [ADTGroupItem from:info];
                                  [arr addObject:_group];
                              }
                              self.m_arrData = arr;
                          }else{
                              NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                              for(NSDictionary *info in arrRet){
                                  ADTGroupItem *_group = [ADTGroupItem from:info];
                                  [arr addObject:_group];
                              }
                              self.m_arrData = arr;
                          }
                      }
                      [self reloadDeals];
                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                      [self reloadDeals];
                  }];
    }else{
        NSString *personId = @"0";
        if(isRefresh){
            
        }else{
            ADTStaffItem *staff = [self.m_arrData lastObject];
            personId = staff.m_id;
        }
        [HTTP_MANAGER getPersonList:self.m_currentGroup.m_orgId
                             userId:personId
                           pageSize:@"10"
                     successedBlock:^(NSDictionary *succeedResult) {
                         if([succeedResult[@"ret"]integerValue]==0){
                             NSArray *arrRet = succeedResult[@"data"];
                             if(isRefresh){
                                 NSMutableArray *arr = [NSMutableArray array];
                                 for(NSDictionary *info in arrRet){
                                     ADTStaffItem *_group = [ADTStaffItem from:info];
                                     [arr addObject:_group];
                                 }
                                 self.m_arrData = arr;
                             }else{
                                 NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                 for(NSDictionary *info in arrRet){
                                     ADTStaffItem *_group = [ADTStaffItem from:info];
                                     [arr addObject:_group];
                                 }
                                 self.m_arrData = arr;
                             }
                         }
                         [self reloadDeals];
                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                           [self reloadDeals];
                     }];
    }
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 1){
        ADTStaffItem *staff = [self.m_arrData objectAtIndex:indexPath.row];
        staff.m_isNew = NO;
        AddStaffViewController *add = [[AddStaffViewController alloc]initWith:self.m_currentGroup withStaff:staff];
        [self.navigationController pushViewController:add animated:YES];
        
    }else{
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看下属机构",@"查看本机构信息", nil];
        [act showInView:self.view];
        act.tag = indexPath.row;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden1 = @"cell2";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    ADTGroupItem *group = [self.m_arrData objectAtIndex:indexPath.row];
    [cell.textLabel setText:group.m_name];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,39.6, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:GRAY_3];
    [cell addSubview:sep];
    return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[actionSheet buttonTitleAtIndex:0] isEqualToString:@"查看下属机构"]){
        if(buttonIndex == 0){
            ADTGroupItem *group = [self.m_arrData objectAtIndex:actionSheet.tag];
            LZGSGroupViewController *list = [[LZGSGroupViewController alloc]initWith:group];
            [self.navigationController pushViewController:list animated:YES];
        }else if (buttonIndex == 1){
            ADTGroupItem *group = [self.m_arrData objectAtIndex:actionSheet.tag];
            AddLZGSGroupViewController *add  =[[AddLZGSGroupViewController alloc]initWith:group];
            [self.navigationController pushViewController:add animated:YES];
        }else{
            
        }
    }else{
        if(buttonIndex == 0){
            ADTGroupItem *group = self.m_currentGroup;
            ADTGroupItem *_group = [[ADTGroupItem alloc]init];
            _group.m_isNew = YES;
            _group.m_parentId = group.m_id;
            AddLZGSGroupViewController *add = [[AddLZGSGroupViewController alloc]initWith:_group];
            [self.navigationController pushViewController:add animated:YES];
        }else if (buttonIndex == 1){
            if([self.m_currentGroup.m_orgId isEqualToString:@"0"]){
                
            }else{
                ADTStaffItem *staff = [[ADTStaffItem alloc]init];
                staff.m_isNew = YES;
                AddStaffViewController *add = [[AddStaffViewController alloc]initWith:self.m_currentGroup withStaff:staff];
                [self.navigationController pushViewController:add animated:YES];
            }
        }else{
            
        }
    }
}


@end
