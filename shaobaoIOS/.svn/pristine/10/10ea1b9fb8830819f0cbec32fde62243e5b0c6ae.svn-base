//
//  TodoCommitContactsViewController.m
//  jianye
//
//  Created by points on 2017/4/24.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "TodoCommitContactsViewController.h"
#import "ADTGropuInfo.h"
@interface TodoCommitContactsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(assign)BOOL m_isSingle;

@property(nonatomic,strong)NSMutableArray *m_arrSelected;
@end

@implementation TodoCommitContactsViewController


- (id)initWithSelectMode:(BOOL)isSingle withDataSource:(NSArray *)arr
{
    self.m_arrData = arr;
    self.m_isSingle = isSingle;
    if(self=[super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.m_arrSelected = [NSMutableArray array];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"环节人员选择"];
    
    UIButton *confrimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confrimBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confrimBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [confrimBtn setFrame:CGRectMake(MAIN_WIDTH-50,DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [navigationBG addSubview:confrimBtn];
}

- (void)confrimBtnClicked
{
    for(ADTContacterInfo *info in self.m_arrData)
    {
        if(info.isSelected)
        {
            [self.m_arrSelected addObject:info];
        }
    }
    
    if(self.m_arrSelected.count == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"还未选择联系人" inSuperView:self.view  withDuration:1];
    }
    else
    {
        [self.m_selectDelegate onTodoCommitContactsViewControllerSelected:self.m_arrSelected];
        [self backBtnClicked];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ADTContacterInfo * data = [self.m_arrData objectAtIndex:indexPath.row];

    UILabel *m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, MAIN_WIDTH-20, 20)];
    m_nameLab.numberOfLines = 0;
    [m_nameLab setText:data.m_strUserName];
    m_nameLab.lineBreakMode = NSLineBreakByCharWrapping;
    [m_nameLab setBackgroundColor:[UIColor clearColor]];
    [m_nameLab setTextColor:[UIColor blackColor]];
    [m_nameLab setFont:[UIFont boldSystemFontOfSize:16]];
    [cell addSubview:m_nameLab];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:[UIColor grayColor]];
    sep.alpha = 0.3;
    [cell addSubview:sep];
    
    UIButton *_selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.tag = indexPath.row;
    [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setFrame:CGRectMake(MAIN_WIDTH-50, 5, 30, 30)];
    [_selectBtn setImage:[UIImage imageNamed:data.isSelected ?@"btn_checked" : @"btn_unchecked"] forState:UIControlStateNormal];
    [cell addSubview:_selectBtn];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


- (void)selectBtnClicked:(UIButton *)btn
{
    ADTContacterInfo * data = [self.m_arrData objectAtIndex:btn.tag];
    data.isSelected = !data.isSelected;
    [self reloadDeals];

    
}



@end
