//
//  SettingViewController.m
//  officeMobile
//
//  Created by Points on 15-3-8.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSDictionary *m_versionDic;
@end

@implementation SettingViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"设置"];
    [self reloadDeals];
    
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell * cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setText:@"地址设置"];

//    if(indexPath.row == 0)
//    {
//        [cell.textLabel setText:@"版本检测"];
//    }
//    else if (indexPath.row ==1)
//    {
//        [cell.textLabel setText:@"地址设置"];
//    }
//    else if (indexPath.row ==2)
//    {
//        [cell.textLabel setText:@"下载地址设置"];
//    }
//    else
//    {
//        
//    }
//    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[NSClassFromString(@"AddressSetViewController") alloc]init] animated:YES];

//    if(indexPath.row == 0)
//    {
//        [self checkUpdate];
//    }
//    else if (indexPath.row == 1)
//    {
//        [self.navigationController pushViewController:[[NSClassFromString(@"AddressSetViewController") alloc]init] animated:YES];
//    }
//    else if (indexPath.row == 2)
//    {
//        [self.navigationController pushViewController:[[NSClassFromString(@"DownloadUrlSetViewController") alloc]init] animated:YES];
//    }
}

#pragma mark -

- (void)checkUpdate
{
    [[HttpConnctionManager sharedInstance] gettheLastestVersion:^(NSDictionary *retDic){
        
        NSArray *arr = (NSArray *)retDic;
        if(arr.count > 0)
        {
            NSDictionary  *bundleDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentAppVersion = [bundleDic objectForKey:@"CFBundleVersion"];
            
            self.m_versionDic = [arr firstObject];
            BOOL isCanUpdate =  [currentAppVersion integerValue] < [self.m_versionDic[@"version"]integerValue];
            
            if(isCanUpdate)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"有版本可以升级" message:@"是否升级" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"确认", nil];
                [alert show];
            }
            else
            {
                [PubllicMaskViewHelper showTipViewWith:@"已是最新版本" inSuperView:self.view withDuration:1];
            }
        }
        else
        {
            
        }
        
    } failedBolck:FAILED_BLOCK{
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https%3A%2F%2Fmelaka.fir.im%2Fapi%2Fv2%2Fapp%2Finstall%2F55591f138e82369a570010bf%3Ftoken%3DWKQhCC19JIygnoM2k3H4dojAWYx3I4x5jo1iO7Qm"]];
    }
}
@end
