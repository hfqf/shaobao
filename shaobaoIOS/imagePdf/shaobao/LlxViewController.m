//
//  LlxViewController.m
//  shaobao
//
//  Created by points on 2017/9/16.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LlxViewController.h"
#import "ADTLxxItemInfo.h"
#import "AddNewLxxViewController.h"
#import "LxxTableViewCell.h"
@interface LlxViewController ()<UITableViewDataSource,UITableViewDelegate,LxxTableViewCellDelegate,UITextFieldDelegate>
{
       UIView *m_tipView;
}
@property(nonatomic,strong)ADTLxxItemInfo *m_commentInfo;
@property(nonatomic,strong)UITextField *m_input;

@end

@implementation LlxViewController
-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.tableHeaderView = m_searchBar;

        self.m_input = [[UITextField alloc]initWithFrame:CGRectMake(0,MAIN_HEIGHT, MAIN_WIDTH, 44)];
        self.m_input.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        self.m_input.layer.borderWidth = 0.5;
        [self.m_input setBackgroundColor:[UIColor whiteColor]];
        [self.m_input setPlaceholder:@"请输入评论"];
        [self.m_input setTextColor:[UIColor blackColor]];
        self.m_input.delegate = self;
        self.m_input.returnKeyType = UIReturnKeySend;
        [self.view addSubview:self.m_input];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

        [self createButtons];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBackBtn];
    [title setText:@"辣新鲜"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(MAIN_WIDTH-80,20, 70, 44)];
    [slideBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [slideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
}

- (void)addBtnClicked
{
    AddNewLxxViewController *add = [[AddNewLxxViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"最新议题",@"最热话题"];

    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame)-10, MAIN_WIDTH/self.m_arrCategory.count, 36)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+32, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0,104, MAIN_WIDTH,MAIN_HEIGHT-104-HEIGHT_MAIN_BOTTOM)];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestCategoryData];

}


- (void)requestCategoryData
{
    [self requestData:YES];
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == self.m_currentIndex)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}

- (void)requestData:(BOOL)isRefresh
{
    NSString *lastId = nil;
    if(isRefresh){
        lastId = @"0";
    }else{
        ADTLxxItemInfo *info = [self.m_arrData lastObject];
        lastId = info.m_id;
    }
    [self showWaitingView];
    [HTTP_MANAGER getBbsList:self.m_currentIndex == 0 ? @"1" : @"2"
                       bbsId:lastId
              successedBlock:^(NSDictionary *succeedResult) {
                  [self removeWaitingView];
                  if([succeedResult[@"ret"]integerValue] == 0){
                      NSArray *arr = succeedResult[@"data"];
                      NSMutableArray *arrInsert = isRefresh ?  [NSMutableArray array] : [NSMutableArray arrayWithArray:self.m_arrData];
                      for(NSDictionary *info in arr){
                          ADTLxxItemInfo *_info = [ADTLxxItemInfo from:info];
                          [arrInsert addObject:_info];
                      }
                      self.m_arrData = arrInsert;
                  }
                  [self reloadDeals];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];

    }];
}

- (CGFloat)high:(ADTLxxItemInfo *)currentData
{
    CGFloat high = 40;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:15] withWidth:(MAIN_WIDTH-(20+70))];
    high+=size.height;
    high+=40;

    NSInteger row = ceil(currentData.m_arrPics.count/3.0);
    NSInteger sep = 10;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-(70+sep*(cell_num+1)))/3;
    high+= (sep+width)*row;


    for(NSDictionary *info in currentData.m_arrComments){
        NSString *content = [NSString stringWithFormat:@"%@回复:%@",info[@"userName"], info[@"content"]];
        CGSize size = [FontSizeUtil sizeOfString:content withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-130];
        high += (size.height > 40 ? size.height : 40);
    }
    return high;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:[self.m_arrData objectAtIndex:indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    LxxTableViewCell *cell = [[LxxTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.m_delegate = self;
    cell.currentData = [self.m_arrData objectAtIndex:indexPath.row];
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-44)];
    self.m_input.frame = CGRectMake(0, MAIN_HEIGHT-44-kbSize.height, MAIN_WIDTH, 44);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-HEIGHT_MAIN_BOTTOM)];
    self.m_input.frame = CGRectMake(0, MAIN_HEIGHT, MAIN_WIDTH, 44);
}

#pragma mark - LxxTableViewCellDelegate

- (void)onLxxTableViewCellDelegateForDel:(ADTLxxItemInfo *)info
{
    [HTTP_MANAGER delBbs:info.m_id
          successedBlock:^(NSDictionary *succeedResult) {
              if([succeedResult[@"ret"]integerValue]==0){
                  [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                  [self requestData:YES];
              }else{
                  [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
              }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];
}

- (void)onLxxTableViewCellDelegateForComment:(ADTLxxItemInfo *)info
{
    self.m_commentInfo = info;
    [self.m_input becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [HTTP_MANAGER sendBbsComment:self.m_commentInfo.m_id
                         content:textField.text
                  successedBlock:^(NSDictionary *succeedResult) {
                      [self requestData:YES];
                      [self.m_input setText:nil];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];
    [textField resignFirstResponder];
    return YES;
}
@end
