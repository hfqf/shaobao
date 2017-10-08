//
//  SendMsgViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#define  DEFAULT_HEIGHT_CELL 63

#define HIRHGT_INPUT          36

#import "SendMsgViewController.h"
#import "ChatTextTableViewCell.h"
#import "ChatPictureTableViewCell.h"
#import "ChatInputView.h"
@interface SendMsgViewController ()<UITableViewDataSource,UITableViewDelegate,ChatInputViewDelegate>
@property(nonatomic,strong)ChatInputView *m_inputView;
@property(nonatomic,strong)ADTFindItem *m_findItem;
@property(nonatomic,strong)NSDictionary *m_group;
@end

@implementation SendMsgViewController

- (id)initWith:(ADTFindItem *)item
{
    self.m_findItem = item;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setFrame:CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64-50)];

        self.m_inputView = [[ChatInputView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-50, MAIN_WIDTH, 50)];
        self.m_inputView.m_delegate = self;
        [self.view addSubview:self.m_inputView];
    }
    return self;
}

- (void)requestData:(BOOL)isRefresh
{
    if(self.m_findItem.m_isSender){
        [HTTP_MANAGER findGetMessageGroupList:self.m_findItem.m_id
                               successedBlock:^(NSDictionary *succeedResult) {


                               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {


                               }];
    }else{
        [HTTP_MANAGER findGetMessagetGroup:self.m_findItem.m_id
                               successedBlock:^(NSDictionary *succeedResult) {
                                   if([succeedResult[@"ret"]integerValue] == 0){
                                       NSString *groupId = succeedResult[@"data"][@"id"];
                                       self.m_group = succeedResult[@"data"];
                                       [HTTP_MANAGER findGetMessageList:groupId
                                                              messageId:@"0"
                                                               pageSize:@"1000"
                                                         successedBlock:^(NSDictionary *succeedResult) {
                                                             if([succeedResult[@"ret"]integerValue]==0){
                                                                 NSMutableArray *arr = [NSMutableArray array];
                                                                 for(NSDictionary *info in succeedResult[@"data"]){
                                                                     ADTChatMessage *msg = [[ADTChatMessage alloc]init];
                                                                     if([info[@"imageUrl"]isKindOfClass:[NSNull class]]){
                                                                         msg.m_contentType = ENUM_MSG_TYPE_TEXT;
                                                                     }else{
                                                                         msg.m_contentType = ENUM_MSG_TYPE_PIC;
                                                                         msg.m_strMediaPath = info[@"imageUrl"];
                                                                     }
                                                                     msg.m_strMessageBody = info[@"content"];
                                                                     msg.m_isFromSelf = [info[@"sendUserId"]longLongValue] == [LoginUserUtil shaobaoUserId].longLongValue;
                                                                     msg.m_oppositeChaterId = info[@"sendUserId"];
                                                                     msg.m_strOppositeSideName = info[@"sendUserName"];
                                                                     msg.m_strTimestamp = info[@"createTime"];
                                                                     msg.m_strGroupAvatar = info[@"sendUserAvatar"];
                                                                     [arr addObject:msg];
                                                                 }

                                                                 self.m_arrData = arr;
                                                             }
                                                             [self reloadDeals];

                                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                           

                                       }];
                                   }


                               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                   [self reloadDeals];

                               }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_findItem.m_isSender ? self.m_findItem.m_acceptUserName : self.m_findItem.m_userName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取每个cell的高度
- (CGFloat)hightOfCell:(NSInteger)section
{
    ADTChatMessage *msg = [self.m_arrData objectAtIndex:section];
    BOOL isNeedShowTimeTitle = msg.m_timeLabState == ENUM_TIMELAB_STATE_SHOW ? YES : NO;

    CGSize bubbleSize = CGSizeZero;
    //设置一个行高上限
    if(msg.m_contentType == ENUM_MSG_TYPE_TEXT)
    {
            CGSize size = [FontSizeUtil sizeOfString:msg.m_strShiftedMsg withFont:[UIFont systemFontOfSize:FONT_SIZE] withWidth:MAX_LENGTH_CHAT_CELL];

            return size.height+43+(isNeedShowTimeTitle ? 20 :0)+10;
    }
    else if(msg.m_contentType == ENUM_MSG_TYPE_PIC)
    {

        NSString *urlStr = [NSString stringWithFormat:@"%@/upload/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],msg.m_isFromSelf == ENUM_MESSAGEFROM_SELF ?  msg.m_strMediaPath :  msg.m_strMessageBody];

        // 先判断路径
        //        NSString *urlStr = [NSString stringWithFormat:@"%@/upload/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],msg.m_strMessageBody];
        UIImage *image = [LocalImageHelper getImageWithPath:urlStr];
        if( image == nil)
        {
            image = [UIImage imageNamed:@"app_fail_image"];
        }
        bubbleSize = image.size;
        return bubbleSize.height+33+(isNeedShowTimeTitle ? 20 :0)+20;
    }
    return 0;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger  count = self.m_arrData.count;
    return count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self hightOfCell:indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTChatMessage *msg = [self.m_arrData objectAtIndex:indexPath.section];
    if(msg.m_contentType == ENUM_MSG_TYPE_TEXT)
    {
        ChatTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_TEXT_CELL];
        if (cell == nil)
        {
            cell = [[ChatTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHAT_TEXT_CELL];
        }
        [cell setValueDataWithMsg:msg];
        return cell;
    }
    else if (msg.m_contentType == ENUM_MSG_TYPE_PIC)
    {
        ChatPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_PICTURE_CELL];
        if (cell == nil)
        {
            cell = [[ChatPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHAT_PICTURE_CELL];
        }
        [cell setValueDataWithMsg:msg];
        return cell;
    }
    return [[UITableViewCell alloc]init];
}
//----赞评论代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark -

- (void)onChatInputViewDelegateSendPhoto
{

}

- (void)onChatInputViewDelegateSendText:(NSString *)msg
{
    [HTTP_MANAGER findSendMessage:self.m_group[@"id"]
                          content:msg
                          picUrls:@""
                   successedBlock:^(NSDictionary *succeedResult) {


    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        

    }];
}

- (void)onChatInputViewDelegateSendLibrary
{

}

@end
