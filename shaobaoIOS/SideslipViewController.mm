//
//  SideslipViewController.m
//  xxt_xj
//
//  Created by Yang on 14/11/5.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "SideslipViewController.h"

@interface SideslipViewController ()<sideslipViewDelegate,UIAlertViewDelegate,MainTabBarViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer * pan;
}
@end

@implementation SideslipViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.wantsFullScreenLayout = YES;
    self.view.backgroundColor =UIColorFromRGB(0x204565);
    
    [[NSNotificationCenter defaultCenter]addObserverForName:KEY_IS_OUTDEATE_TOKEN
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                    [self logoutToLoginView];
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(MainTabBarViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;
{
    if(self){
        _speedf = 0.5;
        MainView.m_delegate = self;
        self.tabbarControl = MainView;
        self.mainControl = [[XTNavigationController alloc]initWithRootViewController:self.tabbarControl];
        
        self.leftView = [[SideslipView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
        self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1,1);
        self.leftView.delegate = self;
        
        //滑动手势
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        pan.delegate = self;
        [self.mainControl.view addGestureRecognizer:pan];
        
        [self.view addSubview:self.leftView];
        
        [self.view addSubview:self.mainControl.view];

        
//        [self.mainControl.view.layer setShadowOpacity:0.5];
        
        // 添加阴影
//        self.mainControl.view.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.mainControl.view.layer.shadowRadius = 10.0;
//        self.mainControl.view.layer.shadowOpacity = .5;
        
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    UIPanGestureRecognizer *gest = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [gest translationInView:self.view];//滑动的距离
    
    if(point.x < 0 && (int)gest.view.frame.origin.x == 0)
    {
        return NO;
    }

    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
    } else {
        
    }
    
    return YES;
}




#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];//滑动的距离
    
   
    
    scalef = (point.x*_speedf+scalef);
    //根据视图位置判断是左滑还是右边滑动
    if (rec.view.frame.origin.x>0){
        rec.view.center = CGPointMake(rec.view.center.x + point.x*_speedf,rec.view.center.y);
        rec.view.center = CGPointMake(rec.view.center.x + point.x,rec.view.center.y);
        
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];//因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        
        righControl.view.hidden = YES;
        self.leftView.hidden = NO;
    }
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded)
    {
        if (scalef>140*_speedf)
        {
            [self showLeftView];
            scalef = 0;
        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }
    
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        [UIView commitAnimations];
        scalef = 0;
        
    }
    
}

#pragma mark - 修改视图位置
//恢复位置
-(void)showMainView{
    [UIView beginAnimations:@"showMainView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    self.mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [self onResetY];
    [UIView commitAnimations];
}

//显示左视图
-(void)showLeftView{
    [UIView beginAnimations:@"showLeftView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    self.mainControl.view.center = CGPointMake(MAIN_WIDTH+40,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showMainView"]) {
        UIView *btn = [self.mainControl.view viewWithTag:1122];
        [btn removeFromSuperview];
    } else if ([animationID isEqualToString:@"showLeftView"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.mainControl.view.bounds;
        [btn addTarget:self action:@selector(showMainView) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1122;
        [self.mainControl.view addSubview:btn];
    }
}

//显示右视图
-(void)showRighView {
    [UIView beginAnimations:nil context:nil];
   self.mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    self.mainControl.view.center = CGPointMake(-60,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
}

- (void)sideslipViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showMainView];
    switch (indexPath.row) {
            case 0://收藏
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1://公文管理
        {
            BaseViewController *vc = [[NSClassFromString(@"TodoViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2://通知
        {
            BaseViewController *vc = [[NSClassFromString(@"NoticeViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3://会议管理
        {
            BaseViewController *vc = [[NSClassFromString(@"MeetingManagerViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4://督查督办
        {
            BaseViewController *vc = [[NSClassFromString(@"ObserveManagerViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5://领导日程
        {
            BaseViewController *vc = [[NSClassFromString(@"LeaderSchudeViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6://通讯录
        {
            BaseViewController *vc = [[NSClassFromString(@"ContactViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7://电子期刊
        {
            BaseViewController *vc = [[NSClassFromString(@"EMaganizeViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8://资源中心
        {
            BaseViewController *vc = [[NSClassFromString(@"ResourceCentreViewController") alloc]init];
            vc.m_delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9://个人设置
        {
            break;
        }
            
        default:
        {
            break;
        }
    }
}

- (void)onLogoutBtnClicked
{
    [self logoutBtnClicked];
}

- (void)logoutToLoginView
{
    
  
    
}

- (void)logoutBtnClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认需要注销" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)settingBtnActionDelegate:(id)sender
{
    

}

- (void)sideslipViewImageExViewDidOkDelegate:(EGOImageView *)imageViewEx {
    NSLog(@"我的头像");
}

- (void)backBtnToClicked{
    
}

- (void)sidesLipshowLeftView{
    [self showLeftView];
}


#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000)
    {
        [self logoutToLoginView];
    }
    else
    {
        if(buttonIndex == 1)
        {
            [self logoutToLoginView];
        }
    }
   
}



#pragma mark - BaseViewDelegate

- (void)onShowLeftView
{
    if ((int)self.mainControl.view.frame.origin.x != 0)
    {
        [self showMainView];
    }
    else
    {
        [self showLeftView];
    }
}


//从首页的4个tab切换的操作
- (void)onShowSliderView
{
    [self onShowLeftView];
}

- (void)onRemoveTapObserver
{
    [self.mainControl.view removeGestureRecognizer:pan];
    [self showMainView];
}

- (void)onAddTapObserver{
    //滑动手势
    [self.mainControl.view addGestureRecognizer:pan];
}

- (void)onResetY
{
    [self.mainControl.view setFrame:CGRectMake(0, OS_ABOVE_IOS7 ? 0 : -20, MAIN_WIDTH,MAIN_HEIGHT)];
}

- (void)onBackAnaShowSliderView
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self showLeftView];
    [self performSelector:@selector(showLeftView) withObject:nil afterDelay:0.1];
}

@end
