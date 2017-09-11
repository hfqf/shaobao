//
//  ContactDetailViewController.m
//  officeMobile
//
//  Created by Points on 15-3-12.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "FontSizeUtil.h"
@interface ContactDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ContactDetailViewController

- (id)initWith:(ADTContacterInfo *)contactInfo
{
    self.m_contactInfo = contactInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_contactInfo.m_strUserName];
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
   UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:[UIColor grayColor]];
    sep.alpha = 0.3;
    [cell addSubview:sep];
    
    if(indexPath.row == 0)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"姓名:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"姓名:"];
        [cell addSubview:titleLab];

        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        [contentLab setFont:[UIFont systemFontOfSize:14]];
        [contentLab setText:self.m_contactInfo.m_strUserName];
        [cell addSubview:contentLab];
        
    }
    else if (indexPath.row == 1)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"邮箱:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"邮箱:"];
        [cell addSubview:titleLab];
        
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        [contentLab setFont:[UIFont systemFontOfSize:14]];
        [contentLab setText:self.m_contactInfo.m_strEmail];
        [cell addSubview:contentLab];
    }
    else if (indexPath.row == 2)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"手机号码:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"手机号码:"];
        [cell addSubview:titleLab];
        
        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [telBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 40)];
        [telBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [telBtn addTarget:self action:@selector(telBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [telBtn setFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        [telBtn setTitle:self.m_contactInfo.m_strMobile forState:UIControlStateNormal];
        [telBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [cell addSubview:telBtn];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(smsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(MAIN_WIDTH-50, 2, 46, 36)];
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setTitle:@"短信" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:btn];
    }
    else if (indexPath.row == 3)
    {
        CGSize size = [FontSizeUtil sizeOfString:@"电话号码:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"电话号码:"];
        [cell addSubview:titleLab];
        
        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [telBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 40)];
        [telBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [telBtn addTarget:self action:@selector(shortTelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [telBtn setFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        [telBtn setTitle:self.m_contactInfo.m_strTel forState:UIControlStateNormal];
        [telBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [cell addSubview:telBtn];
        
//        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(size.width+40, 10,MAIN_WIDTH-size.width-10, size.height)];
//        [contentLab setTextColor:KEY_COMMON_CORLOR];
//        [contentLab setFont:[UIFont systemFontOfSize:16]];
//        [contentLab setText:self.m_contactInfo.m_strTel];
//        [cell addSubview:contentLab];
    }
    else
    {
        CGSize size = [FontSizeUtil sizeOfString:@"职务:" withFont:[UIFont systemFontOfSize:14]];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,size.width, size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"职务:"];
        [cell addSubview:titleLab];
        
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(size.width+10, 10,MAIN_WIDTH-size.width-10, size.height)];
        [contentLab setText:self.m_contactInfo.m_strJob];
        [contentLab setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:contentLab];
    }
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)smsBtnClicked
{
    if(self.m_contactInfo.m_strMobile.length > 0)
    {
      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.m_contactInfo.m_strMobile]]];
    }
}

- (void)telBtnClicked
{
    if(self.m_contactInfo.m_strMobile.length > 0)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.m_contactInfo.m_strMobile]]];
    }
}

- (void)shortTelBtnClicked
{
    if(self.m_contactInfo.m_strTel.length > 0)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.m_contactInfo.m_strTel]]];
    }
}

@end
