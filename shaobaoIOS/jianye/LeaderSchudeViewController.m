//
//  LeaderSchudeViewController.m
//  jianye
//
//  Created by points on 2017/2/10.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LeaderSchudeViewController.h"
#import "LeaderSchudeInfoControllerViewController.h"
#import "AddNewSchudelViewController.h"
@interface LeaderSchudeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *rightBtn;
}
@property (nonatomic,assign)NSInteger m_currentDay;
@property (nonatomic,assign)NSInteger m_currentWeekIndex;
@property (nonatomic,assign)BOOL m_isDay;
@property (nonatomic,assign)BOOL m_isClickedDayBtn;
@property (nonatomic,strong)NSString *m_start;
@property (nonatomic,strong)NSString *m_end;
@property (nonatomic,strong)NSString *m_year;
@end

@implementation LeaderSchudeViewController


- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource =  self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_isDay = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"领导日程"];
    backBtn.hidden = YES;
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(10,4+DISTANCE_TOP, 32, 34)];
    [slideBtn setBackgroundImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
    
    rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-50,DISTANCE_TOP,44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"leader_add"] forState:UIControlStateNormal];
    [navigationBG addSubview:rightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  侧滑栏操作
- (void)backBtnClicked
{
    [self.m_delegate onShowSliderView];
}

- (void)addBtnClicked
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:3600*24*7]];
    
    self.m_year = [NSString stringWithFormat:@"%ld",(long)[comps year]];
    
    AddNewSchudelViewController *addVc = [[AddNewSchudelViewController alloc]initWith:[NSString stringWithFormat:@"%ld",(long)[comps week]] year:self.m_year scheduleId:@""];
    addVc.m_delegate = self;
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)rightWeekBtnClicked
{
    self.m_currentDay = 0;
    self.m_currentWeekIndex++;
    [self requestData:YES];
}

- (void)leftWeekBtnClicked
{
    self.m_currentDay = 0;
    self.m_currentWeekIndex--;
    [self requestData:YES];
}

- (void)dayInfoBtnClicked:(UIButton *)btn
{
    self.m_isClickedDayBtn = YES;
     self.m_currentDay = btn.tag;
     [self requestData:YES];
    self.m_isClickedDayBtn = NO;
}

- (void)requestData:(BOOL)isRefresh
{
    [self refreshHeaderView:self.m_currentWeekIndex];
    
    if(self.m_isDay)
    {
        [HTTP_MANAGER getLeaderDayScheduleList:self.m_currentIndex
                                    agentDate1:self.m_start
                                    agentDate2:self.m_end
                                successedBlock:^(NSDictionary *succeedResult) {
                                    
                                    [self removeWaitingView];
                                    
                                    if(isRefresh)
                                    {
                                        NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                        self.m_arrData = ret[@"result"];
                                        [self reloadDeals];
                                    }
                                    else
                                    {
                                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                        NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                        [arr addObjectsFromArray:ret[@"result"]];
                                        self.m_arrData = arr;
                                        [self reloadDeals];
                                    }
            
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            
            [self removeWaitingView];
            [self reloadDeals];
            
        }];
    }
    else
    {
       [HTTP_MANAGER getLeaderWeekScheduleList:self.m_currentIndex
                                    agentDate1:self.m_start
                                    agentDate2:self.m_end
                                successedBlock:^(NSDictionary *succeedResult) {
                                    
                                    [self removeWaitingView];
                                    
                                    if(isRefresh)
                                    {
                                        NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                        self.m_arrData = ret[@"result"];
                                        [self reloadDeals];
                                    }
                                    else
                                    {
                                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                        NSDictionary *ret = [succeedResult[@"DATA"] mutableObjectFromJSONString];
                                        [arr addObjectsFromArray:ret[@"result"]];
                                        self.m_arrData = arr;
                                        [self reloadDeals];
                                    }
                                    
                                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                    
                                    [self removeWaitingView];
                                    [self reloadDeals];
                                    
                                }];
    }

}

- (void)weekBtnClicked
{
    rightBtn.hidden = YES;
    self.m_isDay = NO;
    [self requestData:YES];
}

- (void)dayBtnClicked
{
    rightBtn.hidden = NO;
    self.m_isDay = YES;
    [self requestData:YES];
}

- (void)refreshHeaderView:(NSInteger)nextWeekCount
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    if(!self.m_isClickedDayBtn){
        if(self.m_isDay){
            if(self.m_currentWeekIndex == 0){
                
                self.m_currentDay = weekDay-1;
            }
        }else{
            self.m_currentDay = 0;
        }
    }
  

   
    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay +nextWeekCount*7;
        lastDiff = 7 - weekDay+nextWeekCount*7;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSLog(@"星期天开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期六结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    NSDateFormatter *daymater = [[NSDateFormatter alloc] init];
    [daymater setDateFormat:@"dd"];
    NSString *day1 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:firstDayOfWeek]integerValue]];
    
    NSDateFormatter *_day1mater = [[NSDateFormatter alloc] init];
    [_day1mater setDateFormat:@"yyyy-MM-dd"];
    self.m_start = [NSString stringWithFormat:@"%@ 00:00:00",[_day1mater stringFromDate:firstDayOfWeek]];
    
    NSDateFormatter *yearmater = [[NSDateFormatter alloc] init];
    [yearmater setDateFormat:@"yyyy"];
    self.m_year = [yearmater stringFromDate:firstDayOfWeek];
    
    
    NSDateComponents *day2Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day2Comp setDay:day + firstDiff+1];
    NSDate *day2OfWeek= [calendar dateFromComponents:day2Comp];
    NSString *day2 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day2OfWeek]integerValue]];

    NSDateComponents *day3Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day3Comp setDay:day + firstDiff+2];
    NSDate *day3OfWeek= [calendar dateFromComponents:day3Comp];
    NSString *day3 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day3OfWeek]integerValue]];
    
    NSDateComponents *day4Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day4Comp setDay:day + firstDiff+3];
    NSDate *day4OfWeek= [calendar dateFromComponents:day4Comp];
    NSString *day4 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day4OfWeek]integerValue]];
    
    NSDateComponents *day5Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day5Comp setDay:day + firstDiff+4];
    NSDate *day5OfWeek= [calendar dateFromComponents:day5Comp];
    NSString *day5 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day5OfWeek]integerValue]];
    
    NSDateComponents *day6Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day6Comp setDay:day + firstDiff+5];
    NSDate *day6OfWeek= [calendar dateFromComponents:day6Comp];
    NSString *day6 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day6OfWeek]integerValue]];
    
    NSDateComponents *day7Comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [day7Comp setDay:day + firstDiff+6];
    NSDate *day7OfWeek= [calendar dateFromComponents:day7Comp];
    NSString *day7 = [NSString stringWithFormat:@"%ld",[[daymater stringFromDate:day7OfWeek]integerValue]];
    
    NSDateFormatter *_day7mater = [[NSDateFormatter alloc] init];
    [_day7mater setDateFormat:@"yyyy-MM-dd"];
    self.m_end = [NSString stringWithFormat:@"%@ 23:59:59",[_day7mater stringFromDate:day7OfWeek]];
    
    
    if(self.m_isDay)
    {
        NSDateComponents *currentDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [currentDayComp setDay:day + firstDiff+self.m_currentDay];
        NSDate *currentDayOfWeek= [calendar dateFromComponents:currentDayComp];
        NSString *currentDay = [daymater stringFromDate:currentDayOfWeek];
        
        NSDateFormatter *currentDaymater = [[NSDateFormatter alloc] init];
        [currentDaymater setDateFormat:@"yyyy-MM-dd"];
        self.m_start = [NSString stringWithFormat:@"%@",[currentDaymater stringFromDate:currentDayOfWeek]];
        self.m_end = [NSString stringWithFormat:@"%@",[currentDaymater stringFromDate:currentDayOfWeek]];
    }
    
    
    NSString *showTime = [NSString stringWithFormat:@"%@-%@",[formater stringFromDate:firstDayOfWeek],[formater stringFromDate:lastDayOfWeek]];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH,self.m_isDay ? 116 : 46)];
    UIButton *leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"leader_l"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftWeekBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0,30, 46)];
    [bg addSubview:leftBtn];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, MAIN_WIDTH-60-110, 46)];
    time.font = [UIFont systemFontOfSize:14];
    [time setText:showTime];
    [time setTextAlignment:NSTextAlignmentCenter];
    [bg addSubview:time];
    
    UIButton *rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightWeekBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(CGRectGetMaxX(time.frame), 0,30, 46)];
    [rightBtn setImage:[UIImage imageNamed:@"leader_r"] forState:UIControlStateNormal];
    [bg addSubview:rightBtn];
    
    
    UIButton *weekBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [weekBtn addTarget:self action:@selector(weekBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [weekBtn setBackgroundColor:self.m_isDay ? [UIColor whiteColor] : PUBLIC_BACKGROUND_COLOR];
    [weekBtn setTitleColor:!self.m_isDay ?[UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    [weekBtn setTitle:@"周" forState:UIControlStateNormal];
    [weekBtn setFrame:CGRectMake(MAIN_WIDTH-105,10,50,26)];
    weekBtn.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
    weekBtn.layer.borderWidth = 0.5;
    [bg addSubview:weekBtn];
    
    UIButton *_dayBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dayBtn addTarget:self action:@selector(dayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_dayBtn setBackgroundColor:!self.m_isDay ? [UIColor whiteColor] : PUBLIC_BACKGROUND_COLOR];
    [_dayBtn setTitleColor:self.m_isDay ?[UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    [_dayBtn setFrame:CGRectMake(MAIN_WIDTH-55,10,50,26)];
    [_dayBtn setTitle:@"日" forState:UIControlStateNormal];
    _dayBtn.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
    _dayBtn.layer.borderWidth = 0.5;
    [bg addSubview:_dayBtn];
    self.tableView.tableHeaderView = bg;

    if(!self.m_isDay)
    {
        
    }
    else
    {
        for(int i=0;i<7;i++)
        {
            NSInteger width = MAIN_WIDTH/7;
            NSInteger high1 = 30;
            NSInteger high2 = 40;
            UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(i*width,46, width, high1)];
            [day setTextColor:[UIColor blackColor]];
            [day setTextAlignment:NSTextAlignmentCenter];
            
            day.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
            day.layer.borderWidth = 0.5;
            [bg addSubview:day];
            
            UIButton *dayBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
            dayBtn.tag = i;
            [dayBtn setFrame:CGRectMake(i*width,76,MAIN_WIDTH/7, high2)];
            [dayBtn addTarget:self action:@selector(dayInfoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [dayBtn setBackgroundColor:self.m_currentDay == i ?UIColorFromRGB(0x39cadb) : UIColorFromRGB(0xffffff)];
            [dayBtn setTitle:day.text forState:UIControlStateNormal];
            [dayBtn setTitleColor:self.m_currentDay == i ?UIColorFromRGB(0xffffff) : UIColorFromRGB(0x111111) forState:UIControlStateNormal];
            dayBtn.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
            dayBtn.layer.borderWidth = 0.5;
            [bg addSubview:dayBtn];
            
            switch (i) {
                case 0:
                    [day setText:@"日"];
                    [dayBtn setTitle:day1 forState:UIControlStateNormal];
                    break;
                case 1:
                    [day setText:@"一"];
                    [dayBtn setTitle:day2 forState:UIControlStateNormal];
                    break;
                case 2:
                    [day setText:@"二"];
                    [dayBtn setTitle:day3 forState:UIControlStateNormal];
                    break;
                case 3:
                    [day setText:@"三"];
                    [dayBtn setTitle:day4 forState:UIControlStateNormal];
                    break;
                case 4:
                    [day setText:@"四"];
                    [dayBtn setTitle:day5 forState:UIControlStateNormal];
                    break;
                case 5:
                    [day setText:@"五"];
                    [dayBtn setTitle:day6 forState:UIControlStateNormal];
                    break;
                case 6:
                    [day setText:@"六"];
                    [dayBtn setTitle:day7 forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
        }
    }

    
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.m_isDay ? 30 : 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.m_isDay ? 0 :( self.m_arrData.count > 0 ? 30 : 0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 30)];
    vi.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    vi.layer.borderWidth = 0.5;
    
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(0,5,80, 20)];
    [time setTextAlignment:NSTextAlignmentCenter];
    [time setTextColor:UIColorFromRGB(0x2f2f2f)];
    [time setFont:[UIFont systemFontOfSize:14]];
    [time setBackgroundColor:[UIColor clearColor]];
    [time setText:@"时间"];
    [vi addSubview:time];
    
    UIView *sep1 = [[UIView alloc]initWithFrame:CGRectMake(81,0.5, 0.5,29)];
    [sep1 setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [vi addSubview:sep1];
    
    UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(82,5,80, 20)];
    [address setTextAlignment:NSTextAlignmentCenter];
    [address setTextColor:UIColorFromRGB(0x2f2f2f)];
    [address setFont:[UIFont systemFontOfSize:14]];
    [address setBackgroundColor:[UIColor clearColor]];
    [address setText:@"地点"];
    [vi addSubview:address];
    
    UIView *sep2 = [[UIView alloc]initWithFrame:CGRectMake(163,0.5, 0.5,29)];
    [sep2 setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [vi addSubview:sep2];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(163,5,MAIN_WIDTH-163, 20)];
    [content setTextAlignment:NSTextAlignmentCenter];
    [content setTextColor:UIColorFromRGB(0x2f2f2f)];
    [content setFont:[UIFont systemFontOfSize:14]];
    [content setBackgroundColor:[UIColor clearColor]];
    [content setText:@"内容"];
    [vi addSubview:content];
    
    return vi;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    
    if(self.m_isDay)
    {
        NSString *start = [info stringWithFilted:@"startTime"];
        
        BOOL isMorning = [[start substringToIndex:2]integerValue] < 12;
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 20)];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:UIColorFromRGB(0x2f2f2f)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:[NSString stringWithFormat:@"%@ %@",isMorning ? @"上午": @"下午" ,start]];
        [cell addSubview:tip];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(100,0.5, 0.5,29)];
        [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
        [cell addSubview:sep];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, MAIN_WIDTH-130, 20)];
        [content setTextAlignment:NSTextAlignmentLeft];
        [content setTextColor:UIColorFromRGB(0x2f2f2f)];
        [content setFont:[UIFont systemFontOfSize:14]];
        [content setBackgroundColor:[UIColor clearColor]];
        [content setText:info[@"content"]];
        [cell addSubview:content];
    }
    else
    {
        NSString *start = [info stringWithFilted:@"startTime"];
        
        NSString *day =[[info stringWithFilted:@"agentDate"]substringFromIndex:8];
        
        BOOL isMorning = [[start substringToIndex:2]integerValue] < 12;
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0,5,80,40)];
        [tip setTextAlignment:NSTextAlignmentCenter];
        tip.numberOfLines = 0;
        [tip setTextColor:UIColorFromRGB(0x2f2f2f)];
        [tip setFont:[UIFont systemFontOfSize:14]];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setText:[NSString stringWithFormat:@"%@日\n %@%@",day,isMorning ? @"上午" : @"下午",start]];
        [cell addSubview:tip];
        
        
        UIView *sep1 = [[UIView alloc]initWithFrame:CGRectMake(81,0.5, 0.5,59)];
        [sep1 setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
        [cell addSubview:sep1];
        
        
        UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(81,5,80,40)];
        [address setTextAlignment:NSTextAlignmentCenter];
        address.numberOfLines = 0;
        [address setTextColor:UIColorFromRGB(0x2f2f2f)];
        [address setFont:[UIFont systemFontOfSize:14]];
        [address setBackgroundColor:[UIColor clearColor]];
        [address setText:info[@"address"]];
        [cell addSubview:address];
        
        UIView *sep2 = [[UIView alloc]initWithFrame:CGRectMake(163,0.5, 0.5,59)];
        [sep2 setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
        [cell addSubview:sep2];
        
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(163,5,MAIN_WIDTH-163, 50)];
        [content setTextAlignment:NSTextAlignmentCenter];
        [content setTextColor:UIColorFromRGB(0x2f2f2f)];
        [content setFont:[UIFont systemFontOfSize:14]];
        [content setBackgroundColor:[UIColor clearColor]];
        [content setText:info[@"content"]];
        [cell addSubview:content];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,(self.m_isDay ?30 : 60)-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xDCDCDC)];
    [cell addSubview:sep];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    LeaderSchudeInfoControllerViewController *infoVc = [[LeaderSchudeInfoControllerViewController alloc]initWith:info isDay:self.m_isDay];
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)onNeedRefreshTableView
{
    [self requestData:YES];
}

@end
