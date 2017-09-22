//
//  FindFilterView.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindFilterView.h"

@implementation FindFilterView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:1.0/255/0 blue:1.0/255.0 alpha:0.5];
        m_table = [UITableView alloc]initWithFrame:CGRectMake(60, 64, MAIN_WIDTH-60, MAIN_HEIGHT-64) style:<#(UITableViewStyle)#>];
        [m_table setBackgroundColor:[UIColor whiteColor]];
        m_table.dataSource = self;
        m_table.delegate = self;
        [m_table reloadData];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)high:(NSIndexPath *)indexPath
{
    return indexPath.row == 5 ? 80 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
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
