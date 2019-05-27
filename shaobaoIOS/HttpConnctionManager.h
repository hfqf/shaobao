//
//  HttpConnctionManager.h
//  JZH_Test
//  httpæ°æ®è¯·æ±ç®¡çç±»
//  Created by Points on 13-9-29.
//  Copyright (c) 2013å¹´ Points. All rights reserved.


@protocol HttpConnctionManagerDelegate <NSObject>

@optional
//ä¸ä¼ å¾ç
- (void)uploadPicSucceed:(NSString *)filePath returnedDic:(NSDictionary *)dic;
- (void)uploadPicFailed:(NSString *)filePath error: (NSError *)error;

//ä¸ä¼ é³é¢
- (void)uploadAudioSucceed:(NSString *)filePath returnedDic:(NSDictionary *)dic;
- (void)uploadAudioFailed:(NSString *)filePath error: (NSError *)error;

//ä¸è½½é³é¢æä»¶æå
- (void)downloadAudioFileSucceed:(NSString *)path withReturnDic:(NSDictionary *)dic;
- (void)downloadAudioFileFailed;

//ä¸è½½å¾ç
- (void)downloadPictureFileSucceed:(NSString *)path;
- (void)downloadPictureFileFailed;


 

@end

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import"AFHTTPRequestOperationManager.h"

#import "JSONKit.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "LocalImageHelper.h"
#import "LoginUserUtil.h"
#import "AFURLRequestSerialization.h"
#import "ADTGovermentFileInfo.h"
#import "ADTFindItem.h"


@interface HttpConnctionManager : AFHTTPRequestOperationManager<NSURLConnectionDelegate,NSStreamDelegate>
{
    NSMutableData *returnInfoData;
}

@property(nonatomic,assign)id<HttpConnctionManagerDelegate>delegate;

@property (nonatomic,strong)NSInputStream *m_input;

SINGLETON_FOR_HEADER(HttpConnctionManager);

typedef void (^SuccessedBlock)(NSDictionary *succeedResult);

typedef void (^downFileSuccessedBlock)(NSString *lcoalPath);

typedef void (^FailedBlock)(AFHTTPRequestOperation *response, NSError *error);

typedef void (^FailBlock)(NSError *error);

#pragma mark - Public

- (void)startGetWith:( NSString *)url
            paragram:(NSDictionary *)para
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

//普通的post请求
- (void)startNormalPostWith:( NSString *)url
                   paragram:(NSDictionary *)para
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)startMulitDataPost:( NSString *)url
                  fileName:(NSString *)fileName
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;


//登录
- (void)startLogin:(NSString *)name pwd:(NSString *)pwd successedBlock:(SuccessedBlock)success failedBolck:(FailedBlock)failed;

//获取待办文件
- (void)getTodoFile:(NSString *)appType
                key:(NSString *)key
         actorClass:(NSString *)actorClass
         startIndex:(NSString *)start
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

//获取待办文件详情
- (void)getTodoFileInfoWith:(NSString *)msgId
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

//获取已办文件
- (void)getDoneFile:(NSString *)actor
                key:(NSString *)key
         actorClass:(NSString *)actorClass
         startIndex:(NSString *)start
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

//获取邮件列表
- (void)getEmailWithType:(NSInteger)type
                     key:(NSString *)key
                  sender:(NSString *)senderId
              startIndex:(NSString *)start
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

//获取联系人
- (void)getContact:(NSString *)key
             depId:(NSString *)depId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;


//获取联系人
- (void)getDeptUsers:(NSString *)depId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)getDeptList:(NSString *)deptName
           parentId:(NSString *)parentId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)getDeptInfo:(NSString *)deptId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)getDepInfo:(NSString *)deptId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getDepatment:(NSString *)depId
            deptName:(NSString *)deptName
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getNewUserList:(NSString *)depId
              userName:(NSString *)userName
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)getContactInfo:(NSString *)userId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

/**
 ["获取消息列表"] *	@brief	获取消息列表
 ["电话号码"] *	@param 	tel 	电话号码
 ["搜索关键字"] *	@param 	key 	搜索关键字
 ["索引值"] *	@param 	index 	索引值
 ["成功回调"] *	@param 	success 	成功回调
 [""] *	@param 	failed 	失败回调
 [""] *
 [""] *	@return	void
 [""] */
- (void)getMessageWithTel:(NSString *)tel
                  WithKey:(NSString *)key
               startIndex:(NSNumber *)index
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

/**
[""] *	@brief	发送短信
[""] *
[""] *	@param 	tel 	电话号码
[""] *	@param 	content 	内容
[""] *	@param 	success 	成功回调
[""] *	@param 	failed 	失败回调
[""] *
[""] *	@return	void
[""] */
- (void)sendMessageWithTel:(NSString *)tel
               WithContent:(NSString *)content
                  WithTime:(NSString *)sendTime
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

#pragma mark - 通知管理


- (void)getNoticeList:(NSString *)key
                index:(NSNumber *)index
               status:(NSString *)status
                 type:(NSInteger)type
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)getNoticeInfo:(NSString *)noticeId
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)getNoticeDetail:(NSString *)detailId
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)getNoticeUserList:(NSString *)detailId
                 noticeId:(NSString *)noticeId
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;


- (void)addNewNotice:(NSString *)title
                type:(NSString *)type
             address:(NSString *)address
           startTime:(NSString *)startTime
             endTime:(NSString *)endTime
                desc:(NSString *)desc
                file:(NSArray *)fileArr
          isFeedfile:(BOOL)isFeedfile
            isperson:(BOOL)isperson
              isunit:(BOOL)isunit
    receiveUnitNames:(NSString *)receiveUnitNames
      receiveUnitIds:(NSString *)receiveUnitIds
            noticeId:(NSString *)noticeId
      isNeedFeedBack:(BOOL)isNeedFeedBack
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)getUnits:(NSString *)parentId
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;


- (void)saveInfoPersons:(NSString *)recUserIds
               noticeId:(NSString *)noticeId
               detailId:(NSString *)detailId
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)feedbackNotice:(NSString *)answer
              detailId:(NSString *)detailId
            isfeedback:(BOOL)isfeedback
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)confirmReceivedNotice:(NSString *)detailId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

#pragma mark -

- (void)getAbsenceList:(NSString *)key
                 index:(NSNumber *)index
                 statu:(BOOL)statu
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)disagree:(NSDictionary *)info
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

- (void)agreeAbsence:(NSDictionary *)info
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

- (void)saveAbsence:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)postAbsence:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)GetEmialInfo:(NSString *)mailId
           isSaveBox:(BOOL)isSaveBox
               msgId:(NSString *)msgId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)GetRepostEmialInfo:(NSString *)mailId
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)uploadPDFFileWithPath:(NSString *)filePath
              withFileData:(NSData *)data
                    params:(NSDictionary *)params
              successBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)uploadFileWithPath:(NSData *)fileData
                    params:(NSDictionary *)params
              successBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)downloadQPFileWithUrl:(NSString *)url
                       params:(NSDictionary *)params
                 successBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)downloadFileWithUrl:(NSString *)url
                     params:(NSDictionary *)params
               successBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)downloadFileWithUrl:(NSString *)url
                   fileName:(NSString *)fileName
                     params:(NSDictionary *)params
               successBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)dealwithEmail:(int)type
             withInfo:(NSDictionary *)info
         withReceiver:(NSArray *)arrReceive
      withReceiverBTW:(NSArray *)arrReceiveBTW
   withReceiverSecret:(NSArray *)arrReceiveSecret
             withUUid:(NSString *)uuid
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)deleteEmail:(NSDictionary *)reqDic
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)deleteFile:(NSString *)fileId
           docType:(int)docType
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getTodoInfo:(NSString *)msgId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)saveTodoFile:(NSString *)option
            WithInfo:(ADTGovermentFileInfo *)info
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)getTodoContact:(NSDictionary *)reqDic
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)giveUpTodo:(NSDictionary *)reqDic
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)commitTodo:(NSDictionary *)reqDic
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;


- (void)getGovermentFileInfo:(NSString *)documentId
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed;

- (void)updateNotice:(NSString *)noticeId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)deleAbense:(NSString *)abenseId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)updateEmailStateToReaded:(NSString *)msgId
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;


- (void)getTipNum:(SuccessedBlock)success failedBolck:(FailedBlock)failed;


#pragma mark -  日程

- (void)getScheduleList:(NSInteger)startIndex
              startTime:(NSString *)startTime
                endTime:(NSString *)endTime
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)saveSchdule:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)modifySchdule:(NSDictionary *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)deleteSchdule:(NSDictionary *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)getNum:(NSInteger)type
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

- (void)getGroupList:(NSString *)depId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

#pragma mark - 通知
- (void)updateMessageToReaded:(NSString *)msgId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;


#pragma mark - 建邺oa新增接口


#pragma mark - 会议管理
- (void)getMeetingManagerList:(NSInteger)index
                      subject:(NSString *)subject
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)getMeetingInfo:(NSString *)meetingId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

///会议审核
- (void)dealMeeting:(NSString *)roomId
            address:(NSString *)address
         relationId:(NSString *)relationId
          auditType:(NSString *)auditType
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

///会议室申请
- (void)applyMeetingRoomWithApplyDate:(NSString *)applyDate
                          applyStatus:(NSString *)applyStatus
                          auditUserId:(NSString *)auditUserId
                         cancelStatus:(NSString *)cancelStatus
                         cancelUserId:(NSString *)cancelUserId
                             contacts:(NSString *)contacts
                          contactsTel:(NSString *)contactsTel
                           createDate:(NSString *)createDate
                         createDeptId:(NSString *)createDeptId
                       createDeptName:(NSString *)createDeptName
                          createOrgId:(NSString *)createOrgId
                        createOrgName:(NSString *)createOrgName
                         createUserId:(NSString *)createUserId
                       createUserName:(NSString *)createUserName
                             hostUnit:(NSString *)hostUnit
                            isConfirm:(NSString *)isConfirm
                              isLarge:(NSString *)isLarge
                               isOpen:(NSString *)isOpen
                              leaders:(NSString *)leaders
                       meetingDateEnd:(NSString *)meetingDateEnd
                     meetingDateStart:(NSString *)meetingDateStart
                        meetingDemand:(NSString *)meetingDemand
                          meetingName:(NSString *)meetingName
                         noticeStatus:(NSString *)noticeStatus
                            peolpeNum:(NSString *)peolpeNum
                          roomAddress:(NSString *)roomAddress
                               roomId:(NSString *)roomId
                        specialDemand:(NSString *)specialDemand
                         tableSetType:(NSString *)tableSetType
                            useStatus:(NSString *)useStatus
                       successedBlock:(SuccessedBlock)success
                          failedBolck:(FailedBlock)failed;

- (void)getMeetingRooms:(NSString *)startTime
                endTime:(NSString *)endTime
             peopleNum1:(NSString *)peopleNum1
             peopleNum2:(NSString *)peopleNum2
           facilityInfo:(NSString *)facilityInfo
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

#pragma mark - 督查督办

- (void)getObserverList:(NSInteger)index
                subject:(NSString *)subject
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)getObserverInfo:(NSString *)_id
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

#pragma mark - 获取电子期刊列表
- (void)getManagersMenuList:(NSString *)parentId
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)getEManagerList:(NSInteger)index
                subject:(NSString *)subject
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

#pragma mark - 资源中心



- (void)getResourceCenterMenuList:(NSString *)parentId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)getResourceCenterList:(NSString *)parentId
                     subjecet:(NSString *)subjecet
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)getResourceCenterFileInfo:(NSString *)dataId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)getResourceCenterTopicList:(NSString *)dataId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;


#pragma mark - 领导日程

- (void)getLeaderWeekScheduleList:(NSInteger)index
                       agentDate1:(NSString *)agentDate1
                       agentDate2:(NSString *)agentDate2
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)getLeaderDayScheduleList:(NSInteger)index
                      agentDate1:(NSString *)agentDate1
                      agentDate2:(NSString *)agentDate2
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)getLeaderWeekScheduleInfo:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)getLeaderDayScheduleInfo:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)addNewDaySchedule:(NSString *)address
                agentDate:(NSString *)agentDate
                  content:(NSString *)content
                  endTime:(NSString *)endTime
             hostUnitName:(NSString *)hostUnitName
                 leaderId:(NSString *)leaderId
               leaderName:(NSString *)leaderName
              participant:(NSString *)participant
                startTime:(NSString *)startTime
                whichWeek:(NSString *)whichWeek
                whichYear:(NSString *)whichYear
               scheduleId:(NSString *)scheduleId
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

#pragma mark - 单位收文

- (void)getDepartmentReceiveArticles:(NSString *)index
                              stauts:(BOOL)isUnsigned
                                 key:(NSString *)key
                      successedBlock:(SuccessedBlock)success
                         failedBolck:(FailedBlock)failed;

- (void)getDepartmentReceiveArticleInfo:(NSString *)documentId
                              receiveId:(NSString *)receiveId
                         successedBlock:(SuccessedBlock)success
                            failedBolck:(FailedBlock)failed;

- (void)updateDepartmentReceiveArticleInfo:(NSString *)documentId
                                     appId:(NSString *)appId
                            successedBlock:(SuccessedBlock)success
                               failedBolck:(FailedBlock)failed;



/**
 获取公文未读数
 
 @param success
 @param failed
 */
- (void)getNumDocumentUnreadNum:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

/**
 获取故障报修未读数
 
 @param success
 @param failed
 */
- (void)getNumFaultRepairUnreadNum:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed;

/**
 获取通知管理未读数
 
 @param success
 @param failed
 */
- (void)getNumNoticeUnreadNum:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

/**
 获取会议管理未读数
 
 @param success
 @param failed
 */
- (void)getNumMeetingUnreadNum:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

/**
 获取督办数字未读数
 
 @param success
 @param failed
 */
- (void)getNumDocManagerUnreadNum:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;
/**
 获取单位收文未读数
 
 @param success
 @param failed
 */
- (void)getNumDocumentSignUnreadNum:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

#pragma mark - 故障维修

- (void)getFaultRepairList:(NSInteger)index
                   appType:(NSString *)appType
                       key:(NSString *)key
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)getFaultRepairInfo:(NSString *)messageId
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)getFaultRepairItemSetting:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)getFaultRepairFlowEntrySetting:(NSString *)appId
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed;


- (void)saveFaultRepair:(NSString *)option
          WithMessageId:(NSString *)messageId
            WithInnerId:(NSString *)innerId
        WithFlowmodelid:(NSString *)flowmodelid
              withForms:(NSArray *)arrForms
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)commitFaultRepair:(NSDictionary *)reqDic
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;


- (void)savePhraseToServerList:(NSString *)content
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)getTodoPhraseServerList:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;



#pragma mark - 少保
- (void)startRegister:(NSString *)loginName
            loginPass:(NSString *)loginPass
             userName:(NSString *)userName
                 type:(NSString *)type
                phone:(NSString *)phone
                email:(NSString *)email
               weixin:(NSString *)weixin
                   qq:(NSString *)qq
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;


- (void)startLogin:(NSString *)loginName
         loginPass:(NSString *)loginPass
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)shaobaoLogout:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

#pragma mark - 发现
///删除我的发布
- (void)findDeleteOne:(NSString *)_id
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///查询需求服务列表
- (void)findGetHelpList:(NSString *)type
               userType:(NSString *)userType
                 status:(NSString *)status
                provice:(NSString *)provice
                   city:(NSString *)city
                 county:(NSString *)county
              startTime:(NSString *)startTime
                endTime:(NSString *)endTime
                 helpId:(NSString *)helpId
               pageSize:(NSString *)pageSize
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

///POST 查询咨询消息组列表(需求发布者调用)

- (void)findGetMessageGroupList:(NSString *)helpId
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

///POST /help/getMessageList 查询消息详情列表

- (void)findGetMessageList:(NSString *)groupId
                 messageId:(NSString *)messageId
                  pageSize:(NSString *)pageSize
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

///POST /help/getMessagetGroup 查询咨询消息组（咨询者调用，组不存在自动创建并返回）
- (void)findGetMessagetGroup:(NSString *)helpId
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed;

///POST /help/getMyAcceptHelpList 查询我承接的需求列表
- (void)findGetMyAcceptHelpList:(NSString *)helpId
                       pageSize:(NSString *)pageSize
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

///POST /help/getMySendHelpList 查询我发布的需求列表
- (void)findGetMySendHelpList:(NSString *)helpId
                     pageSize:(NSString *)pageSize
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

///POST /help/pay 支付

- (void)findPay:(NSString *)helpId
     serviceFee:(NSString *)serviceFee
      creditFee:(NSString *)creditFee
          total:(NSString *)total
       netMoney:(NSString *)netMoney
       relMoney:(NSString *)relMoney
        payType:(NSString *)payType
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed;

/// POST /help/send 发布(个人发布需求、商家发布服务)
- (void)findSend:(NSString *)type
         content:(NSString *)content
        province:(NSString *)province
            city:(NSString *)city
          county:(NSString *)county
         address:(NSString *)address
      serviceFee:(NSString *)serviceFee
       creditFee:(NSString *)creditFee
           phone:(NSString *)phone
          weixin:(NSString *)weixin
              qq:(NSString *)qq
         picUrls:(NSString *)picUrls
           email:(NSString *)email
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

/// POST /help/sendMessage 发送消息
- (void)findSendMessage:(NSString *)groupId
                content:(NSString *)content
                picUrls:(NSString *)picUrls
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

///POST /help/updateStatus 确认承接或确认需求完成（用于更新需求状态）

- (void)findUpdateStatus:(NSString *)helpId
                 optType:(NSString *)optType
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

/**

 父级ID，省份的父级为中国id=1

 @param pid
 @param success
 @param failed
 */
- (void)findQueryArea:(NSString *)pid
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///联系承接人（发布者调用，查询组信息，组不存在自动创建并返回）
- (void)getAcceptMessageGroup:(NSString *)helpId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)score:(NSString *)helpId
  scoreResult:(NSString *)scoreResult
 scoreContent:(NSString *)scoreContent
      optType:(NSString *)optType
successedBlock:(SuccessedBlock)success
  failedBolck:(FailedBlock)failed;
#pragma mark - 广告

- (void)getAds:(NSString *)type
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

- (void)uploadShaobaoFileWithPath:(NSString *)filePath
                 successBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;



#pragma mark - 辣新鲜
- (void)getBbsList:(NSString *)type
             bbsId:(NSString *)bbsId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)delBbs:(NSString *)bbsId
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

- (void)sendBbs:(NSString *)content
       withPics:(NSString *)pics
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed;


- (void)sendBbsComment:(NSString *)bbsId
               content:(NSString *)content
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;


- (void)uploadShaobaoFileWithPathData:(NSData *)FileData
                         successBlock:(SuccessedBlock)success
                          failedBolck:(FailedBlock)failed;


#pragma mark - 支付 - 如果网币够，可以网币支付 支付宝和微信，都是先调各自的支付接口，然后你拿着返回的信息，去调用支付宝和微信的SDK微信有个预支付的流程，就是要我服务端先调用他接口预支付，然后会返回一个信息给你，你要带着微信返回的信息调用SDK 调用SDK之后成功了，再调用payResult接口告诉我服务端
///支付宝支付
- (void)aliPay:(NSString *)helpId
    serviceFee:(NSString *)serviceFee
     creditFee:(NSString *)creditFee
         total:(NSString *)total
      netMoney:(NSString *)netMoney
      relMoney:(NSString *)relMoney
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

///微信支付
- (void)wxPay:(NSString *)helpId
   serviceFee:(NSString *)serviceFee
    creditFee:(NSString *)creditFee
        total:(NSString *)total
     netMoney:(NSString *)netMoney
     relMoney:(NSString *)relMoney
successedBlock:(SuccessedBlock)success
  failedBolck:(FailedBlock)failed;

///网币支付
- (void)netMoneyPay:(NSString *)helpId
         serviceFee:(NSString *)serviceFee
          creditFee:(NSString *)creditFee
              total:(NSString *)total
           netMoney:(NSString *)netMoney
           relMoney:(NSString *)relMoney
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

///返回支付结果
- (void)payResult:(NSString *)payId
       resultCode:(NSString *)resultCode
  responseContent:(NSString *)responseContent
   successedBlock:(SuccessedBlock)success
      failedBolck:(FailedBlock)failed;

- (void)recharge:(NSString *)payType
        relMoney:(NSString *)relMoney
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

#pragma mark - 我的
///查询我的网币余额
- (void)getCash:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

///我的各项详细等级
- (void)getMyGrades:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

///身份验证
- (void)authentication:(NSString *)userName
                 phone:(NSString *)phone
                picUrl:(NSString *)picUrl
                avatar:(NSString *)avatar
                 email:(NSString *)email
                weixin:(NSString *)weixin
                    qq:(NSString *)qq
       contactUserName:(NSString *)contactUserName
      contactUserPhone:(NSString *)contactUserPhone
     contactUserWeixin:(NSString *)contactUserWeixin
      contactUserName2:(NSString *)contactUserName2
     contactUserPhone2:(NSString *)contactUserPhone2
    contactUserWeixin2:(NSString *)contactUserWeixin2
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

///我要合作
- (void)join:(NSString *)userName
       phone:(NSString *)phone
     address:(NSString *)address
       email:(NSString *)email
      weixin:(NSString *)weixin
          qq:(NSString *)qq
successedBlock:(SuccessedBlock)success
 failedBolck:(FailedBlock)failed;

///取现申请
- (void)outCash:(NSString *)outMoney
        payType:(NSString *)payType
     payAccount:(NSString *)payAccount
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed;

///查询我的钱包交易记录
- (void)myRecord:(NSString *)recordId
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

///转赠
- (void)transferCash:(NSString *)account
               money:(NSString *)money
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)getUserInfo:(NSString *)account
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

@end

@interface HttpConnctionManager (v2)

- (void)addOrg:(NSString *)parentId
          name:(NSString *)name
       address:(NSString *)address
         email:(NSString *)email
          tel1:(NSString *)tel1
          tel2:(NSString *)tel2
          tel3:(NSString *)tel3
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

- (void)addPerson:(NSString *)jobNumber
          name:(NSString *)name
          duty:(NSString *)duty
         grade:(NSString *)grade
          image1:(NSString *)image1
          image2:(NSString *)image2
          image3:(NSString *)image3
            orgId:(NSString *)orgId
            gztd:(NSString *)gztd
            ywnl:(NSString *)ywnl
            qyjs:(NSString *)qyjs
            pxpz:(NSString *)pxpz
            ljzl:(NSString *)ljzl
            shgx:(NSString *)shgx
            zwpz:(NSString *)zwpz
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

- (void)addVote:(NSString *)title
          option:(NSString *)option
       image1:(NSString *)image1
         email:(NSString *)email
          image2:(NSString *)image2
          image3:(NSString *)image3
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed;

- (void)addVote:(NSString *)title
         option:(NSString *)option
         image1:(NSString *)image1
         image2:(NSString *)image2
         image3:(NSString *)image3
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed;


- (void)addComment:(NSString *)relationId
              type:(NSString *)type
           content:(NSString *)content
          imageUrl:(NSString *)imageUrl
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getCommentList:(NSString *)relationId
                  type:(NSString *)type
             commentId:(NSString *)commentId
              pageSize:(NSString *)pageSize
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)getOrgList:(NSString *)parentId
            orgId:(NSString *)orgId
          pageSize:(NSString *)pageSize
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getPersonDetail:(NSString *)userId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getPersonList:(NSString *)orgId
               userId:(NSString *)userId
          pageSize:(NSString *)pageSize
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

- (void)getVoteDetail:(NSString *)voteId
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)getVoteList:(NSString *)voteId
             pageSize:(NSString *)pageSize
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)scorePerson:(NSString *)userId
           option:(NSString *)option
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)scorePersonOption:(NSString *)voteId
             voteOptionId:(NSString *)voteOptionId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;

- (void)globalSearch:(NSString *)key
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed;


- (void)testMutipPraa:(ADTFindItem *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;
@end
