//
//  SideslipViewController.h
//  xxt_xj
//
//  Created by Yang on 14/11/5.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "BaseViewController.h"
#import "SideslipView.h"
#import "MainTabBarViewController.h"
@interface SideslipViewController : UIViewController
{
@private
    UINavigationController * leftControl;
    UINavigationController * righControl;
    
    UIImageView * imgBackground;
    
    CGFloat scalef;
}

//@property (nonatomic, strong) UIPanGestureRecognizer * pan;
//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;

@property (nonatomic, strong) SideslipView *leftView;

@property (nonatomic,strong) XTNavigationController * mainControl;

@property (nonatomic,strong) MainTabBarViewController *tabbarControl;
//初始化
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(MainTabBarViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;


//恢复位置
-(void)showMainView;

//显示左视图
-(void)showLeftView;

//显示右视图
-(void)showRighView;



@end
