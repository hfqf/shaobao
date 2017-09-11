//
//  ResourceCentreViewController.m
//  jianye
//
//  Created by points on 2017/2/10.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ResourceCentreViewController.h"
#import "ResourceFileInfoViewController.h"
@interface ResourceCentreViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *m_arrCategoryMenu;
@property(nonatomic,strong)NSString *m_parentId;
@end

@implementation ResourceCentreViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:@{@"typeName":@"资源中心",
                                                                @"typeId":@""}];
        self.m_arrCategoryMenu = arr;
        self.tableView.tableHeaderView = [self getHeaderView];

        
     
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"资源中心"];
    backBtn.hidden = YES;
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}

- (UIView *)getHeaderView
{
    
    m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
    [m_searchBar setPlaceholder:@"请输入查询关键字"];
    [m_searchBar setDelegate:self];
    m_searchBar.showsCancelButton = YES;
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 60+HEIGHT_NAVIGATION)];
    [head addSubview:m_searchBar];
    for(NSDictionary *info in self.m_arrCategoryMenu)
    {
        NSInteger index = [self.m_arrCategoryMenu indexOfObject:info];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn setImage:[UIImage imageNamed:@"rc_right"] forState:UIControlStateNormal];
        [btn setTitle:info[@"typeName"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(20, 80, 20, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [btn setFrame:CGRectMake(index*100,HEIGHT_NAVIGATION, 100, 60)];
        [btn addTarget:self action:@selector(categoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
    }
    return head;
}

- (void)categoryBtn:(UIButton *)btn
{
    NSDictionary *info = [self.m_arrCategoryMenu objectAtIndex:btn.tag];
    [self getNextMenuList:[info stringWithFilted:@"typeId"]];
    
    if(btn.tag < self.m_arrCategoryMenu.count-1)
    {
        [self.m_arrCategoryMenu removeObjectsInRange:NSMakeRange(btn.tag+1, self.m_arrCategoryMenu.count-btn.tag-1)];
        self.tableView.tableHeaderView = [self getHeaderView];
    }
}


- (void)requestData:(BOOL)isRefresh
{
    [self getNextMenuList:self.m_parentId];
}


- (void)getNextMenuList:(NSString *)parentId
{
    self.m_parentId = parentId;
        [self showWaitingView];

    
        [HTTP_MANAGER getResourceCenterMenuList:parentId
                                 successedBlock:^(NSDictionary *succeedResult) {
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
             NSArray *arrNew =ret[@"result"];
             if(arrNew.count > 0)
             {
                 [arr addObjectsFromArray:arrNew];
             }
                                     
            if(parentId.length == 0)
            {
                [self removeWaitingView];
                self.m_arrData = arr;
                [self reloadDeals];
                return ;
            }
                
            
            [HTTP_MANAGER getResourceCenterList:parentId
                                       subjecet:m_searchBar.text
                                 successedBlock:^(NSDictionary *succeedResult) {
                                     
                                     [self removeWaitingView];
                                     NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                     NSArray *arrNew =ret[@"result"];
                                     if(arrNew.count > 0)
                                     {
                                         [arr addObjectsFromArray:arrNew];
                                     }
                                     self.m_arrData = arr;
                                     [self reloadDeals];
                                     
                                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                     
                                     [self removeWaitingView];
                                     [self reloadDeals];
                                     
                                 }];
            
            
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            
            [self removeWaitingView];
            [self reloadDeals];
            
        }];

        
        
   

}



#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if(info[@"level"] == nil)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        [icon setImage:[UIImage imageNamed:@"rc_file"]];
        [cell addSubview:icon];
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, MAIN_WIDTH/2, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:[info stringWithFilted:@"typeName"]];
        [cell addSubview:tip];
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(90,50, MAIN_WIDTH/2, 18)];
        [desc setTextAlignment:NSTextAlignmentLeft];
        [desc setTextColor:UIColorFromRGB(0x323232)];
        [desc setFont:[UIFont systemFontOfSize:14]];
        [desc setBackgroundColor:[UIColor clearColor]];
        [desc setText:[info stringWithFilted:@"subject"]];
        [cell addSubview:desc];
        
        
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,50, MAIN_WIDTH/2-2, 18)];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setTextColor:UIColorFromRGB(0x323232)];
        [time setFont:[UIFont systemFontOfSize:14]];
        [time setBackgroundColor:[UIColor clearColor]];
        [time setText:[NSString stringWithFormat:@"%@ %@",[info stringWithFilted:@"person"],[[info stringWithFilted:@"createTime"]substringToIndex:10]]];
        [cell addSubview:time];
    }
    else
    {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        [icon setImage:[UIImage imageNamed:[[info stringWithFilted:@"level"]integerValue] > 0 ? @"rc_dictionary" : @"rc_file"]];
        [cell addSubview:icon];
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(90, 26, MAIN_WIDTH/2, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:[info stringWithFilted:@"typeName"]];
        [cell addSubview:tip];
    }
   
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    
    if([info[@"level"] integerValue] > 0)
    {
        [self.m_arrCategoryMenu addObject:info];
        self.tableView.tableHeaderView = [self getHeaderView];
        [self getNextMenuList:info[@"typeId"]];
    }
    else
    {
        ResourceFileInfoViewController *infoVc = [[ResourceFileInfoViewController alloc]initWith:info];
        [self.navigationController pushViewController:infoVc animated:YES];
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getNextMenuList:self.m_parentId];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [self getNextMenuList:self.m_parentId];
}

@end
