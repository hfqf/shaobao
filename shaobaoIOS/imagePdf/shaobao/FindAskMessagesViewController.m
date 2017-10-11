//
//  FindAskMessagesViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindAskMessagesViewController.h"
#import "SendMsgViewController.h"
@interface FindAskMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)ADTFindItem *m_helpInfo;
@end

@implementation FindAskMessagesViewController
- (id)initWith:(ADTFindItem *)findInfo
{
    self.m_helpInfo = findInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"咨询消息"];
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER findGetMessageGroupList:self.m_helpInfo.m_id
                           successedBlock:^(NSDictionary *succeedResult) {
                               if([succeedResult[@"ret"]integerValue] == 0){
                                   self.m_arrData = succeedResult[@"data"];
                               }
                               [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self reloadDeals];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;


    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];

    EGOImageView *m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    m_head.layer.cornerRadius = 30;
    m_head.clipsToBounds = YES;
    [cell addSubview:m_head];
    [m_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BJ_SERVER,[info stringWithFilted:@"askUserAvatar"]]] placeholderImage:[UIImage imageNamed:@"logo"]];

    UILabel *m_userType = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_head.frame)+10, 60, 18)];
    [m_userType setTextAlignment:NSTextAlignmentCenter];
    [m_userType setTextColor:[UIColor blackColor]];
    [m_userType setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:m_userType];

    UILabel *m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,10,120, 18)];
    [m_nameLab setTextAlignment:NSTextAlignmentLeft];
    [m_nameLab setTextColor:[UIColor blackColor]];
    [m_nameLab setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:m_nameLab];
    [m_nameLab setText:[info stringWithFilted:@"askUserName"]];


    UILabel *m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120,10,110, 18)];
    [m_timeLab setTextAlignment:NSTextAlignmentRight];
    [m_timeLab setTextColor:UIColorFromRGB(0xc9c9c9)];
    [m_timeLab setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:m_timeLab];
    [m_timeLab setText:[[info stringWithFilted:@"createTime"]substringToIndex:10]];

    UILabel *m_content = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_nameLab.frame)+5,(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)), 40)];
    m_content.numberOfLines = 0;
    [m_content setTextAlignment:NSTextAlignmentLeft];
    [m_content setTextColor:UIColorFromRGB(0x999999)];
    [m_content setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:m_content];
    [m_content setText:[NSString stringWithFormat:@"最新回复:%@",[info stringWithFilted:@"lastMessageContent"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    ADTFindItem *item = [[ADTFindItem alloc]init];
    item.m_id = [info stringWithFilted:@"id"];
    item.m_isSender = YES;
    SendMsgViewController *send =[[SendMsgViewController alloc]initWith:item];
    [self.navigationController pushViewController:send animated:YES];
}

@end
