//
//  MainTabBarViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//


#import "MainTabBarViewController.h"
#import "TabbarButtonsBGView.h"

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

    [self initView];
    [self initViewControllers];
    //第一次进来默认是选互动对话
    [self.m_tabbar refreshWithCurrentSelected:0];
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
            title = @"工单";
            unSelectedImg = @"wrench_un";
            selectedImg = @"wrench_un";
        }else if(i==1)
        {
            title = @"提醒";
            unSelectedImg = @"clock_un";
            selectedImg = @"clock_un";
        }else if (i==2)
        {
            title = @"客户";
            unSelectedImg = @"people_un";
            selectedImg = @"people_un";
        }
        else if (i==3)
        {
            title = @"统计";
            unSelectedImg =  @"tongji_on";
            selectedImg = @"tongji_on";
        }
        else
        {
            title = @"我的";
            unSelectedImg = @"setup";
            selectedImg = @"setup";
        }
        [arrTitle addObject:title];
        [arrUnSelectedImg addObject:unSelectedImg];
        [arrSelectedImg addObject:selectedImg];
    }

    TabbarButtonsBGView * tabar = [[TabbarButtonsBGView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM, MAIN_WIDTH, HEIGHT_MAIN_BOTTOM) withTitleArr:arrTitle withUnSelectedImgArray:arrUnSelectedImg withSelectedArr:arrSelectedImg withButtonNum:NUM_TAB];
    tabar.m_delegate = self;
    [self.view addSubview:tabar];
    self.m_tabbar = tabar;


    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake((MAIN_WIDTH-50)/2, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM-60, 50, 50)];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"ic_tabbar_compose_icon_add_highlighted"] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
}


//生成tabbar子ViewController
- (void)initViewControllers
{
    WorkroomListViewController *vc0 = [[WorkroomListViewController alloc]init];
    vc0.m_delegate = self;

    NewTipViewController *vc1 = [[NewTipViewController alloc]init];
    vc1.m_delegate = self;

    CustomerViewController *vc2 = [[CustomerViewController alloc]init];
    vc2.m_delegate = self;

    RepairPrintViewController *vc3 = [[RepairPrintViewController alloc]init];
    vc3.m_delegate = self;

    SettingViewController *vc4 = [[SettingViewController alloc]init];
    vc4.m_delegate = self;
    self.viewControllers = @[vc0,vc1,vc2,vc3,vc4];
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
