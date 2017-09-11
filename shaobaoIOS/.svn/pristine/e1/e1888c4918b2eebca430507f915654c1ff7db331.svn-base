//
//  TodoProcessInfoViewController.m
//  officeMobile
//
//  Created by Points on 15/11/2.
//  Copyright © 2015年 com.kinggrid. All rights reserved.
//

#import "TodoProcessInfoViewController.h"

@implementation TodoProcessInfoViewController

-(id)initWithInfo:(NSArray *)arr
{
    self.m_arrData = arr;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = UIColorFromRGB(0xededed);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"处理过程"];
    [self reloadDeals];
    
}



#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   60;
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
    UITableViewCell * cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    ADTProcessData *info = [self.m_arrData objectAtIndex:indexPath.row];
    UILabel *_title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, MAIN_WIDTH/2-5, 20)];
    [_title setTextColor:[UIColor blackColor]];
    [_title setBackgroundColor:[UIColor clearColor]];
    [_title setText:info.m_strProcesser];
    [_title setFont:[UIFont boldSystemFontOfSize:20]];
    [cell addSubview:_title];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 5, MAIN_WIDTH-10, 20)];
    [time setFont:[UIFont systemFontOfSize:13]];
    [time setTextColor:UIColorFromRGB(0x787878)];
    [time setBackgroundColor:[UIColor clearColor]];
    [time setText:info.m_strProcessTime];
    [cell addSubview:time];
    
    UILabel *prcess = [[UILabel alloc]initWithFrame:CGRectMake(5,35, MAIN_WIDTH-10, 20)];
    [prcess setFont:[UIFont systemFontOfSize:15]];
    [prcess setTextColor:UIColorFromRGB(0x787878)];
    [prcess setBackgroundColor:[UIColor clearColor]];
    [prcess setText:[NSString stringWithFormat:@"%@  %@",info.m_strNodeName, info.m_strOpinion]];
    [cell addSubview:prcess];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
@end
