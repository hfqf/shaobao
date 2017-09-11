//
//  ResourceFileInfoViewController.m
//  jianye
//
//  Created by points on 2017/2/20.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ResourceFileInfoViewController.h"
#import "FilePreviewViewController.h"
@interface ResourceFileInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *m_topic;
@end

@implementation ResourceFileInfoViewController

- (id)initWith:(NSDictionary *)fileInfo
{
    self.m_info = fileInfo;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"资源中心"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
    
    [self showWaitingView];
    [HTTP_MANAGER getResourceCenterFileInfo:self.m_info[@"dataId"]
                              successedBlock:^(NSDictionary *succeedResult) {
                                  
                                  [self removeWaitingView];
                                  NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                  
                                  NSArray *arr = ret[@"result"][@"topicList"];
                                  NSMutableString *str = [NSMutableString string];
                                  for(NSDictionary *_topic in arr)
                                  {
                                      [str appendFormat:@"%@,",_topic[@"topicName"]];
                                  }
                                  self.m_topic = @"";
                                  if(str.length > 1)
                                  {
                                      self.m_topic = [str substringToIndex:str.length-1];
                                  }
                                  
                                  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [self reloadDeals];

        
    }];
}

#pragma mark - TableViewDelegate

- (NSInteger)getHigh:(NSIndexPath *)indexPath
{
    return indexPath.row == 6 ? 140 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHigh:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = self.m_info;
    
    if(indexPath.row == 0 ||
       indexPath.row == 1 ||
       indexPath.row == 2 ||
       indexPath.row == 3 ||
       indexPath.row == 4 ||
       indexPath.row == 5)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15,60, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:16]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:tip];
        
        UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame),15,MAIN_WIDTH-(CGRectGetMaxX(tip.frame)+10)-10, 18)];
        [state setTextAlignment:NSTextAlignmentLeft];
        [state setTextColor:UIColorFromRGB(0x323232)];
        [state setFont:[UIFont systemFontOfSize:16]];
        [state setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:state];

        if(indexPath.row == 0)
        {
            [tip setText:@"标题:"];
            [state setText:info[@"typeName"]];
        }
        else if (indexPath.row == 1)
        {
            [tip setText:@"时间:"];
            [state setText:[info[@"theTime"]substringToIndex:10]];
        }
        else if (indexPath.row == 2)
        {
            [tip setText:@"类别:"];
            [state setText:info[@"typeName"]];
        }
        else if (indexPath.row == 3)
        {
            [tip setText:@"人物:"];
            [state setText:info[@"person"]];
        }
        else if (indexPath.row == 4)
        {
            [tip setText:@"地点:"];
            [state setText:info[@"address"]];
        }
        else if (indexPath.row == 5)
        {
            [tip setText:@"主题:"];
            [state setText:self.m_topic];
        }
        else
        {
            [state setText:@""];
        }
    }
    else if (indexPath.row == 6)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,5,80, 18)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x323232)];
        [tip setFont:[UIFont systemFontOfSize:16]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:@"说明:"];
        [cell addSubview:tip];
        
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(10,30,MAIN_WIDTH-20,[self getHigh:indexPath]-40)];
        [desc setTextAlignment:NSTextAlignmentLeft];
        [desc setTextColor:UIColorFromRGB(0x323232)];
        [desc setFont:[UIFont systemFontOfSize:16]];
        [desc setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
        [desc setText:info[@"contents"]];
        desc.layer.cornerRadius = 5;
        desc.layer.borderWidth = 0.5;
        desc.layer.borderColor = UIColorFromRGB(0xd5d5d5).CGColor;
        [cell addSubview:desc];
    }
    else
    {
        NSArray *arr = info[@"fileList"];
        if(arr.count > 0)
        {
            NSDictionary *fileInfo = [self.m_info[@"fileList"]firstObject];
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,0,MAIN_WIDTH-20,[self getHigh:indexPath])];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [tip setTextColor:UIColorFromRGB(0x0000F3)];
            [tip setFont:[UIFont systemFontOfSize:16]];
            [tip setBackgroundColor:[UIColor clearColor]];
            [tip setText:fileInfo[@"filename"]];
            [cell addSubview:tip];;
        }
    }

    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self getHigh:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 7)
    {
        NSDictionary *info = self.m_info;
        NSArray *arr = info[@"fileList"];
        if(arr.count == 0)
        {
            return;
        }
        [self showWaitingView];
        NSDictionary *attach = [info[@"fileList"]objectAtIndex:0];
        [HTTP_MANAGER downloadFileWithUrl:[attach stringWithFilted:@"filetype"]
                                 fileName:[attach stringWithFilted:@"filename"]
                                   params:
         @{
           @"typeid":[NSNumber numberWithInteger:0],
           @"resultCode":@"0",
           @"filename":[attach stringWithFilted:@"filename"],
           @"recordid":[attach stringWithFilted:@"recordid"],
           @"filetype":[attach stringWithFilted:@"filetype"],
           @"rettype":[NSNumber numberWithInteger:0],
           @"fileid" :[attach stringWithFilted:@"fileid"],
           @"userid" : [LoginUserUtil userId],
           @"doctype" : @(2),
           @"filebody":[attach stringWithFilted:@"filename"],
           @"token"   : [LoginUserUtil accessToken]
           }
                             successBlock:^(NSDictionary *retDic){
                                 
                                 [self removeWaitingView];
                                 FilePreviewViewController *infoVc = [[FilePreviewViewController alloc]init];
                                 infoVc.fileLocalUrl = retDic[@"path"];
                                 infoVc.currentTitle = [attach stringWithFilted:@"filename"];
                                 [self.navigationController pushViewController:infoVc animated:YES];
                                 
                             }
                              failedBolck:FAILED_BLOCK{
                                  
                                  [self removeWaitingView];
                                  [PubllicMaskViewHelper showTipViewWith:@"文件下载失败" inSuperView:self.view withDuration:1];
                                  
                              }];
    }
}


@end
