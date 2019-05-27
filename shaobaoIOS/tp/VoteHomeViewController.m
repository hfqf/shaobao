//
//  VoteHomeViewController.m
//  shaobao
//
//  Created by Points on 2019/5/6.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "VoteHomeViewController.h"
#import "VoteHomeTableViewCell.h"
#import "LZGSGroupViewController.h"
#import "AddVoteViewController.h"
#import "MWPhotoBrowser.h"
@interface VoteHomeViewController ()<UITableViewDelegate,UITableViewDataSource,VoteHomeTableViewCellDelegate,MWPhotoBrowserDelegate>
@property(nonatomic,strong) NSMutableArray *m_arrPhoto;
@end

@implementation VoteHomeViewController

-(id)init
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
    [title setText:@"投票"];
    backBtn.hidden = YES;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 60, 44)];
    [rightBtn setTitle:@"发起" forState:UIControlStateNormal];
    [navigationBG addSubview:rightBtn];
}

- (void)rightBtnClicked{
    [self.navigationController pushViewController:[[NSClassFromString(@"AddVoteViewController") alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    NSString *voteId = @"0";
    if(isRefresh){
        
    }else{
        if(self.m_arrData.count >0){
            ADTVoteItem *vote = [self.m_arrData lastObject];
            voteId = vote.m_id;
        }
    }
    [HTTP_MANAGER getVoteList:voteId
                     pageSize:@"20"
               successedBlock:^(NSDictionary *succeedResult) {
                   if([succeedResult[@"ret"]integerValue]==0){
                       NSArray *arrRet = succeedResult[@"data"];
                       if(isRefresh){
                           NSMutableArray *arr = [NSMutableArray array];
                           for(NSDictionary *info in arrRet){
                               ADTVoteItem *_group = [ADTVoteItem from:info];
                               [arr addObject:_group];
                           }
                           self.m_arrData = arr;
                       }else{
                           NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                           for(NSDictionary *info in arrRet){
                               ADTVoteItem *_group = [ADTVoteItem from:info];
                               [arr addObject:_group];
                           }
                           self.m_arrData = arr;
                       }
                   }
                   [self reloadDeals];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self reloadDeals];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)highOf:(ADTVoteItem *)currentData
{
    return currentData.m_arrPics.count == 0?80:180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:[self.m_arrData objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTVoteItem *data = [self.m_arrData objectAtIndex:indexPath.row];
    [HTTP_MANAGER getVoteDetail:data.m_id
                 successedBlock:^(NSDictionary *succeedResult) {
        
                     if([succeedResult[@"ret"] integerValue] == 0){
                         ADTVoteItem *_detail = [ADTVoteItem from:succeedResult[@"data"]];
                         AddVoteViewController *detail = [[AddVoteViewController alloc]initWith:_detail];
                         [self.navigationController pushViewController:detail animated:YES];
                     }else{
                         
                     }
                 
                     
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden1 = @"cell2";
    VoteHomeTableViewCell *cell = [[VoteHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    
    //            FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    //            if(cell == nil){
    //                cell = [[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    //            }
    cell.currentData= [self.m_arrData objectAtIndex:indexPath.row];
    cell.m_delegate  = self;
    return cell;
}

#pragma mark - VoteHomeTableViewCellDelegate
- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl{
    NSMutableArray *arr = [NSMutableArray array];
    for(NSString *url in arrUrl){
        if(url.length > 0){
            [arr addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url ]]]];
        }
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
    [browser setCurrentPhotoIndex:index];
    
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

@end
