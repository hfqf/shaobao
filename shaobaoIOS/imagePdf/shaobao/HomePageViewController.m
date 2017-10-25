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
#import "FindTableViewCell.h"
#import "FindRequureInfoViewController.h"
#import "FindSenderInfoViewController.h"
#import "FindCategoryViewController.h"
#import "WebViewViewController.h"
#import "FindSendConfirmOrderViewController.h"
#import "FindServiceInfoViewController.h"
#import "MWPhotoBrowser.h"
#import "MyGradeViewController.h"
#import "UserInfoViewController.h"
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,MXCycleScrollViewDelegate,FindTableViewCellDelegate,MWPhotoBrowserDelegate>
@property(nonatomic,strong)MXCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSArray *m_arrAds;
@property(nonatomic,strong) NSMutableArray *m_arrPhoto;

@end

@implementation HomePageViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    ADTFindItem *last = [self.m_arrData lastObject];
    [HTTP_MANAGER findGetHelpList:@""
                         userType:@""
                           status:@""
                          provice:@""
                             city:@""
                           county:@""
                        startTime:@""
                          endTime:@""
                           helpId:isRefresh ? @"0" : last.m_id
                         pageSize:@"20"
                   successedBlock:^(NSDictionary *succeedResult) {

                       if([succeedResult[@"ret"]integerValue] == 0){
                           NSMutableArray *arr = isRefresh ? [NSMutableArray array] : [NSMutableArray arrayWithArray:self.m_arrData];
                           for(NSDictionary *info in  succeedResult[@"data"]){
                               ADTFindItem *item = [ADTFindItem from:info];
                               [arr addObject:item];
                           }
                           self.m_arrData = arr;
                       }
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

- (CGFloat)highOf:(ADTFindItem *)currentData
{
    CGFloat high = 40;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:15] withWidth:(MAIN_WIDTH-(20+70))];
    high+=size.height;
    high+=20;

    if(currentData.m_userType.integerValue == 1){
        high+=20;
    }else{
        high+=30;
    }

    NSInteger row = ceil(currentData.m_arrPics.count/3.0);
    NSInteger sep = 10;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-(70+sep*(cell_num+1)))/3;
    high+= (sep+width)*row;
    high+=50;
    return high;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            return 40;
        }else{
            return [self highOf:[self.m_arrData objectAtIndex:indexPath.row-1]];
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTFindItem *data = [self.m_arrData objectAtIndex:indexPath.row-1];
    if(data.m_userType.integerValue == 2){
        FindServiceInfoViewController *vc = [[FindServiceInfoViewController alloc]initWith:data];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if(data.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue){
            FindSenderInfoViewController *info = [[FindSenderInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }else{
            FindRequureInfoViewController *info = [[FindRequureInfoViewController alloc]initWith:data];
            [self.navigationController pushViewController:info animated:YES];
        }
    }
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
            btn.tag = index;
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
            FindTableViewCell *cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];

//            FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
//            if(cell == nil){
//                cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
//            }
            cell.currentData= [self.m_arrData objectAtIndex:indexPath.row-1];
            cell.m_delegate  = self;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"find_category" object:@(btn.tag)];
}

#pragma mark - MXCycleScrollViewDelegate
- (void)clickImageIndex:(NSInteger)index {
    NSLog(@"pageViewDidTapIndex %ld",index);
    NSDictionary *info = [self.m_arrAds objectAtIndex:index];
    WebViewViewController *web = [[WebViewViewController alloc]initWith:info[@"linkUrl"] withTitle:info[@"title"]];
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark - FindTableViewCell

- (void)onDelete:(ADTFindItem *)data
{

    [HTTP_MANAGER findDeleteOne:data.m_id
                 successedBlock:^(NSDictionary *succeedResult) {
                     if([succeedResult[@"ret"]integerValue]==0){
                         [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                         [self requestData:YES];
                     }else{
                         [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                 }];

}

- (void)onAccept:(ADTFindItem *)data
{
    FindRequureInfoViewController *info = [[FindRequureInfoViewController alloc]initWith:data];
    [self.navigationController pushViewController:info animated:YES];
}


- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl
{

    NSMutableArray *arr = [NSMutableArray array];
    for(NSString *url in arrUrl){
        [arr addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",url ]]]];
    }
    self.m_arrPhoto = arr;


    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];

    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)

    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index-1];

    // Present
    [self.navigationController pushViewController:browser animated:YES];

    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.m_arrPhoto.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.m_arrPhoto.count) {
        return [self.m_arrPhoto objectAtIndex:index];
    }
    return nil;
}

- (void)onHeadClicked:(NSString *)userId
{
    [HTTP_MANAGER getUserInfo:userId
               successedBlock:^(NSDictionary *succeedResult) {
                   if([succeedResult[@"ret"] integerValue]==0){
                       NSDictionary *ret = succeedResult[@"data"];
                       NSDictionary *info = [ret isKindOfClass:[NSNull class]] ? nil : ret;
                       UserInfoViewController *user = [[UserInfoViewController alloc]initWith:info];
                       [self.navigationController pushViewController:user animated:YES];
                   }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];
}
@end

