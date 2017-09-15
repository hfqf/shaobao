//
//  HomePageViewController.m
//  shaobao
//
//  Created by points on 2017/9/13.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "HomePageViewController.h"
#import "MXCycleScrollView.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MXCycleScrollView *cycleScrollView;

@end

@implementation HomePageViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.delegate = self;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAds{
    
}

@end
