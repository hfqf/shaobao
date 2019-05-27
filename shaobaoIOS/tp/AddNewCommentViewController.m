//
//  AddNewCommentViewController.m
//  shaobao
//
//  Created by Points on 2019/5/21.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "AddNewCommentViewController.h"

@interface AddNewCommentViewController ()
@property(nonatomic,strong)id relationData;
@end

@implementation AddNewCommentViewController
- (instancetype)initWith:(id)relationData{
    self.relationData = relationData;
    if(self = [super init]){
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [title setText:@"发表评论"];
}

- (void)addBtnClicked
{
    if(self.m_input.text.length == 0 ||  [self.m_input.text isEqualToString:@"最多200字"]){
        [PubllicMaskViewHelper showTipViewWith:@"发布内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    __block NSInteger count=0;
    [self showWaitingView];
    NSString *relation = @"";
    NSString *type = @"";
    if([self.relationData isKindOfClass:[ADTStaffItem class]]){
        ADTStaffItem *person = (ADTStaffItem *)self.relationData;
        relation = person.m_id;
        type = @"1";
    }else{
        ADTVoteItem *person = (ADTVoteItem *)self.relationData;
        relation = person.m_id;
        type = @"2";
    }
    
    
    if(self.selectedPhotos.count==0){
      
        [HTTP_MANAGER addComment:relation
                            type:type
                         content:self.m_input.text
                        imageUrl:@""
                  successedBlock:^(NSDictionary *succeedResult) {
                      [self removeWaitingView];
                      if([succeedResult[@"ret"]integerValue]==0){
                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                          [self.m_delegate onNeedRefreshTableView];
                          [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                      }
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [self removeWaitingView];
        }];
        
    }else{
        
        for(UIImage *img in self.selectedPhotos){
            [HTTP_MANAGER uploadShaobaoFileWithPathData:UIImageJPEGRepresentation(img,0.1)
                                           successBlock:^(NSDictionary *succeedResult) {
                                               [self.m_arrFilePics addObject:succeedResult[@"data"][@"fileUrl"]];
                                               count++;
                                               if(count == self.selectedPhotos.count){
                                                   
                                                   NSMutableString *str =[NSMutableString string];
                                                   for(NSString *url in self.m_arrFilePics){
                                                       [str appendFormat:@"%@,",url];
                                                   }
                                                   
                                                   [HTTP_MANAGER addComment:relation
                                                                       type:type
                                                                    content:self.m_input.text
                                                                   imageUrl:str
                                                             successedBlock:^(NSDictionary *succeedResult) {
                                                                 [self removeWaitingView];
                                                                 if([succeedResult[@"ret"]integerValue]==0){
                                                                     [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                                                     [self.m_delegate onNeedRefreshTableView];
                                                                     [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                                                                 }
                                                             } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                                                 [self removeWaitingView];
                                                             }];
                                                   
                                               }else{
                                                   [self removeWaitingView];
                                                   [PubllicMaskViewHelper showTipViewWith:[NSString stringWithFormat:@"上传附件%lu/%lu",count,self.selectedPhotos.count] inSuperView:self.view withDuration:1];
                                               }
                                           } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                               [self removeWaitingView];
                                           }];
        }
    }
    
    
}

@end
