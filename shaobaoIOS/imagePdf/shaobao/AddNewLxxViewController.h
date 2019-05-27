//
//  AddNewLxxViewController.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/6.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
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
@interface AddNewLxxViewController : BaseViewController
@property(nonatomic,strong) NSMutableArray *selectedPhotos;
@property(nonatomic,strong) NSMutableArray *selectedAssets;
@property(nonatomic,strong) NSMutableArray *m_arrFilePics;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;

@property (strong, nonatomic) UITextView *m_input;;
@property (nonatomic,assign)  NSInteger  m_addType;
- (instancetype)init2;
@end
