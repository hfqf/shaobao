//
//  ReceivedImageview.h
//  JZH_Test
//
//  Created by Points on 13-10-28.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@protocol ReceivedImageviewDelegate <NSObject>

@required



@optional


- (void)longPressedInReceivedImageview;

//全屏查看地图
- (void)OnWatchFullScreenMap;

- (void)onSeeAllPic:(NSInteger)index;

- (void)hideKeyboard;

//查看当前图片大图
- (void)onSeeCurrentImageIdBigPic:(NSString *)iamgeId;

@end

@interface ReceivedImageview : EGOImageView<UIGestureRecognizerDelegate>
{
    UIButton *m_btn;
}

@property (nonatomic, assign) BOOL isregister;
@property(nonatomic,assign)BOOL isLocationSnap;


@property(nonatomic,retain)NSString *m_strImageUrl;

@property(nonatomic,retain)NSString *m_origianPicturePath;//原始大图路径

@property(nonatomic,assign)id<ReceivedImageviewDelegate>m_delegate;

- (void)setNewFrame:(CGRect)frame;

@end
