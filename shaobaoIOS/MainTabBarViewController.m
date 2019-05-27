//
//  MainTabBarViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//


#import "MainTabBarViewController.h"
#import "TabbarButtonsBGView.h"
#import "HomePageViewController.h"
#import "FindViewController.h"
#import "LlxViewController.h"
#import "WoyiViewController.h"
#import "VoteHomeViewController.h"

@interface MainTabBarViewController ()<UIActionSheetDelegate>
{

}
@property(nonatomic,strong)TabbarButtonsBGView * m_tabbar;


@end

@implementation MainTabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    [self initView];
    [self initViewControllers];
    //第一次进来默认是选互动对话
    [self.m_tabbar refreshWithCurrentSelected:0];

    [[NSNotificationCenter defaultCenter]addObserverForName:@"find_category"
                                                     object:nil
                                                      queue:[NSOperationQueue currentQueue]
                                                 usingBlock:^(NSNotification * _Nonnull note) {
                                                     NSNumber *index = note.object;
                                                     [self selectWithIndex:1];
    }];
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:KEY_IS_OUTDEATE_TOKEN
                                                     object:nil
                                                      queue:[NSOperationQueue currentQueue]
                                                 usingBlock:^(NSNotification * _Nonnull note) {
                                                     [self.navigationController pushViewController:[[NSClassFromString(@"LoginViewController") alloc]init] animated:YES];

                                                 }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define NUM_TAB 5
#pragma mark -  BaseViewControllerDelegate

- (void)initData
{
    //TODO
}



//自定义头部视图
- (void)initView
{
    NSMutableArray *arrTitle= [NSMutableArray array];
    NSMutableArray *arrUnSelectedImg = [NSMutableArray array];
    NSMutableArray *arrSelectedImg = [NSMutableArray array];
    for(int i=0;i<NUM_TAB;i++)
    {
        NSString *title =  nil;
        NSString *unSelectedImg = nil;
        NSString *selectedImg = nil;
        if(i==0)
        {
            title = @"首页";
            unSelectedImg = @"tab_0_un";
            selectedImg = @"tab_0_on";
        }else if(i==1)
        {
            title = @"发现";
            unSelectedImg = @"tab_1_un";
            selectedImg = @"tab_1_on";
        }else if (i==2)
        {
            title = @"蜡辣鲜";
            unSelectedImg = @"tab_2_un";
            selectedImg = @"tab_2_on";
        }
        else if (i==3)
        {
            title = @"投票";
            unSelectedImg =  @"tab_3_un";
            selectedImg = @"tab_3_on";
        }
        else
        {
            title = @"窝逸";
            unSelectedImg = @"tab_4_un";
            selectedImg = @"tab_4_un";
        }
        [arrTitle addObject:title];
        [arrUnSelectedImg addObject:unSelectedImg];
        [arrSelectedImg addObject:selectedImg];
    }

    TabbarButtonsBGView * tabar = [[TabbarButtonsBGView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM, MAIN_WIDTH, HEIGHT_MAIN_BOTTOM) withTitleArr:arrTitle withUnSelectedImgArray:arrUnSelectedImg withSelectedArr:arrSelectedImg withButtonNum:NUM_TAB];
    tabar.m_delegate = self;
    [self.view addSubview:tabar];
    self.m_tabbar = tabar;
}


//生成tabbar子ViewController
- (void)initViewControllers
{

    HomePageViewController *vc1 = [[HomePageViewController alloc]init];
    FindViewController *vc2 = [[FindViewController alloc]init];
    LlxViewController *vc3 = [[LlxViewController alloc]init];
    VoteHomeViewController *vc4 = [[VoteHomeViewController alloc]init];
    WoyiViewController *vc5 = [[WoyiViewController alloc]init];
    self.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
}

//选择了第几个一级界面
- (void)selectWithIndex:(int)index
{
    self.selectedIndex = index;
    [self.m_tabbar refreshWithCurrentSelected:index];
}

#pragma mark -public

- (void)showWaitingView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize  = CGSizeMake(80, 80);
    UIImageView *waitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];
    [waitView setImage:[UIImage imageNamed:@"Icon@2x"]];
    hud.customView = waitView;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:100];
}

- (void)removeWaitingView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - TabbarButtonsBGViewDelegate
- (void)onSelectedWithButtonIndex:(int)index
{
    [self selectWithIndex:index];
}



@end
