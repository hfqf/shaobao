//
//  HomePageViewController.m
//  shaobao
//
//  Created by points on 2017/9/13.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#define  HIGH_ADS                      200

#import "HomePageViewController.h"
#import "MXCycleScrollView.h"
#import "HomeTableViewCell.h"
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,MXCycleScrollViewDelegate>
@property(nonatomic,strong)MXCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSArray *m_arrAds;

@end

@implementation HomePageViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM)];

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationBG.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{

    [HTTP_MANAGER findGetHelpList:@""
                         userType:[LoginUserUtil shaobaoUserType]
                           status:@""
                          provice:@""
                             city:@""
                           county:@""
                        startTime:@""
                          endTime:@""
                           helpId:@"0"
                         pageSize:@"20"
                   successedBlock:^(NSDictionary *succeedResult) {

                       [self reloadDeals];


    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];

    [self addAds];
}

- (UIView *)headereView:(NSArray *)arr
{
    NSMutableArray *arrPics = [NSMutableArray array];
    for(NSDictionary *info in arr){
        [arrPics addObject:[NSString stringWithFormat:@"http://121.196.222.155:8800/files%@",info[@"picUrl"]]];
    }
    self.cycleScrollView = [[MXCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HIGH_ADS) withContents:arrPics andScrollDelay:3.0];
    self.cycleScrollView.delegate = self;
    return self.cycleScrollView;
}

- (void)addAds{
    [HTTP_MANAGER getAds:@"1"
          successedBlock:^(NSDictionary *succeedResult) {

              NSArray *arr = succeedResult[@"data"];
              self.m_arrAds = arr;
              self.tableView.tableHeaderView =  [self headereView:arr];
              [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.m_arrData.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            return 40;
        }else{
            return 120;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSArray *arr = @[
                         @{
                             @"name":@"叫人帮忙",
                             @"icon":@"home_quick_0",
                             },
                         @{
                             @"name":@"律师侦探",
                             @"icon":@"home_quick_1",
                             },
                         @{
                             @"name":@"护卫保镖",
                             @"icon":@"home_quick_2",
                             },
                         @{
                             @"name":@"纠纷债务",
                             @"icon":@"home_quick_3",
                             },
                         @{
                             @"name":@"个性需求",
                             @"icon":@"home_quick_4",
                             },
                         ];
        for(NSDictionary *info in arr){
            NSInteger index = [arr indexOfObject:info];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSInteger width = MAIN_WIDTH/arr.count;
            [btn setFrame:CGRectMake(index*width, 0, width, 100)];
            [btn setImage:[UIImage imageNamed:info[@"icon"]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-10,0, 0, 0)];
            [cell addSubview:btn];
            [btn addTarget:self action:@selector(categoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(index*width,65, width, 15)];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [lab setTextColor:[UIColor blackColor]];
            [lab setFont:[UIFont systemFontOfSize:14]];
            [lab setText:info[@"name"]];
            [cell addSubview:lab];
        }
        return cell;
    }else{
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setBackgroundColor:[UIColor whiteColor]];
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,MAIN_WIDTH-20, 20)];
            [tip setText:@"最新发布"];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [tip setTextColor:UIColorFromRGB(0x5d5d5d)];
            [tip setFont:[UIFont systemFontOfSize:18]];
            [cell addSubview:tip];
            return cell;
        }else{
            NSString *iden1 = @"cell2";
            HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
            if(cell == nil){
                cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
            }
            cell.infoData= [self.m_arrData objectAtIndex:indexPath.row];
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 5)];
    [vi setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    return vi;
}

- (void)categoryBtn:(UIButton *)btn
{

}

#pragma mark - MXCycleScrollViewDelegate
- (void)clickImageIndex:(NSInteger)index {
    NSLog(@"pageViewDidTapIndex %ld",index);


}
@end
