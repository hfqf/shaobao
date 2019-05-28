//
//  AddVoteViewController.m
//  shaobao
//
//  Created by Points on 2019/5/19.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "AddVoteViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "AddLxxBtnCollectionViewCell.h"
#import "VoteTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "AddNewCommentViewController.h"
#import "VoteHomeTableViewCell.h"
@interface AddVoteViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,VoteTableViewCellDelegate,MWPhotoBrowserDelegate,VoteHomeTableViewCellDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    UITextField *inputOption;
    UITextField *inputTitle;
}
@property (nonatomic,strong)ADTVoteItem *m_vote;
@property (nonatomic,strong)UITextField *m_input;

@property(nonatomic,strong) NSMutableArray *selectedPhotos;
@property(nonatomic,strong) NSMutableArray *selectedAssets;
@property(nonatomic,strong) NSMutableArray *m_arrFilePics;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property(nonatomic,strong) NSMutableArray *m_arrPhoto;

@end

@implementation AddVoteViewController
- (id)init
{
    self.m_vote = [[ADTVoteItem alloc]init];
    self.m_vote.m_isNew = YES;
    self.m_vote.m_arrOptitonItem = [NSMutableArray array];
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (instancetype)initWith:(ADTVoteItem *)vote{
    self.m_vote = vote;
    self.m_vote.m_isNew = false;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText: self.m_vote.m_isNew?@"新增投票":@"详情"];
    if(!self.m_vote.m_isNew){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 60, 44)];
        [rightBtn setTitle:@"点评" forState:UIControlStateNormal];
        [navigationBG addSubview:rightBtn];
    }

    
    _selectedPhotos = [NSMutableArray array];
 
    _selectedAssets = [NSMutableArray array];
    self.m_arrFilePics = [NSMutableArray array];
    
    if(self.m_vote.m_isNew){
        
    }else{
        if(self.m_vote.m_image1.length > 0){
            [_selectedPhotos addObject:self.m_vote.m_image1];
            [_selectedAssets addObject:self.m_vote.m_image1];
        }
        
        if(self.m_vote.m_image2.length > 0){
            [_selectedPhotos addObject:self.m_vote.m_image2];
            [_selectedAssets addObject:self.m_vote.m_image2];
        }
        
        if(self.m_vote.m_image3.length > 0){
            [_selectedPhotos addObject:self.m_vote.m_image3];
            [_selectedAssets addObject:self.m_vote.m_image3];
        }
    }
    [self configCollectionView];
    
    _margin = 4;
    _itemWH = (self.view.tz_width - 3 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
}

- (void)rightBtnClicked{
    AddNewCommentViewController *add = [[AddNewCommentViewController alloc]initWith:self.m_vote];
    [self.navigationController pushViewController:add animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestData:(BOOL)isRefresh
{
    if(self.m_vote.m_isNew){
        [self reloadDeals];
        return;
    }
    NSString *commentId = @"";
    if(isRefresh){
        
    }else{
        if(self.m_vote.m_arrComments.count >0){
            ADTComment *vote = [self.m_vote.m_arrComments lastObject];
            commentId = vote.m_id;
        }
    }

    
    [HTTP_MANAGER getCommentList:self.m_vote.m_id
                            type:@"2"
                       commentId:commentId
                        pageSize:@"10"
                  successedBlock:^(NSDictionary *succeedResult) {
                      if([succeedResult[@"ret"]integerValue]==0){
                          NSArray *arrRet = succeedResult[@"data"];
                          if(isRefresh){
                              NSMutableArray *arr = [NSMutableArray array];
                              for(NSDictionary *info in arrRet){
                                  ADTComment *_group = [ADTComment from:info];
                                  [arr addObject:_group];
                              }
                              self.m_vote.m_arrComments = arr;
                          }else{
                              NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_vote.m_arrComments];
                              for(NSDictionary *info in arrRet){
                                  ADTComment *_group = [ADTComment from:info];
                                  [arr addObject:_group];
                              }
                              self.m_vote.m_arrComments = arr;
                          }
                      }
                      [self reloadDeals];
                      
                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                      
                  }];

}

- (void)addOptionBtnClicked{
    ADTVoteOptionItem *option = [[ADTVoteOptionItem alloc]init];
    option.m_option = inputOption.text;
    option.m_isNew = YES;
    [self.m_vote.m_arrOptitonItem addObject:option];
    [self reloadDeals];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else if (section == 1){
        return self.m_vote.m_arrOptitonItem.count;
    }else if (section == 2){
        return  self.m_vote.m_isNew ? 1 :(self.m_vote.m_arrPics.count == 0 ? 0 : 1);
    }else if (section == 3){
        return self.m_vote.m_arrComments.count;
    }
    return 0;
}

- (CGFloat)highOf:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3){
        ADTComment *comemnt = [self.m_vote.m_arrComments objectAtIndex:indexPath.row];
        CGSize size = [FontSizeUtil sizeOfString:comemnt.m_title withFont:[UIFont systemFontOfSize:13] withWidth:MAIN_WIDTH-20];
        return comemnt.m_arrPics.count > 0 ? 130+size.height : 40+size.height;
    }else{
        return indexPath.section == 2 ? (self.m_vote.m_isNew ?180:( self.m_vote.m_arrPics.count == 0 ? 0: 180) ): 40;
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        if(self.m_vote.m_isNew){
            
        }else{
            
            ADTVoteOptionItem *item = [self.m_vote.m_arrOptitonItem objectAtIndex:indexPath.row];
            [self showWaitingView];
            [HTTP_MANAGER scorePersonOption:self.m_vote.m_id
                               voteOptionId:item.m_optionId
                             successedBlock:^(NSDictionary *succeedResult) {
                                 [self removeWaitingView];
                                 if([succeedResult[@"ret"]integerValue]==0){
                                     [HTTP_MANAGER getVoteDetail:self.m_vote.m_id
                                                  successedBlock:^(NSDictionary *succeedResult) {
                                                      
                                                      if([succeedResult[@"ret"] integerValue] == 0){
                                                          ADTVoteItem *_detail = [ADTVoteItem from:succeedResult[@"data"]];
                                                          self.m_vote = _detail;
                                                          [self reloadDeals];
                                                      }else{
                                                          
                                                      }
                                                      
                                                      
                                                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                                      
                                                  }];
                                 }else{
                                     
                                 }
                
                                 [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"点评失败" inSuperView:self.view withDuration:1];
            }];
        }
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.m_vote.m_isNew ? (section ==1 ? 40 : 0 ): 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 40)];
        if(inputOption == nil){
            inputOption = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, MAIN_WIDTH-130, 30)];
        }
        inputOption.delegate = self;
        inputOption.layer.cornerRadius = 4;
        inputOption.layer.borderWidth = 0.5;
        inputOption.layer.borderColor = GRAY_3.CGColor;
        inputOption.font = [UIFont systemFontOfSize:14];
        inputOption.returnKeyType = UIReturnKeyDone;
        [inputOption setPlaceholder:@"输入新增投票选项"];
        [vi addSubview:inputOption];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
        add.layer.cornerRadius = 5;
        [add setFrame:CGRectMake(MAIN_WIDTH-80, 5, 50, 30)];
        [add setBackgroundColor:KEY_COMMON_CORLOR];
        [add setTitle:@"确认" forState:UIControlStateNormal];
        [add.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [add addTarget:self action:@selector(addOptionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [vi addSubview:add];
        return vi;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.m_vote.m_arrOptitonItem removeObjectAtIndex:indexPath.row];
        [self reloadDeals];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden1 = @"cell1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    if(indexPath.section ==0){
        if(inputTitle == nil){
            inputTitle = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, MAIN_WIDTH-130, 30)];
        }
        inputTitle.delegate = self;
        inputTitle.tag = indexPath.row;
        inputTitle.layer.cornerRadius = 4;
        inputTitle.layer.borderWidth = 0.5;
        inputTitle.layer.borderColor = GRAY_3.CGColor;
        inputTitle.font = [UIFont systemFontOfSize:14];
        inputTitle.returnKeyType = UIReturnKeyDone;
        [inputTitle setPlaceholder:@"投票标题"];
        [cell addSubview:inputTitle];
        
        if(indexPath.row == 0){
            [cell.textLabel setText:@"投票标题"];
            [inputTitle setText:self.m_vote.m_title];
        }
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath]-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:GRAY_3];
        [cell addSubview:sep];
        return cell;
    }else if(indexPath.section == 1){
        NSString *iden1 = @"cell3";
        VoteTableViewCell *cell = [[VoteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
        ADTVoteOptionItem *option = [self.m_vote.m_arrOptitonItem objectAtIndex:indexPath.row];
        option.m_index = indexPath.row;
        cell.m_delegate = self;
        cell.option = option;
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath]-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:GRAY_3];
        [cell addSubview:sep];
        return cell;
    }
    else if(indexPath.section == 2){
        NSString *iden1 = @"cell2";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.collectionView];
        return cell;
    }
    else if(indexPath.section == 3){
        VoteHomeTableViewCell2 *cell = [[VoteHomeTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        cell.m_delegate = self;
        cell.currentData = [self.m_vote.m_arrComments objectAtIndex:indexPath.row];
        return cell;
    }
    
    return cell;
}


- (void)addBtnClicked{
    
    self.m_vote.m_title = inputTitle.text;
    if(self.m_vote.m_title.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"标题不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_vote.m_arrOptitonItem.count == 0){
        [PubllicMaskViewHelper showTipViewWith:@"选项不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    NSMutableString *options = [NSMutableString string];
    for(ADTVoteOptionItem *item in self.m_vote.m_arrOptitonItem){
        [options appendFormat:@"%@,",item.m_option];
    }
    [self showWaitingView];
    
    if(self.selectedPhotos.count == 0){
        [HTTP_MANAGER addVote:self.m_vote.m_title
                       option:[options substringToIndex:options.length-1]
                       image1:@""
                       image2:@""
                       image3:@""
               successedBlock:^(NSDictionary *succeedResult) {
                   [self removeWaitingView];
                   [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                   if([succeedResult[@"ret"]integerValue]==0){
                       [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                   }
               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                   [self removeWaitingView];
                   [PubllicMaskViewHelper showTipViewWith:@"新增失败" inSuperView:self.view withDuration:1];
                   
               }];
    }else{
        
        __block NSInteger count=0;
        for(UIImage *img in self.selectedPhotos){
            [HTTP_MANAGER uploadShaobaoFileWithPathData:UIImageJPEGRepresentation(img,0.1)
                                           successBlock:^(NSDictionary *succeedResult) {
                                               [self.m_arrFilePics addObject:succeedResult[@"data"][@"fileUrl"]];
                                               count++;
                                               if(count == self.selectedPhotos.count){
                                                   
                                                   for(NSString *url in self.m_arrFilePics){
                                                       NSInteger index = [self.m_arrFilePics indexOfObject:url];
                                                       if(index == 0){
                                                           self.m_vote.m_image1 = url;
                                                       }
                                                       
                                                       if(index == 1){
                                                          self.m_vote.m_image2 = url;
                                                       }
                                                       
                                                       if(index == 2){
                                                        self.m_vote.m_image3 = url;
                                                       }
                                                   }
                                                   
                                                   [HTTP_MANAGER addVote:self.m_vote.m_title
                                                                  option:[options substringToIndex:options.length-1]
                                                                  image1:self.m_vote.m_image1
                                                                  image2:self.m_vote.m_image2
                                                                  image3:self.m_vote.m_image3
                                                          successedBlock:^(NSDictionary *succeedResult) {
                                                              [self removeWaitingView];
                                                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                                              if([succeedResult[@"ret"]integerValue]==0){
                                                                  [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                                                              }
                                                          } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                                              [self removeWaitingView];
                                                              [PubllicMaskViewHelper showTipViewWith:@"新增失败" inSuperView:self.view withDuration:1];
                                                              
                                                          }];
                                                   
                                               }else{
                                                   [self removeWaitingView];
                                                   [PubllicMaskViewHelper showTipViewWith:[NSString stringWithFormat:@"上传附件%lu/%lu",count,self.selectedPhotos.count] inSuperView:self.view withDuration:1];
                                               }
                                           } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                               [self removeWaitingView];
                                           }];
        }
    }
 
    
   
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.m_input = textField;
    self.m_vote.m_title = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.m_input = textField;
   self.m_vote.m_title = textField.text;
    return YES;
}
#pragma mark - StaffWorkItemTableViewCellDelegate


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(10,10,10,10);
    [_collectionView setFrame:CGRectMake(0,0, MAIN_WIDTH,180)];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_collectionView registerClass:[AddLxxBtnCollectionViewCell class] forCellWithReuseIdentifier:@"TZTestCell2"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        _itemWH = (self.view.tz_width - 3 * _margin - 4) / 4 - _margin;
        _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        return _layout.itemSize;
    }
    return CGSizeMake(MAIN_WIDTH, 50);
}


#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.m_vote.m_isNew ? 2 : 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0){
        return  _selectedPhotos.count + ( self.m_vote.m_isNew ?1:0);
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
        cell.videoImageView.hidden = YES;
        cell.gifLable.hidden = YES;
        cell.deleteBtn.hidden = YES;
        if( self.m_vote.m_isNew){
            if (indexPath.row == _selectedPhotos.count) {
                cell.imageView.image = [UIImage imageNamed:@"find_add"];
                cell.deleteBtn.hidden = YES;
                
            } else {
                id item = _selectedPhotos[indexPath.row];
                if([item isKindOfClass:[NSString class]]){
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item]];
                }else{
                    cell.imageView.image = item;
                }
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageView.clipsToBounds = YES;
                cell.asset = _selectedAssets[indexPath.row];
                cell.deleteBtn.hidden = NO;
            }
        }else{
     
                id item = _selectedPhotos[indexPath.row];
                if([item isKindOfClass:[NSString class]]){
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item]];
                }else{
                    cell.imageView.image = item;
                }
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageView.clipsToBounds = YES;
                cell.asset = _selectedAssets[indexPath.row];            
        }
      
        
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        AddLxxBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell2" forIndexPath:indexPath];
        [cell.addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.m_vote.m_isNew){
        [self onTap:indexPath.item with:self.m_vote.m_arrPics];
    }else{
        if (indexPath.row == _selectedPhotos.count) {
            [self pushTZImagePickerController];
        } else { // preview photos or video / 预览照片或者视频
            // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 3;
            imagePickerVc.allowPickingGif = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.allowPickingMultipleVideo = NO;
            imagePickerVc.isSelectOriginalPhoto = YES;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
 
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/*
 // 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
 navigationController.interactivePopGestureRecognizer.enabled = YES;
 if (viewController != navigationController.viewControllers[0]) {
 navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
 }
 }
 */

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:[[CLLocation alloc]init] completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (YES) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = YES;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}


#pragma mark - VoteTableViewCellDelegate

- (void)onWorkItemClicked:(ADTVoteOptionItem *)option{
    
}

- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl
{
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

