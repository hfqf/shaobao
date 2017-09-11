//
//  AddNoticeGroupViewController.m
//  jianye
//
//  Created by points on 2017/2/25.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddNoticeGroupViewController.h"
#import "ContactTableViewCell.h"
@interface AddNoticeGroupViewController ()<UITableViewDelegate,UITableViewDataSource,ContactTableViewCellDelegate>
@property(nonatomic,strong)NSString *m_parentId;
@property(nonatomic,strong)NSMutableArray *m_arrSeleted;
@end

@implementation AddNoticeGroupViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.m_parentId = @"1";
        NSMutableArray *arr = [NSMutableArray array];
        self.m_arrSeleted = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"选择单位"];
    self.m_parentId = @"1";
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [clearBtn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setFrame:CGRectMake(MAIN_WIDTH-100,DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [navigationBG addSubview:clearBtn];
    
    UIButton *confrimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confrimBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confrimBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [confrimBtn setFrame:CGRectMake(MAIN_WIDTH-50,DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [navigationBG addSubview:confrimBtn];
}

- (void)requestData:(BOOL)isRefresh
{
    [self getUnits:nil];
}

- (void)getUnits:(ADTGropuInfo *)group
{
    [self showWaitingView];
    __block  NSMutableArray *arr = [NSMutableArray array];
    
    [HTTP_MANAGER getUnits:group == nil ? @"1" :[group.m_strDeptName isEqualToString:@"..返回上级"]?group.m_strParentId :  group.m_strDepId
            successedBlock:^(NSDictionary *succeedResult) {
                NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                NSArray *arrGroup = ret[@"result"];
                
                if(group)
                {
            
                        ADTGropuInfo *groupData  = [[ADTGropuInfo alloc]init];
                        groupData.isContactView = NO;
                        groupData.m_strParentId = group.m_strParentId;
                        groupData.m_strDepId =group.m_strDepId;
                        groupData.m_strDeptName = @"..返回上级";
                        [arr addObject:groupData];
                }
                
                for(NSDictionary *contact in arrGroup)
                {
                    ADTGropuInfo *groupData  = [[ADTGropuInfo alloc]init];
                    groupData.isContactView = NO;
                    groupData.m_strDepId = [contact stringWithFilted:@"deptId"];
                    groupData.m_strDeptName = [contact stringWithFilted:@"deptName"];
                    groupData.m_strParentId = [contact stringWithFilted:@"parentId"];
                    [arr addObject:groupData];
                }
                
                self.m_arrData = arr;
                [self reloadDeals];
                
            } failedBolck:FAILED_BLOCK{
                [self reloadDeals];
            }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTGropuInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    CGSize size = [FontSizeUtil sizeOfString:info.m_strDeptName withFont:[UIFont boldSystemFontOfSize:16] withWidth:MAIN_WIDTH-60];
    return size.height+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    ContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.m_delegate = self;
    ADTGropuInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    cell.currentData = info;
    return  cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTGropuInfo *group = [self.m_arrData objectAtIndex:indexPath.row];
    [self getUnits:group];
    
//    
//    ADTContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
//    info.isSelected= !info.isSelected;
//    if(info.isSelected)
//    {
//        [self.m_selectedContactDic setObject:info forKey:info.m_strUserID];
//        
//    }
//    else
//    {
//        [self.m_selectedContactDic removeObjectForKey:info.m_strUserID];
//    }
//    
//    if([info.m_strUserID isEqualToString:[LoginUserUtil userId]])
//    {
//        [self.m_selectedContactDic removeObjectForKey:info.m_strUserID];
//        [self reloadDeals];
//        [PubllicMaskViewHelper showTipViewWith:@"不能选择自己" inSuperView:self.view withDuration:1];
//        return;
//    }
//    
//    [self reloadDeals];
}



- (void)clearBtnClicked
{
    for(ADTContacterInfo *info in self.m_arrData)
    {
        info.isSelected = NO;
    }
    
    [self reloadDeals];
}

- (void)confrimBtnClicked
{
    if(self.m_arrSeleted.count == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"还未选择联系人" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onSelectedUnits:)])
    {
        [self backBtnClicked];
        [self.m_delegate onSelectedUnits:self.m_arrSeleted];
    }
    
}
#pragma mark - ContactTableViewCellDelegate

- (void)onSelected:(ADTGropuInfo *)info
{
    for(ADTGropuInfo *_info in self.m_arrData)
    {
        if(_info.isSelected)
        {
            for(ADTGropuInfo *selected in self.m_arrSeleted)
            {
                if([selected.m_strDepId isEqualToString: _info.m_strDepId])
                {
                    break;
                }
            }
            
            
            [self.m_arrSeleted addObject:_info];
        }
    }
}
@end
