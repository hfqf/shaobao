//
//  FindAskMessagesViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindAskMessagesViewController.h"

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
    return cell;
}

@end
