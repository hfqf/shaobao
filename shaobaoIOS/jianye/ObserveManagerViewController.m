//
//  ObserveManagerViewController.m
//  jianye
//
//  Created by points on 2017/2/10.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ObserveManagerViewController.h"
#import "ObserberInfoViewController.h"
@interface ObserveManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ObserveManagerViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"请输入查询关键字"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
    }
    return self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
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
    [self requestData:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"督查督办"];
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


- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    if(isRefresh)
    {
        self.m_currentIndex = 0;
    }
    else
    {
        self.m_currentIndex++;
    }

    [HTTP_MANAGER getObserverList:self.m_currentIndex
                          subject:m_searchBar.text
                   successedBlock:^(NSDictionary *succeedResult) {
        
                       [self removeWaitingView];
                       
                       if(isRefresh)
                       {
                           NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                           self.m_arrData = ret[@"result"];
                           [self reloadDeals];
                       }
                       else
                       {
                           NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                           NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                           [arr addObjectsFromArray:ret[@"result"]];
                           self.m_arrData = arr;
                           [self reloadDeals];
                       }
                       
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [self reloadDeals];
        
    }];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,120, 18)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:UIColorFromRGB(0x2f2f2f)];
    [tip setFont:[UIFont systemFontOfSize:16]];
    [tip setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:tip];
    
    CGSize size = [FontSizeUtil sizeOfString:[info stringWithFilted:@"documentSubject"] withFont:[UIFont systemFontOfSize:16] withWidth:MAIN_WIDTH/2];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+10,10, MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+10), size.height)];
    time.textAlignment = NSTextAlignmentLeft;
    time.numberOfLines = 0;
    [time setTextAlignment:NSTextAlignmentLeft];
    [time setTextColor:UIColorFromRGB(0x2f2f2f)];
    [time setFont:[UIFont systemFontOfSize:14]];
    [time setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:time];
    
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(20,35, 120, 18)];
    [state setTextAlignment:NSTextAlignmentLeft];
    [state setTextColor:UIColorFromRGB(0x787878)];
    [state setFont:[UIFont systemFontOfSize:14]];
    [state setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:state];
    
    NSString *type = nil;
    NSInteger docType = [[info stringWithFilted:@"documentType"]integerValue];
    if (docType == 0) {
        type=@"";
    } else if (docType==1) {
        type=@"【上级督查】";
    }else if(docType ==2) {
        type=@"【会议决定】";
    }else if(docType ==3) {
        type=@"【领导批示】";
    }else if(docType==4) {
        type=@"【决策部署】";
    }else if(docType==5) {
        type=@"【市长信箱】";
    }else if(docType==6) {
        type=@"【区长信箱】";
    }else if(docType==7) {
        type=@"【人民来信】";
    }else if(docType==8) {
        type=@"【每日一报】";
    }else if(docType==9) {
        type=@"【社情民意】";
    }else if(docType==10) {
        type=@"【人大建议】";
    }else if(docType==11) {
        type=@"【政协提案】";
    }else if(docType==12) {
        type=@"【建委督】";
    }else if(docType==13) {
        type=@"【建委办督】";
    }else if(docType==14) {
        type=@"【委督】";
    }else if(docType==15) {
        type=@"【省委书记信箱】";
    }else if(docType==16) {
        type=@"【市委书记信箱】";
    }else if(docType==17) {
        type=@"【区委书记信箱】";
    }else if(docType==18) {
        type=@"【舆情动态】";
    }else if(docType==19) {
        type=@"【政务督查】(经济建设)";
    }else if(docType==20) {
        type=@"【政务督查】(城建城管)";
    }else if(docType==21) {
        type=@"【政务督查】(社会事业)";
    }else if(docType==22) {
        type=@"【政务督查】(信息化建设)";
    }else if(docType==23) {
        type=@"【政务服务】(12345)";
    }else if(docType==24) {
        type=@"【建政督】";
    }else if(docType==25) {
        type=@"【网络问政】";
    }
    
    CGSize tipSize = [FontSizeUtil sizeOfString:type withFont:tip.font withWidth:MAIN_WIDTH/2];
    [tip setFrame:CGRectMake(10, 10, tipSize.width, tipSize.height)];
    
    time.frame = CGRectMake(CGRectGetMaxX(tip.frame)+10,10, MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+10), size.height);
    
    NSInteger flowType = [[info stringWithFilted:@"status"]integerValue];
    NSString *flow = nil;
    if(flowType==0) {
        flow=@"";
    }else if(flowType==1) {
        flow=@"当前环节:待办";
    }else if(flowType==2) {
        flow=@"当前环节:在办";
    }else if(flowType==3) {
        flow=@"当前环节:办结";
    }
    else{
        flow=@"";
    }
    
    [tip setText:type];
    
    [time setText:[info stringWithFilted:@"documentSubject"]];
    
    [state setText:flow];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    ObserberInfoViewController *infoVc = [[ObserberInfoViewController alloc]initWith:info];
    [self.navigationController pushViewController:infoVc animated:YES];
}

@end
