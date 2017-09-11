//
//  SideslipView.m
//  xxt_xj
//
//  Created by Yang on 14/11/4.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "SideslipView.h"
#import "SliderTableViewCell.h"
#import "EGOImageButton.h"
#import "ClassIconImageView.h"

@interface SideslipView()<UITableViewDataSource,UITableViewDelegate,SliderUITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *cellName;
@property (nonatomic, strong) NSArray *cellNameImage;
@property (nonatomic, strong) UIView  *settingBackgroundView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) ClassIconImageView *avatarImageView;  ///< 头像
@property (nonatomic, strong) NSArray *m_arrSliderType;
@end

@implementation SideslipView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:UIColorFromRGB(0x204565)];
        self.tableView = [[SliderUITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.m_delegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHideView)];
        tap.delegate = self;
        [self.tableView addGestureRecognizer:tap];
        NSMutableArray *arr  = [NSMutableArray arrayWithArray:[LoginUserUtil arrModulesSlider]];
        [arr addObject:@{
                         @"icon":@"home_logout",
                         @"name":@"退出"}];
        self.m_arrSliderType = arr;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.m_arrSliderType.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sideslipCellIndentifier = @"sideslipCell";
    SliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sideslipCellIndentifier];
    if (!cell) {
        cell = [[SliderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sideslipCellIndentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSMutableArray *sideArr = [NSMutableArray arrayWithArray:self.m_arrSliderType];
    [cell setCellDic:[sideArr objectAtIndex:indexPath.row] with:_currentIndex == indexPath.row isHomeCell:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.m_arrSliderType.count)
    {
        return (MAIN_HEIGHT-DISTANCE_TOP-(self.m_arrSliderType.count)*50);
    }
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        [self.delegate onPopToHomeView];
    }
    else if(self.m_arrSliderType.count-1 != indexPath.row)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideslipViewTableView:didSelectRowAtIndexPath:)]) {
            [self.delegate sideslipViewTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onLogoutBtnClicked)]) {
            [self.delegate onLogoutBtnClicked];
        }
    }
   
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{

    [self.delegate onShowMainView];
    
    _currentIndex = currentIndex;
    [self.tableView reloadData];
    [self.delegate onSelectIndex:currentIndex];
}


- (void)showOrHideView
{
    [self.delegate onShowMainView];

}

#pragma mark - SliderUITableViewDelegate
- (void)onShowOrHideSelf
{
    [self.delegate onShowMainView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint pt = [touch locationInView:self.tableView];
    NSInteger y = (NSInteger)pt.y;
    if(y>self.m_arrSliderType.count*48)
    {
        return YES;
    }
    return NO;
}

@end
