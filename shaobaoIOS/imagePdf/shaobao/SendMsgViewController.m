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
@interface SendMsgViewController ()<UITableViewDataSource,UITableViewDelegate,ChatInputViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
        [self.tableView setFrame:CGRectMake(0, HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_NAVIGATION-50)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0xf9f9f9)];

        self.m_inputView = [[ChatInputView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-50, MAIN_WIDTH, 50)];
        self.m_inputView.m_delegate = self;
        [self.view addSubview:self.m_inputView];


        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}



- (void)autoRequest{
    [self requestData:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-50)];
    self.m_inputView.frame = CGRectMake(0, MAIN_HEIGHT-50-kbSize.height, MAIN_WIDTH, 50);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-50)];
    self.m_inputView.frame = CGRectMake(0, MAIN_HEIGHT-50, MAIN_WIDTH, 50);
}

- (void)requestData:(BOOL)isRefresh
{
    if(self.m_findItem.m_isSender){
        [HTTP_MANAGER findGetMessageList:self.m_findItem.m_id
                               messageId:@"0"
                                pageSize:@"1000"
                          successedBlock:^(NSDictionary *succeedResult) {
                              if([succeedResult[@"ret"]integerValue]==0){
                                  NSMutableArray *arr = [NSMutableArray array];
                                  for(NSDictionary *info in succeedResult[@"data"]){
                                      ADTChatMessage *msg = [[ADTChatMessage alloc]init];
                                      if([[info stringWithFilted:@"imageUrl"]length] == 0){
                                          msg.m_contentType = ENUM_MSG_TYPE_TEXT;
                                      }else{
                                          msg.m_contentType = ENUM_MSG_TYPE_PIC;
                                          msg.m_strMediaPath = [info stringWithFilted:@"imageUrl"];
                                      }
                                      msg.m_strMessageBody =[info stringWithFilted:@"content"];
                                      msg.m_isFromSelf = [[info stringWithFilted:@"sendUserId"]longLongValue] == [LoginUserUtil shaobaoUserId].longLongValue;
                                      msg.m_oppositeChaterId = [info stringWithFilted:@"sendUserId"];
                                      msg.m_strOppositeSideName =[[info stringWithFilted:@"sendUserName"]length] == 0 ?[info stringWithFilted:@"sendUserId"]:[info stringWithFilted:@"sendUserName"] ;
                                      msg.m_strTimestamp = [info stringWithFilted:@"createTime"];
                                      msg.m_strGroupAvatar = [info stringWithFilted:@"sendUserAvatar"];
                                      [arr addObject:msg];
                                  }

                                  self.m_arrData = arr;
                              }
                              [self reloadDeals];

        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [self reloadDeals];
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
                                                                     if([[info stringWithFilted:@"imageUrl"]length]==0){
                                                                         msg.m_contentType = ENUM_MSG_TYPE_TEXT;
                                                                     }else{
                                                                         msg.m_contentType = ENUM_MSG_TYPE_PIC;
                                                                         msg.m_strMediaPath =[info stringWithFilted:@"imageUrl"];
                                                                     }
                                                                     msg.m_strMessageBody = [info stringWithFilted:@"content"];
                                                                     msg.m_isFromSelf = [info[@"sendUserId"]longLongValue] == [LoginUserUtil shaobaoUserId].longLongValue;
                                                                     msg.m_oppositeChaterId = info[@"sendUserId"];
                                                                     msg.m_strOppositeSideName =[[info stringWithFilted:@"sendUserName"]length] == 0 ?[info stringWithFilted:@"sendUserId"]:[info stringWithFilted:@"sendUserName"] ;
                                                                     msg.m_strTimestamp = [info stringWithFilted:@"createTime"];
                                                                     msg.m_strGroupAvatar = [info stringWithFilted:@"sendUserAvatar"];
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
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                    repeats:YES
                                      block:^(NSTimer * _Nonnull timer) {
                                       [self autoRequest];
        
    }];
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
    BOOL isNeedShowTimeTitle = YES ;

    CGSize bubbleSize = CGSizeZero;
    //设置一个行高上限
    if(msg.m_contentType == ENUM_MSG_TYPE_TEXT)
    {
            CGSize size = [FontSizeUtil sizeOfString:msg.m_strShiftedMsg withFont:[UIFont systemFontOfSize:FONT_SIZE] withWidth:MAX_LENGTH_CHAT_CELL];

            return size.height+43+(isNeedShowTimeTitle ? 20 :0)+10;
    }
    else if(msg.m_contentType == ENUM_MSG_TYPE_PIC)
    {
        bubbleSize = CGSizeMake(200, 100);
        return bubbleSize.height+33+(isNeedShowTimeTitle ? 20 :0)+30;
    }
    return 0;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  count = self.m_arrData.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self hightOfCell:self.m_arrData.count-indexPath.row-1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTChatMessage *msg = [self.m_arrData objectAtIndex:self.m_arrData.count-indexPath.row-1];
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
    [LocalImageHelper selectPhotoFromCamera:self];
}

- (void)onChatInputViewDelegateSendLibrary
{
    [LocalImageHelper selectPhotoFromLibray:self];
}


- (void)onChatInputViewDelegateSendText:(NSString *)msg
{
    [HTTP_MANAGER findSendMessage:self.m_group== nil ?self.m_findItem.m_id : self.m_group[@"id"]
                          content:msg
                          picUrls:@""
                   successedBlock:^(NSDictionary *succeedResult) {

                       if([succeedResult[@"ret"]integerValue] ==0 ){

                           NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                           ADTChatMessage *insertMsg = [[ADTChatMessage alloc]init];
                           insertMsg.m_contentType = ENUM_MSG_TYPE_TEXT;
                           insertMsg.m_strMessageBody = msg;
                           insertMsg.m_isFromSelf = YES;
                           insertMsg.m_strTimestamp = [LocalTimeUtil getCurrentTime];

                           [arr insertObject:insertMsg atIndex:0];
                           self.m_arrData = arr;
                           [self reloadDeals];

                       }else{
                           [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        

    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [self showWaitingView];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:NO completion:NULL];
    NSString *path = [LocalImageHelper saveImage2:image];
    [HTTP_MANAGER uploadShaobaoFileWithPath:path
                               successBlock:^(NSDictionary *succeedResult) {
                                   [self removeWaitingView];
                                   if([succeedResult[@"ret"]integerValue] == 0){
                                       NSString *pic = [NSString stringWithFormat:@"%@",succeedResult[@"data"][@"fileUrl"]];
                                       [HTTP_MANAGER findSendMessage:self.m_group== nil ?self.m_findItem.m_id : self.m_group[@"id"]
                                                             content:@""
                                                             picUrls:pic
                                                      successedBlock:^(NSDictionary *succeedResult) {

                                                          if([succeedResult[@"ret"]integerValue] ==0 ){

                                                              NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                                              ADTChatMessage *insertMsg = [[ADTChatMessage alloc]init];
                                                              insertMsg.m_contentType = ENUM_MSG_TYPE_PIC;
                                                              insertMsg.m_strMessageBody = pic;
                                                              insertMsg.m_isFromSelf = YES;
                                                              insertMsg.m_strTimestamp = [LocalTimeUtil getCurrentTime];
                                                              [arr addObject:insertMsg];
                                                              self.m_arrData = arr;
                                                              [self reloadDeals];

                                                          }else{
                                                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                                          }

                                                      } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {


                                                      }];

                                   }

                               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                   [self removeWaitingView];
                               }];

}


@end
