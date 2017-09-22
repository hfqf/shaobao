//
//  FindViewController.m
//  shaobao
//
//  Created by points on 2017/9/16.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindViewController.h"

@interface FindViewController ()<UITableViewDataSource,UITableViewDelegate>

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.m_arrData.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

@end
