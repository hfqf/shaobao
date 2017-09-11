//
//  PublicFileViewController.m
//  officeMobile
//
//  Created by Points on 15-3-10.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "PublicFileViewController.h"
#import "ADTGovermentFileInfo.h"
@interface PublicFileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)ADTGovermentFileInfo *m_infoData;

@end

@implementation PublicFileViewController


- (id)initWithData:(NSDictionary *)data 
{
    self.m_currentData = data;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getTodoFileInfoWith:[self.m_currentData stringWithFilted:@"messageid"]
                       successedBlock:^(NSDictionary *retDic){
                       
                           self.m_infoData = [ADTGovermentFileInfo getInfoFrom:retDic];

                           [self reloadDeals];
                       } failedBolck:FAILED_BLOCK{
                        
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return  cell;
}



@end
