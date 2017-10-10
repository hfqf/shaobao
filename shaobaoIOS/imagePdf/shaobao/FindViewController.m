//
//  FindViewController.m
//  shaobao
//
//  Created by points on 2017/9/16.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindViewController.h"
#import "FindFilterView.h"
#import "SelectProviceViewController.h"
#import "ADTFindItem.h"
#import "FindTableViewCell.h"
#import "FindRequureInfoViewController.h"
#import "FindSenderInfoViewController.h"
#import "FindSendConfirmOrderViewController.h"
@interface FindViewController ()<UITableViewDataSource,UITableViewDelegate,FindFilterViewDelegate,FindTableViewCellDelegate>
@property(nonatomic,strong) FindFilterView *m_filterView;
@end

@implementation FindViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    [title setText:@"发现"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, 20, 60, 44)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [navigationBG addSubview:rightBtn];

    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setFrame:CGRectMake(0, 20, 60, 44)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [navigationBG addSubview:filterBtn];
}

- (void)rightBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"SendHelpViewController") alloc]init] animated:YES];
}

- (void)filterBtnClicked
{
    self.m_filterView = [[FindFilterView alloc]initWithFrame:MAIN_FRAME];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_filterView];
    self.m_filterView.m_delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER findGetHelpList:self.m_filterView.m_type
                         userType:[LoginUserUtil shaobaoUserType]
                           status:self.m_filterView.m_state
                          provice:self.m_filterView.m_area[@"provice"][@"id"]
                             city:self.m_filterView.m_area[@"city"][@"id"]
                           county:self.m_filterView.m_area[@"area"][@"id"]
                        startTime:self.m_filterView.m_startTime
                          endTime:self.m_filterView.m_endTime
                           helpId:@"0"
                         pageSize:@"20"
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       if([succeedResult[@"ret"]integerValue] == 0){
                           NSMutableArray *arr = [NSMutableArray array];
                           for(NSDictionary *info in  succeedResult[@"data"]){
                               ADTFindItem *item = [ADTFindItem from:info];
                               [arr addObject:item];
                           }
                           self.m_arrData = arr;
                       }
                       [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
         [self reloadDeals];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.m_arrData.count;
}
- (CGFloat)highOf:(ADTFindItem *)currentData
{
    CGFloat high = 40;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:15] withWidth:(MAIN_WIDTH-(20+70))];
    high+=size.height;
    high+=20;

    if(currentData.m_userType.integerValue == 1){
        high+=20;
    }

    NSInteger row = ceil(currentData.m_arrPics.count/3.0);
    NSInteger sep = 10;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-(70+sep*(cell_num+1)))/3;
    high+= (sep+width)*row;
    high+=50;
    return high;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:[self.m_arrData objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindTableViewCell *cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.m_delegate = self;
    cell.currentData = [self.m_arrData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTFindItem *data = [self.m_arrData objectAtIndex:indexPath.row];
    if(data.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue){
        if(data.m_status.integerValue == 0){
            FindSendConfirmOrderViewController *order = [[FindSendConfirmOrderViewController alloc]initWith:data];
            [self.navigationController pushViewController:order animated:YES];
        }else if(data.m_status.integerValue == 1){
            FindSenderInfoViewController *info = [[FindSenderInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }else if(data.m_status.integerValue == 2){
            FindSenderInfoViewController *info = [[FindSenderInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }
    }

}

- (void)onSelectArea
{
    self.m_filterView.hidden= YES;
    SelectProviceViewController *select = [[SelectProviceViewController alloc]init];
    select.m_delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

#pragma mark -
- (void)onSelectedProvice:(NSDictionary *)pInfo withCity:(NSDictionary *)cInfo withArea:(NSDictionary *)aInfo
{
    self.m_filterView.hidden= NO;
    NSMutableDictionary *area = [NSMutableDictionary dictionary];
    [area setObject:pInfo forKey:@"provice"];
    [area setObject:cInfo forKey:@"city"];
    [area setObject:aInfo forKey:@"area"];
    self.m_filterView.m_area = area;
    [self reloadDeals];
}

- (void)onFindFilterViewDelegateSelected:(BOOL)isSaller withArea:(NSDictionary *)area withType:(NSString *)type withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withState:(NSString *)state
{
    self.m_filterView.hidden= YES;
    [self requestData:YES];
}

#pragma mark - FindTableViewCell

- (void)onDelete:(ADTFindItem *)data
{

}

- (void)onAccept:(ADTFindItem *)data
{
    FindRequureInfoViewController *info = [[FindRequureInfoViewController alloc]initWith:data];
    [self.navigationController pushViewController:info animated:YES];
}
@end
