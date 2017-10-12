//
//  HttpConnctionManager.m
//  XXT_SH
//
//  Created by Points on 13-9-29.
//  Copyright (c) 2013年 Points. All rights reserved.
//
//


#import "HttpConnctionManager.h"
#import "ADTGropuInfo.h"
#import "OpenUDID.h"
@implementation HttpConnctionManager


- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:BJ_SERVER]];
    if(self)
    {
        //并发线程数
        AFHTTPRequestSerializer * serial = [[AFHTTPRequestSerializer alloc]init];
        [serial setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-type"];
        [serial setValue:@"utf-8" forHTTPHeaderField:@"Charset"];
        [self setRequestSerializer:serial];
        [serial release];

        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [self setResponseSerializer:responseSerializer];
    }
    return self;
}

SINGLETON_FOR_CLASS(HttpConnctionManager)

#define APP_URL    @"http://itunes.apple.com/lookup?id=677079618"

//检查版本更新
- (void)checkVersion:(SuccessedBlock)success failedBolck:(FailedBlock)failed
{
    self = [super initWithBaseURL:[NSURL URLWithString:BJ_SERVER]];
    [self startGetWith:APP_URL paragram:nil successedBlock:^(NSDictionary *retDic){
        success(retDic);
    }
           failedBolck:^(AFHTTPRequestOperation *operation, NSError *error){
           }];
}

#pragma mark - 封装过的网络请求接口

- (void)startGetWith:( NSString *)url
            paragram:(NSDictionary *)para
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    AFHTTPRequestOperation *  operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(operation, error);
         }
     }
     ];
    [operation start];
    [operation release];
}

//普通的post请求
- (void)startNormalPostWith:( NSString *)url
                   paragram:(NSDictionary *)para
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    self = [super initWithBaseURL:[NSURL URLWithString:BJ_SERVER]];
    [self POST:url
    parameters:para
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
                      if([[responseObject objectForKey:@"RESULT"]integerValue] == KEY_VALUE_TOKEN_OUTDATE)
                      {
                          [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_OUTDEATE_TOKEN];
                          [PubllicMaskViewHelper showTipViewWith:@"用户身份失效,自动重新登录" inSuperView:[UIApplication sharedApplication].keyWindow.rootViewController.view withDuration:1];
                          [[NSNotificationCenter defaultCenter]postNotificationName:KEY_IS_OUTDEATE_TOKEN object:nil];
                          return ;
                      }
         SpeLog(@"responseObject==%@",responseObject);
         success(responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SpeLog(@"error==%@",error);
         
         failed(operation,error);
     }
     ];
}

//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    self = [super initWithBaseURL:[NSURL URLWithString:BJ_SERVER]];
    [self POST:url
    parameters:para
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         if(uploadFileData)
         {
             [formData appendPartWithFileData:uploadFileData name:@"file" fileName:@"pic.jpg" mimeType:@"image/jpg"];
         }
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             success(responseObject);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}

//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  fileName:(NSString *)fileName
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    self = [super initWithBaseURL:[NSURL URLWithString:BJ_SERVER]];

    [self POST:url
    parameters:para
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         if(uploadFileData)
         {
             [formData appendPartWithFileData:uploadFileData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/jpg"];
         }
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             success(responseObject);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}

#pragma mark -  mime-type detection
/**
 根据路径自动获取上传文件需要的miniType,contentType
 */
- (void)transferWithFileName:(NSString **)fileName andContentType:(NSString **)contentType filePath:(NSString *)filePath
{
    if (!*fileName) {
        *fileName = [filePath lastPathComponent];
    }
    if (!*contentType) {
        *contentType = [HttpConnctionManager mimeTypeForFileAtPath:filePath];
    }
}

//  mime-type detection
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[[NSFileManager alloc] init] autorelease] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return NSMakeCollectable([(NSString *)MIMEType autorelease]);
}


- (NSString *)encodeToPercentEscapeString: (NSString *) input
{

    SpeLog(@"input=%@",input);
    NSString *outputStr = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}


//登陆
- (void)startLogin:(NSString *)name pwd:(NSString *)pwd successedBlock:(SuccessedBlock)success failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             
                             @"resultCode" : @"0",
                             @"password":pwd,
                             @"loginName":name
                             
                             };
    NSDictionary * dic =  @{
                            @"SIGN":@"",
                            @"TOKEN":@"",
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LoginServer.userLogin",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
  
    
}

//获取待办文件
- (void)getTodoFile:(NSString *)appType
                key:(NSString *)key
         actorClass:(NSString *)actorClass
         startIndex:(NSString *)start
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"userId":[LoginUserUtil userId],
                             @"resultCode" : @"0",
                             @"appType":appType,
                             @"subject":key== nil ? @"" : key,
                             @"actorClass" : actorClass,
                             @"startIndex": [NSNumber numberWithInteger:[start integerValue]],
                             @"recordCount":[NSNumber numberWithInteger:20],
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getItemTaskList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
 
}

//获取待办文件详情
- (void)getTodoFileInfoWith:(NSString *)msgId
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"userId":[LoginUserUtil userId],
                             @"resultCode" : @"0",
                             @"messageId" : msgId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getUserWorkItem",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
    
}

//获取待办文件
- (void)getDoneFile:(NSString *)actor
                key:(NSString *)key
         actorClass:(NSString *)actorClass
         startIndex:(NSString *)start
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"userId":[LoginUserUtil userId],
                             @"resultCode" : @"0",
                             @"subject":key== nil ? @"" : key,
                             @"startDate":@"",
                             @"endDate"  : @"",
                             @"actor" : actorClass,
                             @"startIndex": [NSNumber numberWithInteger:[start integerValue]],
                             @"recordCount":[NSNumber numberWithInteger:20],
                             @"status" : @"1"
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocumentServer.getDocList2",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
    
}

//获取邮件列表
- (void)getEmailWithType:(NSInteger)type
                     key:(NSString *)key
                  sender:(NSString *)senderId
              startIndex:(NSString *)start
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"userId":[LoginUserUtil userId],
                             @"resultCode" : @"0",
                             @"folder":[NSNumber numberWithInteger:type],
                             @"subject":key== nil ? @"" : key,
                             @"sender":senderId,
                             @"beginTime":@"",
                             @"endTime"  : @"",
                             @"startIndex": [NSNumber numberWithInteger:[start integerValue]],
                             @"recordCount":[NSNumber numberWithInteger:20],
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.getMailList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)GetEmialInfo:(NSString *)mailId
           isSaveBox:(BOOL)isSaveBox
              msgId:(NSString *)msgId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = nil;
     reqDic = isSaveBox ? @{
                             @"resultCode" : @"0",
                             @"mailId" : mailId,
                             @"msgId":msgId,
                             @"mailInfo" : [NSNumber numberWithBool:YES],
                             @"mailPerson" :[NSNumber numberWithBool:NO],
                             }
                :
                            @{
                              @"resultCode" : @"0",
                              @"mailId" : mailId,
                              @"mailInfo" : [NSNumber numberWithBool:YES],
                              @"mailPerson" :[NSNumber numberWithBool:NO],
                              };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.getMailInfo",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)GetRepostEmialInfo:(NSString *)mailId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =
                        @{
                          @"resultCode" : @"0",
                          @"mailId" : mailId,
                          };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.getMailTransmit",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


//获取联系人
- (void)getContact:(NSString *)key
             depId:(NSString *)depId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"userName" :key== nil ? @"" : key,
                             @"deptId":depId,
                             @"userId":[LoginUserUtil userId]
                          };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getnewUserList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

//获取联系人
- (void)getDeptUsers:(NSString *)depId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"groupId":depId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getGroupUserList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getDeptList:(NSString *)deptName
           parentId:(NSString *)parentId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"deptName" : deptName.length==0 ? @"" : deptName,
                             @"parentId":parentId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getDeptList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getDeptInfo:(NSString *)deptId
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"deptId" : deptId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getDeptInfo",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getDepInfo:(NSString *)deptId
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"deptId":deptId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getDeptInfo",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getDepatment:(NSString *)depId
            deptName:(NSString *)deptName
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"parentId":depId,
                             @"deptName":deptName
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getDeptList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getNewUserList:(NSString *)depId
              userName:(NSString *)userName
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"deptId":depId,
                             @"userName":userName,
                             @"userId":[LoginUserUtil userId]
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getnewUserList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getContactInfo:(NSString *)userId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"userId":userId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getAddressUserInfo",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getMessageWithTel:(NSString *)tel
                  WithKey:(NSString *)key
               startIndex:(NSNumber *)index
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed

{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"userId" : [LoginUserUtil userId],
                             @"dPhonenum":tel == nil ? @"" : tel,
                             @"mContent" : key == nil ? @"" : key,
                             @"startIndex" : index,
                             @"recordCount": [NSNumber numberWithInteger:10]
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"SmsServer.getSmsList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



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
               failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"userId" : [LoginUserUtil userId],
                             @"dPhonenum":tel == nil ? @"" : tel,
                             @"mcontent" : content == nil ? @"" : content,
                             @"sendTime" : sendTime == nil ? @"" : sendTime,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"SmsServer.saveSms",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark - 通知管理
- (void)getNoticeList:(NSString *)key
                index:(NSNumber *)index
                status:(NSString *)status
                type:(NSInteger)type
                successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = nil;
    NSString *code = nil;
    if(type == 0)
    {
        reqDic = @{
                                 @"resultCode" : @"0",
                                 @"userId" : [LoginUserUtil userId],
                                 @"title" : key == nil ? @"" : key,
                                 @"status": [NSNumber numberWithInteger:[status integerValue]],
                                 @"startIndex" : index,
                                 @"recordCount": [NSNumber numberWithInteger:20],
                                 @"unitId":[LoginUserUtil orgId],
                                 };
        
        code = @"Notice2Server.getReceiveList";
    }
    else if (type == 2)
    {
        reqDic = @{
                   @"resultCode" : @"0",
                   @"userId" : [LoginUserUtil userId],
                   @"title" : key == nil ? @"" : key,
                   @"status": [NSNumber numberWithInteger:[status integerValue]],
                   @"startIndex" : index,
                   @"recordCount": [NSNumber numberWithInteger:20],
                   @"unitId":[LoginUserUtil orgId],
                   };
        code = @"Notice2Server.getReceiveList";
    }
    else
    {
        reqDic = @{
                   @"resultCode" : @"0",
                   @"userId" : [LoginUserUtil userId],
                   @"title" : key == nil ? @"" : key,
                   @"startIndex" : index,
                   @"recordCount": [NSNumber numberWithInteger:20],
                   @"unitId":[LoginUserUtil orgId],
                  };
        code = @"Notice2Server.getSendList";
    }
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": code,
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getNoticeInfo:(NSString *)noticeId
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"noticeId" : noticeId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Notice2Server.getNotice",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getNoticeDetail:(NSString *)detailId
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"detailId" : detailId,
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticeDetailServer.getNoticeDetail",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getNoticeUserList:(NSString *)detailId
                 noticeId:(NSString *)noticeId
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"detailId" : detailId,
                             @"noticeId" : noticeId,
                             @"recordCount":[NSNumber numberWithInteger:100],
                             @"startIndex":[NSNumber numberWithInteger:0],
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticePersonServer.getNoticePersonList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



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
         failedBolck:(FailedBlock)failed
{
    NSString *noticeTypeName = nil;
    NSString *noticeType = nil;
    if([type isEqualToString:@"会议通知"])
    {
        noticeTypeName = @"会议通知";
        noticeType = @"1";
    }
    else if ([type isEqualToString:@"培训通知"])
    {
        noticeTypeName = @"培训通知";
        noticeType = @"2";
    }
    else if ([type isEqualToString:@"活动通知"])
    {
        noticeTypeName = @"活动通知";
        noticeType = @"3";
    }
    else
    {
        noticeTypeName = @"其他通知";
        noticeType = @"4";
    }
    
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"accessory" :fileArr,
                             @"content":desc,
                             @"endDate" : [LocalTimeUtil getTimestamp1:endTime],
                             @"title":title,
                             @"isFeedback" : isNeedFeedBack ? [NSNumber numberWithInteger:1]: [NSNumber numberWithInteger:0],
//                             @"isFeedfile" : isFeedfile ? [NSNumber numberWithInteger:1]: [NSNumber numberWithInteger:0],
                             @"isperson" :  [NSNumber numberWithBool:NO],
                             @"isunit" :  [NSNumber numberWithBool:NO],
                             @"noticeTypeName" : noticeTypeName,
                             @"noticeType":noticeType,
                             @"place" : address,
                             @"receiveUnitIds" : receiveUnitIds,
                             @"receiveUnitNames" : receiveUnitNames,
                             @"sendDeptId" : [LoginUserUtil deptId],
                             @"sendStatus" :[NSNumber numberWithInteger:1],
                             @"sendUnitId" : [LoginUserUtil orgId],
                             @"sendUserId" :[LoginUserUtil userId],
                             @"sendUserName":[LoginUserUtil userName],
                             @"startDate":[LocalTimeUtil getTimestamp1:startTime],
                             @"status":[NSNumber numberWithInteger:0],
                             @"sendStatus":[NSNumber numberWithInteger:1],
                             @"noticeId":noticeId
                             };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Notice2Server.saveNotice",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getUnits:(NSString *)parentId
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"deptName" : @"",
                             @"parentId" :parentId,
                             };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getUnitList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)saveInfoPersons:(NSString *)recUserIds
               noticeId:(NSString *)noticeId
               detailId:(NSString *)detailId
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"noticeId" : noticeId,
                             @"detailId" :detailId,
                             @"userIdList":recUserIds,
                             };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticePersonServer.savePerson",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)feedbackNotice:(NSString *)answer
              detailId:(NSString *)detailId
            isfeedback:(BOOL)isfeedback
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"answer" : answer,
                             @"userId":[LoginUserUtil userId],
                             @"isfeedback":[NSNumber numberWithBool:isfeedback],
                             @"detailId" :detailId,
                             };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticeDetailServer.feedbackNoticeDetail",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)confirmReceivedNotice:(NSString *)detailId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"userId":[LoginUserUtil userId],
                             @"detailId" :detailId,
                             };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticeDetailServer.readNoticeDetail",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark -

- (void)getAbsenceList:(NSString *)key
                 index:(NSNumber *)index
                statu:(BOOL)statu
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"userId" : [LoginUserUtil userId],
                             @"subject" : key == nil ? @"" : key,
                             @"todoMsgStatus":statu ? @"0" : @"1",
                             @"startIndex" : index,
                             @"pagecount": [NSNumber numberWithInteger:20]
                             };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.getAbsenceList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)disagree:(NSDictionary *)info
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"absenceDate" : [LocalTimeUtil getCurrentDay],
                             @"absenceEndDate" : [info stringWithFilted:@"6"],
                             @"absenceRemark" : [info stringWithFilted:@"4"],
                             @"absenceStartDate" :[info stringWithFilted:@"5"],
                             @"absenceType":[info stringWithFilted:@"3"],
                             @"deptId":[LoginUserUtil deptId],
                             @"deptName" : [LoginUserUtil deptName],
                             @"id" : [info stringWithFilted:@"id"],
                             @"orgId" : @"0",
                             @"orgName" : @"",
                             @"status" : @(-1),
                             @"subject":[info stringWithFilted:@"2"],
                             @"userId" : [LoginUserUtil userId],
                             @"userName" : [LoginUserUtil userName]
                             };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.updateAbsenceStauts",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)agreeAbsence:(NSDictionary *)info
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"absenceDate" : [LocalTimeUtil getCurrentDay],
                             @"absenceEndDate" : [info stringWithFilted:@"6"],
                             @"absenceRemark" : [info stringWithFilted:@"4"],
                             @"absenceStartDate" :[info stringWithFilted:@"5"],
                             @"absenceType":[info stringWithFilted:@"3"],
                             @"deptId":[LoginUserUtil deptId],
                             @"deptName" : [LoginUserUtil deptName],
                             @"id" : [info stringWithFilted:@"id"],
                             @"orgId" : @"0",
                             @"orgName" : @"",
                             @"status" : @(1),
                             @"subject":[info stringWithFilted:@"2"],
                             @"userId" : [LoginUserUtil userId],
                             @"userName" : [LoginUserUtil userName]
                             };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.updateAbsenceStauts",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)saveAbsence:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"absenceDate" : [LocalTimeUtil getCurrentDay],
                             @"absenceEndDate" : [info stringWithFilted:@"6"],
                             @"absenceRemark" : [info stringWithFilted:@"4"],
                             @"absenceStartDate" :[info stringWithFilted:@"5"],
                             @"absenceType":[info stringWithFilted:@"3"],
                             @"deptId":[LoginUserUtil deptId],
                             @"deptName" : [LoginUserUtil deptName],
                             @"id" : [info stringWithFilted:@"id"],
                             @"orgId" : @"0",
                             @"orgName" : @"",
                             @"status" : @(0),
                             @"subject":[info stringWithFilted:@"2"],
                             @"userId" : [LoginUserUtil userId],
                             @"userName" : [LoginUserUtil userName]
                             };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.postSaveAbsence",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)postAbsence:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    
    NSDictionary *reqDic = @{
                             @"resultCode" : @"0",
                             @"absenceDate" : [LocalTimeUtil getCurrentDay],
                             @"absenceEndDate" : [info stringWithFilted:@"6"],
                             @"absenceRemark" : [info stringWithFilted:@"4"],
                             @"absenceStartDate" :[info stringWithFilted:@"5"],
                             @"absenceType":[info stringWithFilted:@"3"],
                             @"deptId":[LoginUserUtil deptId],
                             @"deptName" : [LoginUserUtil deptName],
                             @"id" : [info stringWithFilted:@"id"],
                             @"orgId" : @"0",
                             @"orgName" : @"",
                             @"status" : @(2),
                             @"subject":[info stringWithFilted:@"2"],
                             @"userId" : [LoginUserUtil userId],
                             @"userName" : [LoginUserUtil userName],
                             @"sendUser": [LoginUserUtil userName],
                             @"receiveUserId":[info stringWithFilted:@"receiveUserId"],
                             @"receiveUserName":[info stringWithFilted:@"receiveUserName"],
                             };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.postCommitAbsence",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)uploadFileWithPath:(NSData *)fileData
                    params:(NSDictionary *)params
              successBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    
    [[NSUserDefaults standardUserDefaults]setObject:params[@"fileid"] forKey:KEY_UPLOADING_FILE];
    
    NSString *filename = nil;
    NSString *contentType = nil;
    [self transferWithFileName:&filename andContentType:&contentType filePath:params[@"filebody"]];

    [self startMulitDataPost:FILE_SERVER fileName:params[@"filename"] postFile:fileData paragram:params successedBlock:success failedBolck:failed];
}

- (void)uploadPDFFileWithPath:(NSString *)filePath
                 withFileData:(NSData *)data
                       params:(NSDictionary *)params
                 successBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    
    [self POST:FILE_SERVER
    parameters:params
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         NSString *filename = nil;
         NSString *contentType = nil;
         [self transferWithFileName:&filename andContentType:&contentType filePath:filePath];
         if(filename&&contentType)
         {
             [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:contentType];
         }
         else
         {
             SpeLog(@"获取contentType失败");
         }
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}

- (void)downloadFileWithUrl:(NSString *)url
                   fileName:(NSString *)fileName
                     params:(NSDictionary *)params
               successBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSString *destPath = [LocalImageHelper getStoredFilePath:YES];
    if([fileName rangeOfString:@"."].length >0)
    {
        destPath = [destPath stringByAppendingFormat:@"/%@", fileName];
    }
    else
    {
        destPath = [destPath stringByAppendingFormat:@"/%@.jpg", fileName];
    }
    
//    if([[NSFileManager defaultManager]fileExistsAtPath:destPath])
//    {
//        NSData *data = [NSData dataWithContentsOfFile:destPath];
//        if(data.length == 0)
//        {
//            failed(nil, nil);
//        }
//        else
//        {
//            success(@{
//                      @"type":@(ENUM_MSG_TYPE_PIC),
//                      @"path": destPath
//                      });
//        }
//    
//    }
//    else
//    {
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:FILE_SERVER parameters:params];
        
        NSLog(@"request:%@",request);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data = [NSData dataWithContentsOfFile:destPath];
            if(data.length == 0)
            {
                failed(nil, nil);
            }
            else
            {
                success(@{
                          @"type":@(ENUM_MSG_TYPE_PIC),
                          @"path": destPath
                          });
            }
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failed)
            {
                failed(operation, error);
            }
        }];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            NSLog(@"%@, %@", @(totalBytesRead), @(totalBytesExpectedToRead));
        }];
        
        NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:destPath append:NO];
        [operation setOutputStream:output];
        [operation start];
//    }
}


- (void)downloadQPFileWithUrl:(NSString *)url
                     params:(NSDictionary *)params
               successBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSString *destPath = [LocalImageHelper getStoredFilePath:YES];
    NSString *fileName = [LocalImageHelper getfileNameFromCurrentTime];
    
    destPath = [destPath stringByAppendingFormat:@"/%@%@", fileName,url];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:FILE_SERVER parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            success(@{
                      @"type":@(ENUM_MSG_TYPE_PIC),
                      @"path": destPath
                      });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed)
        {
            failed(operation, error);
        }
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%@, %@", @(totalBytesRead), @(totalBytesExpectedToRead));
    }];
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:destPath append:NO];
    [operation setOutputStream:output];
    [operation start];
}


- (void)downloadFileWithUrl:(NSString *)url
                     params:(NSDictionary *)params
               successBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSString *destPath = [LocalImageHelper getStoredFilePath:YES];
    NSString *fileName = [LocalImageHelper getfileNameFromCurrentTime];
    if([url rangeOfString:@"."].length >0)
    {
       destPath = [destPath stringByAppendingFormat:@"/%@",url];
    }
    else
    {
        destPath = [destPath stringByAppendingFormat:@"/%@.jpg", fileName];
    }
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:FILE_SERVER parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            success(@{
                      @"type":@(ENUM_MSG_TYPE_PIC),
                      @"path": destPath
                      });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed)
        {
            failed(operation, error);
        }
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%@, %@", @(totalBytesRead), @(totalBytesExpectedToRead));
    }];
    
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:destPath append:NO];
    [operation setOutputStream:output];
    [operation start];
}

- (void)dealwithEmail:(int)type
            withInfo:(NSDictionary *)info
        withReceiver:(NSArray *)arrReceive
        withReceiverBTW:(NSArray *)arrReceiveBTW
        withReceiverSecret:(NSArray *)arrReceiveSecret
             withUUid:(NSString *)uuid
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    
    NSMutableString *arrID1 = [NSMutableString string];
    NSMutableString *arrName1 = [NSMutableString string];
    if(arrReceive.count == 0)
    {
        [arrID1 appendString:@""];
        [arrName1 appendString:@""];
    }
    for(ADTContacterInfo  *info in arrReceive)
    {
        [arrID1 appendFormat:@"%@,",info.m_strUserID];
        [arrName1 appendFormat:@"%@,",info.m_strUserName];
    }
    
    NSMutableString *arrID2 = [NSMutableString string];
    NSMutableString *arrName2 = [NSMutableString string];
    if(arrReceiveBTW.count == 0)
    {
        [arrID2 appendString:@""];
        [arrName2 appendString:@""];
    }
    for(ADTContacterInfo *info in arrReceiveBTW)
    {
        [arrID2 appendFormat:@"%@,",info.m_strUserID];
        [arrName2 appendFormat:@"%@,",info.m_strUserName];
    }
    
    NSMutableString *arrID3 = [NSMutableString string];
    NSMutableString *arrName3 = [NSMutableString string];
    if(arrReceiveSecret.count == 0)
    {
        [arrID3 appendString:@""];
        [arrName3 appendString:@""];
    }
    for(ADTContacterInfo *info in arrReceiveSecret)
    {
        [arrID3 appendFormat:@"%@,",info.m_strUserID];
        [arrName3 appendFormat:@"%@,",info.m_strUserName];
    }
    
    if(arrName1.length > 0)
    {
        arrName1 = [NSMutableString stringWithString:[arrName1 substringToIndex:arrName1.length-1]];
    }
    if(arrID1.length > 0)
    {
        arrID1 = [NSMutableString stringWithString:[arrID1 substringToIndex:arrID1.length-1]];
    }
    
    if(arrName2.length > 0)
    {
        arrName2 = [NSMutableString stringWithString:[arrName2 substringToIndex:arrName2.length-1]];
    }
    
    if(arrID2.length > 0)
    {
        arrID2 = [NSMutableString stringWithString:[arrID2 substringToIndex:arrID2.length-1]];
    }
    
    if(arrName3.length > 0)
    {
        arrName3 = [NSMutableString stringWithString:[arrName3 substringToIndex:arrName3.length-1]];
    }
    if(arrID3.length > 0)
    {
        arrID3 = [NSMutableString stringWithString:[arrID3 substringToIndex:arrID3.length-1]];
    }
    
    id accrssory = [info stringWithFilted:@"accessory"];
    if([accrssory isKindOfClass:[NSString class]])
    {
       if([[info stringWithFilted:@"accessory"]isEqualToString:@""])
       {
           accrssory = @[];
       }
    }

    
    NSDictionary *reqDic = @{
                             @"resultCode" :  @"0",
                             @"mailId" : info[@"mailId"] == nil ?uuid : [info stringWithFilted:@"mailId"],
                             @"subject" : [info stringWithFilted:@"subject"],
                             @"content" : [info stringWithFilted:@"content"],
                             @"mainIds" :arrID1,
                             @"mainNames":arrName1,
                             @"copyIds":arrID2,
                             @"copyNames" : arrName2,
                             @"blindIds" : arrID3,
                             @"blindNames" : arrName3,
                             @"sendDate" : [LocalTimeUtil getCurrentTime],
                             @"senderId" : [LoginUserUtil userId],
                             @"senderName":[LoginUserUtil userName],
                             @"important" : @(0),
                             @"accessory" : accrssory,
                             @"readStatus": @(0),
                             @"receivers":@[],
                             @"mailType" : @(0),
                             @"hasMailFile" : [NSNumber numberWithBool:NO],
                             @"transmitStatus":@(0),
                             @"backStatus" : @(0),
                             @"mailStatus" : @(0)
                             };
    NSString *code = nil;
    if(type == 0)
    {
        code = @"MailServer.sendMail";
    }
    else if (type == 1)
    {
        code = @"MailServer.saveMail";
    }
    else
    {
        code = @"MailServer.sendMail";
    }
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": code,
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



- (void)deleteEmail:(NSDictionary *)reqDic
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.delMail",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)deleteFile:(NSString *)fileId
           docType:(int)docType
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = @{
                             @"fileid":fileId,
                             @"userid":[LoginUserUtil userId],
                             @"doctype":@(docType)
                             };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"FileServer.fileDel",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getTodoInfo:(NSString *)msgId
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                          @"resultCode" : @"0",
                          @"messageId" : msgId,
                          @"userId" : [LoginUserUtil userId]
                          };
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getUserWorkItem",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)saveTodoFile:(NSString *)option
WithInfo:(ADTGovermentFileInfo *)info
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userid" : [LoginUserUtil userId],
                              @"flowmodelid" : info.m_strFlowModelId,
                              @"messageid" : info.m_strMessageId,
                              @"important" : @(0),
                              @"subject" : info.m_strSubject,
                              @"form":info.m_arrOriginalForm ,
                              @"opinion" : option == nil ? @"" : option
                              };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.saveflow",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getTodoContact:(NSDictionary *)reqDic
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getFlowUser",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)giveUpTodo:(NSDictionary *)reqDic
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.sendbackflow",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)commitTodo:(NSDictionary *)reqDic
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.sendflow",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



- (void)getGovermentFileInfo:(NSString *)documentId
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"flowId" :documentId,
                              @"userId" : [LoginUserUtil userId]
                              };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getItemDetail",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)updateNotice:(NSString *)noticeId
successedBlock:(SuccessedBlock)success
failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"isRead":@"1",
                              @"id" :noticeId,
                              @"userId" : [LoginUserUtil userId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];

    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticeServer.updateReceive",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)deleAbense:(NSString *)abenseId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"id" :abenseId,
                              @"userId" : [LoginUserUtil userId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AbsenceServer.delAbsence",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)updateEmailStateToReaded:(NSString *)msgId
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"msgId" :msgId,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.updateMailRead",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

//检查更新
- (void)gettheLastestVersion:(SuccessedBlock)success failedBolck:(FailedBlock)failed
{
    NSString *url = @"http://melaka.fir.im/api/v2/app/55591f138e82369a570010bf/versions?token=WKQhCC19JIygnoM2k3H4dojAWYx3I4x5jo1iO7Qm";
    [self startGetWith:url paragram:nil successedBlock:success failedBolck:failed];
}

- (void)getTipNum:(SuccessedBlock)success failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MailServer.updateMailRead",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

#pragma mark -  日程

- (void)getScheduleList:(NSInteger)startIndex
              startTime:(NSString *)startTime
                endTime:(NSString *)endTime
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex":@(startIndex),
                              @"recordCount":@(10),
                              @"startTime":startTime == nil ?[LocalTimeUtil getCurrentDay] : startTime,
                              @"endTime":endTime == nil ?[LocalTimeUtil getCurrentDay] : endTime,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ScheServer.getScheListByDate",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)saveSchdule:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"content":info[@"content"],
                              @"endTime":info[@"endTime"],
                              @"place":info[@"place"],
                              @"remindTime":info[@"remindTime"],
                              @"scheIds":@[],
                              @"sms":info[@"sms"],
                              @"startTime":info[@"startTime"],
                              @"subject":info[@"subject"],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ScheServer.saveSche",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)modifySchdule:(NSDictionary *)info
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"scheId":info[@"scheId"],
                              @"content":info[@"content"],
                              @"endTime":info[@"endTime"],
                              @"place":info[@"place"],
                              @"remindTime":info[@"remindTime"],
                              @"scheIds":@[],
                              @"sms":info[@"sms"],
                              @"startTime":info[@"startTime"],
                              @"subject":info[@"subject"],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ScheServer.saveSche",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)deleteSchdule:(NSDictionary *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"scheId":info[@"scheId"],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ScheServer.delSche",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getNum:(NSInteger)type
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic = type == 1 ?
                            @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              }
                            :
                            @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"actorClass":@"0",
                              @"appType": @"0",
                              @"subject": @""
                              }
                        ;
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": type == 1 ?   @"MailServer.getMailTaskCount" : @"ItemServer.getItemTaskCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getGroupList:(NSString *)depId
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"depId":depId == nil ? @"" : depId
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"AddressbookImpl.getGroupList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)updateMessageToReaded:(NSString *)msgId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"userId" :  [LoginUserUtil userId],
                              @"isRead":@"1",
                              @"id":msgId
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"NoticeServer.updateReceive",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

#pragma mark - 建邺oa新增接口


#pragma mark - 会议管理
- (void)getMeetingManagerList:(NSInteger)index
                      subject:(NSString *)subject
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"recordCount" : [NSNumber numberWithInt:10],
                              @"userId" :  [LoginUserUtil userId],
                              @"deptId":[LoginUserUtil deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"startIndex":[NSNumber numberWithInteger:index],
                              @"meetingName":subject.length == 0 ? @"":subject
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.getAuditMeetingRelationList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getMeetingInfo:(NSString *)meetingId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"relationId" : meetingId,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.getMeetingRelationBean",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


///会议审核
- (void)dealMeeting:(NSString *)roomId
            address:(NSString *)address
         relationId:(NSString *)relationId
          auditType:(NSString *)auditType
     successedBlock:(SuccessedBlock)success
        failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"relationId" : relationId,
                              @"roomAddress" : address,
                              @"roomId" : roomId,
                              @"unitId" : [LoginUserUtil orgId],
                              @"userId" : [LoginUserUtil userId],
                              @"auditType" : auditType,
                              @"deptId":[LoginUserUtil deptId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.auditApplyRoom",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

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
                           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"applyDate":applyDate,
                              @"applyStatus":applyStatus,
                              @"auditUserId" : auditUserId,
                              @"cancelStatus":cancelStatus,
                              @"cancelUserId":cancelUserId,
                              @"contacts":contacts,
                              @"contactsTel":contactsTel,
                              @"createDate":createDate,
                              @"createDeptId":createDeptId,
                              @"createDeptName":createDeptName,
                              @"createOrgId":createOrgId,
                              @"createOrgName":createOrgName,
                              @"createUserId":createUserId,
                              @"createUserName":createUserName,
                              @"deptId":[LoginUserUtil deptId],
                              @"hostUnit":hostUnit,
                              @"isConfirm":isConfirm,
                              @"isLarge":isLarge,
                              @"isOpen":isOpen,
                              @"leaders":leaders,
                              @"meetingDateEnd":meetingDateEnd,
                              @"meetingDateStart":meetingDateStart,
                              @"meetingDemand":meetingDemand,
                              @"meetingName":meetingName,
                              @"noticeStatus":noticeStatus,
                              @"peolpeNum":peolpeNum,
                              @"resultCode":@"0",
                              @"roomAddress":roomAddress,
                              @"roomId":roomId,
                              @"specialDemand":specialDemand,
                              @"tableSetType":tableSetType,
                              @"unitId":[LoginUserUtil orgId],
                              @"useStatus":useStatus,
                              @"userId":[LoginUserUtil userId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.addApplyMeetingRoom",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getMeetingRooms:(NSString *)startTime
                endTime:(NSString *)endTime
             peopleNum1:(NSString *)peopleNum1
             peopleNum2:(NSString *)peopleNum2
           facilityInfo:(NSString *)facilityInfo
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSMutableDictionary *reqDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"facilityInfo":facilityInfo,
                                                                                  @"deptId" : [LoginUserUtil  deptId],
                                                                                  @"unitId":[LoginUserUtil orgId],
                                                                                  @"recordCount":[NSNumber numberWithInteger:100],
                                                                                  @"userId":[LoginUserUtil userId],
                                                                                  @"date2":endTime,
                                                                                  @"date1":startTime,
                                                                                  @"startIndex":[NSNumber numberWithInteger:0]
                                                                                  }];
    if(peopleNum1.length > 0)
    {
        [reqDic setObject:[NSNumber numberWithInteger:[peopleNum1 integerValue]] forKey:@"peopleNum1"];
    }
    
    if(peopleNum2.length > 0)
    {
        [reqDic setObject:[NSNumber numberWithInteger:[peopleNum2 integerValue]] forKey:@"peopleNum2"];
    }
    
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.getSelectMeetingRoomList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark - 督查督办

- (void)getObserverList:(NSInteger)index
                subject:(NSString *)subject
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"recordCount" : [NSNumber numberWithInteger:10],
                              @"userId" :  [LoginUserUtil userId],
                              @"subject":subject.length == 0 ?  @"" : subject,
                              @"unitId":[LoginUserUtil orgId],
                              @"startIndex":[NSNumber numberWithInteger:index],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocManagerServer.getDocManagerList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getObserverInfo:(NSString *)_id
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                               @"id" :_id,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocManagerServer.getDocManager",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

#pragma mark - 获取电子期刊列表

- (void)getManagersMenuList:(NSString *)parentId
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"parentId": parentId,
                              @"type":@"view",
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:0],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": [NSNumber numberWithInteger:0]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DataBankServer.getViewTypeList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getEManagerList:(NSInteger)index
                subject:(NSString *)subject
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"type":@"view",
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:100],
                              @"userId" :  [LoginUserUtil userId],
                              @"subject":subject,
                              @"pageNo":[NSNumber numberWithInteger:index],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"PeriodicalServer.getPeriodicalList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark - 资源中心

- (void)getResourceCenterMenuList:(NSString *)parentId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"parentId":parentId.length ==0? @"1" : parentId,
                              @"type":@"view",
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:0],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": [NSNumber numberWithInteger:0]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DataBankServer.getViewTypeList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



- (void)getResourceCenterList:(NSString *)parentId
                     subjecet:(NSString *)subjecet
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"keywords":subjecet.length == 0? @"" : subjecet,
                              @"typeId":parentId.length == 0 ? @"" : parentId,
                              @"type":@"view",
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:0],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": [NSNumber numberWithInteger:0]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DataBankServer.getDataBankList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getResourceCenterFileInfo:(NSString *)dataId
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"dataId":dataId,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DataBankServer.getDataBank",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getResourceCenterTopicList:(NSString *)dataId
                    successedBlock:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"dataId":dataId,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DataBankServer.DataBankServer.getTopicList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark - 领导日程

- (void)getLeaderWeekScheduleList:(NSInteger)index
                       agentDate1:(NSString *)agentDate1
                       agentDate2:(NSString *)agentDate2
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:0],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": [NSNumber numberWithInteger:index],
                              @"agentDate1":agentDate1,
                              @"agentDate2":agentDate2
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LeaderServer.getWeekScheduleList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getLeaderDayScheduleList:(NSInteger)index
                      agentDate1:(NSString *)agentDate1
                      agentDate2:(NSString *)agentDate2
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:0],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": [NSNumber numberWithInteger:index],
                              @"agentDate1":agentDate1,
                              @"agentDate2":agentDate2
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LeaderServer.getLeaderScheduleList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getLeaderWeekScheduleInfo:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"ScheduleId":_id,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LeaderServer.getWeekSchedule",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getLeaderDayScheduleInfo:(NSString *)_id
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"scheduleId":_id,
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LeaderServer.getLeaderSchedule",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


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
              failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"address":address,
                              @"agentDate":agentDate,
                              @"content":content,
                              @"endTime":endTime,
                              @"hostUnitName":hostUnitName,
                              @"leaderId":[NSNumber numberWithLong:[leaderId integerValue]],
                              @"leaderName":leaderName,
                              @"participant":participant,
                              @"startTime":startTime,
                              @"deptId":[LoginUserUtil  deptId],
                              @"unitId":[LoginUserUtil orgId],
                              @"resultCode":@"0",
                              @"whichWeek":[NSNumber numberWithLong:[whichWeek integerValue]-1],
                              @"whichYear":[NSNumber numberWithLong:[whichYear integerValue]],
                              @"scheduleId":scheduleId,
                              @"userId":[LoginUserUtil userId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"LeaderServer.saveLeaderSchedule",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

#pragma mark - 单位收文

- (void)getDepartmentReceiveArticles:(NSString *)index
                           stauts:(BOOL)isUnsigned
                             key:(NSString *)key
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"subject" : key == nil ? @"" : key,
                              @"status":isUnsigned?@(0) : @(1),
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:10],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": @(index.integerValue)
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocumentSignServer.getDocumentSignList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getDepartmentReceiveArticleInfo:(NSString *)documentId
                              receiveId:(NSString *)receiveId
                      successedBlock:(SuccessedBlock)success
                         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"documentId":documentId,
                              @"receiveId":receiveId,
                              @"unitId":[LoginUserUtil orgId],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocumentSignServer.getDocument",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)updateDepartmentReceiveArticleInfo:(NSString *)documentId
                                     appId:(NSString *)appId
                            successedBlock:(SuccessedBlock)success
                               failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"appId":appId,
                              @"documentId":documentId,
                              @"userId" :  [LoginUserUtil userId],
                              @"unitId":[LoginUserUtil orgId],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocumentSignServer.updateSignStatus",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}



/**
 获取公文未读数

 @param success
 @param failed
 */
- (void)getNumDocumentUnreadNum:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"subject":@"",
                              @"userId" :  [LoginUserUtil userId],
                              @"actorClass":@"0",
                              @"appType":@"10,20"
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"ItemServer.getItemTaskCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


/**
 获取故障报修未读数
 
 @param success
 @param failed
 */
- (void)getNumFaultRepairUnreadNum:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"userId" :  [LoginUserUtil userId],
                              @"unitId":[LoginUserUtil orgId],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"FaultRepairServer.getFaultRepairCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

/**
 获取通知管理未读数
 
 @param success
 @param failed
 */
- (void)getNumNoticeUnreadNum:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"userId" :  [LoginUserUtil userId],
                              @"unitId":[LoginUserUtil orgId],
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Notice2Server.getReceiveCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

/**
 获取会议管理未读数
 
 @param success
 @param failed
 */
- (void)getNumMeetingUnreadNum:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                                @"userId" :  [LoginUserUtil userId],
                                @"unitId":[LoginUserUtil orgId],
                                @"deptId":[LoginUserUtil deptId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"MeetingServer.getAuditCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


/**
 获取督办数字未读数
 
 @param success
 @param failed
 */
- (void)getNumDocManagerUnreadNum:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"userId" :[LoginUserUtil userId],
                              @"unitId":[LoginUserUtil orgId],
                              @"deptId":[LoginUserUtil deptId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocManagerServer.getDocManagerCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

/**
 获取单位收文未读数
 
 @param success
 @param failed
 */
- (void)getNumDocumentSignUnreadNum:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"status":@(0),
                              @"userId" :[LoginUserUtil userId],
                              @"unitId":[LoginUserUtil orgId],
                              @"deptId":[LoginUserUtil deptId]
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"DocumentSignServer.gettoDoReciveCount",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


#pragma mark - 故障维修

- (void)getFaultRepairList:(NSInteger)index
                    appType:(NSString *)appType
                       key:(NSString *)key
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"subject" : key == nil ? @"" : key,
                              @"appType":appType,
                              @"status":@"",
                              @"unitId":[LoginUserUtil orgId],
                              @"recordCount" : [NSNumber numberWithInteger:10],
                              @"userId" :  [LoginUserUtil userId],
                              @"startIndex": @(index)
                              };
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"FaultRepairServer.getFaultRepairList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)getFaultRepairInfo:(NSString *)messageId
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"messageId" :messageId,
                              @"userId" : [LoginUserUtil userId]
                              };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Item2Server.getUserWorkItem",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getFaultRepairItemSetting:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"unitId":[LoginUserUtil orgId],
                              @"userId" : [LoginUserUtil userId]
                              };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"FaultRepairServer.getItemAppList",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getFaultRepairFlowEntrySetting:(NSString *)appId
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"resultCode" : @"0",
                              @"appId":appId,
                              @"userId" : [LoginUserUtil userId]
                              };
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Item2Server.getFlowEntry",
                            @"DTYPE": @"0",
                            @"DATA" :[reqDic JSONString]
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)saveFaultRepair:(NSString *)option
            WithMessageId:(NSString *)messageId
            WithInnerId:(NSString *)innerId
            WithFlowmodelid:(NSString *)flowmodelid
              withForms:(NSArray *)arrForms
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"innerId":innerId,
                              @"opinion" : option == nil ? @"" : option,
                              @"resultCode" : @"0",
                              @"receiverslist":@[],
                              @"receivers1":@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Receivers></Receivers>",
                              @"receivers":@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Receivers></Receivers>",
                              @"receivers2":@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Receivers></Receivers>",
                              @"receivers0":@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Receivers></Receivers>",
                              @"important" : @(0),
                              @"flowmodelid" : [NSString stringWithFormat:@"%lld",flowmodelid.longLongValue],
                              @"userid" : [LoginUserUtil userId],
                              @"form":arrForms,
                              @"accessory":@[],
                              @"messageid":messageId,
                              @"subject" : @"",
                              };
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Item2Server.saveFlow",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)commitFaultRepair:(NSDictionary *)reqDic
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    
    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];
    
    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"Item2Server.sendFlow",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}


- (void)savePhraseToServerList:(NSString *)content
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"phrase":content,
                              @"resultCode":@(0),
                              @"userId" : [LoginUserUtil userId],
                              };

    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];


    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"PhraseServer.savePhrase",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

- (void)getTodoPhraseServerList:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"userId" : [LoginUserUtil userId],
                              };

    SBJson4Writer *write = [SBJson4Writer new];
    NSString *retString = [write stringWithObject:reqDic];


    NSDictionary * dic =  @{
                            @"TOKEN":[LoginUserUtil accessToken],
                            @"KEY":  @"jsddkj",
                            @"CODE": @"PhraseServer.getPhraseList",
                            @"DTYPE": @"0",
                            @"DATA" :retString
                            };
    [self startNormalPostWith:nil paragram:@{@"DATA":[self encodeToPercentEscapeString:[dic JSONString]]} successedBlock:success failedBolck:failed];
}

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
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"loginName":loginName,
                              @"loginPass":loginPass,
                              @"userName" :userName,
                              @"type":type,
                              @"phone":phone==nil ? @"" :phone,
                              @"email":email==nil?@"":email,
                              @"weixin":weixin==nil?@"":weixin,
                              @"qq":qq==nil?@"":qq
                              };

    [self startNormalPostWith:@"reg" paragram:reqDic successedBlock:success failedBolck:failed];
}

- (void)startLogin:(NSString *)loginName
            loginPass:(NSString *)loginPass
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"loginName":loginName,
                              @"loginPass":loginPass,
                              };

    [self startNormalPostWith:@"login" paragram:reqDic successedBlock:success failedBolck:failed];
}


#pragma mark - 发现
- (void)findDeleteOne:(NSString *)_id
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":_id,
                              };

    [self startNormalPostWith:@"help/delete" paragram:reqDic successedBlock:success failedBolck:failed];
}

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
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"type": type == nil ? @"":type,
                              @"userType": @"",// userType == nil ? @"":userType,
                              @"status":status == nil ? @"":status,
                              @"provice":provice == nil ? @"":provice,
                              @"county":county== nil ? @"":county,
                              @"startTime":startTime== nil ? @"":startTime,
                              @"endTime":endTime== nil ? @"":endTime,
                              @"helpId":helpId== nil ? @"":helpId,
                              @"pageSize":pageSize== nil ? @"":pageSize,
                              @"city":city== nil ? @"":city,

                              };

    [self startNormalPostWith:@"help/getHelpList" paragram:reqDic successedBlock:success failedBolck:failed];
}

///POST 查询咨询消息组列表(需求发布者调用)

- (void)findGetMessageGroupList:(NSString *)helpId
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              };

    [self startNormalPostWith:@"help/getMessageGroupList" paragram:reqDic successedBlock:success failedBolck:failed];
}


///POST /help/getMessageList 查询消息详情列表

- (void)findGetMessageList:(NSString *)groupId
                 messageId:(NSString *)messageId
                  pageSize:(NSString *)pageSize
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"groupId":groupId,
                              @"messageId":messageId,
                              @"pageSize":pageSize,
                              };

    [self startNormalPostWith:@"help/getMessageList" paragram:reqDic successedBlock:success failedBolck:failed];
}


///POST /help/getMessagetGroup 查询咨询消息组（咨询者调用，组不存在自动创建并返回）
- (void)findGetMessagetGroup:(NSString *)helpId
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              };

    [self startNormalPostWith:@"help/getMessageGroup" paragram:reqDic successedBlock:success failedBolck:failed];
}



///POST /help/getMyAcceptHelpList 查询我承接的需求列表
- (void)findGetMyAcceptHelpList:(NSString *)helpId
                       pageSize:(NSString *)pageSize
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"pageSize":pageSize
                              };

    [self startNormalPostWith:@"help/getMyAcceptHelpList" paragram:reqDic successedBlock:success failedBolck:failed];
}

///POST /help/getMySendHelpList 查询我发布的需求列表
- (void)findGetMySendHelpList:(NSString *)helpId
                       pageSize:(NSString *)pageSize
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"pageSize":pageSize
                              };

    [self startNormalPostWith:@"help/getMySendHelpList" paragram:reqDic successedBlock:success failedBolck:failed];
}

///POST /help/pay 支付

- (void)findPay:(NSString *)helpId
     serviceFee:(NSString *)serviceFee
      creditFee:(NSString *)creditFee
          total:(NSString *)total
       netMoney:(NSString *)netMoney
       relMoney:(NSString *)relMoney
        payType:(NSString *)payType
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"serviceFee":serviceFee,
                              @"serviceFee":serviceFee,
                              @"total":total,
                              @"netMoney":netMoney,
                              @"relMoney":relMoney,
                              @"payType":payType,
                              };

    [self startNormalPostWith:@"help/pay" paragram:reqDic successedBlock:success failedBolck:failed];
}


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
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"type":type,
                              @"content":content,
                              @"province":province,
                              @"city":city,
                              @"county":county,
                              @"address":address == nil ? @"" :address,
                              @"serviceFee":serviceFee == nil ? @"" : serviceFee,
                              @"creditFee":creditFee==nil?serviceFee:creditFee,
                              @"phone":phone==nil ? @"":phone,
                              @"weixin":weixin==nil ? @"":weixin,
                              @"qq":qq==nil ? @"":qq,
                              @"picUrls":picUrls,
                              @"accessToken":[LoginUserUtil shaobaoAccessToken]
                              };

    [self startNormalPostWith:@"help/send" paragram:reqDic successedBlock:success failedBolck:failed];
}

/// POST /help/sendMessage 发送消息
- (void)findSendMessage:(NSString *)groupId
         content:(NSString *)content
         picUrls:(NSString *)picUrls
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"groupId":groupId,
                              @"content":content,
                              @"picUrls":picUrls,
                              @"accessToken":[LoginUserUtil accessToken]
                              };

    [self startNormalPostWith:@"help/sendMessage" paragram:reqDic successedBlock:success failedBolck:failed];
}

///POST /help/updateStatus 确认承接或确认需求完成（用于更新需求状态）

- (void)findUpdateStatus:(NSString *)helpId
                optType:(NSString *)optType
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"optType":optType,
                              };

    [self startNormalPostWith:@"help/updateStatus" paragram:reqDic successedBlock:success failedBolck:failed];
}


/**

 父级ID，省份的父级为中国id=1

 @param pid
 @param success
 @param failed 
 */
- (void)findQueryArea:(NSString *)pid
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"pid":pid,
                              };

    [self startNormalPostWith:@"getArea" paragram:reqDic successedBlock:success failedBolck:failed];
}

#pragma mark - 广告

- (void)getAds:(NSString *)type
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"type":type,
                              };

    [self startNormalPostWith:@"ad/getAdList" paragram:reqDic successedBlock:success failedBolck:failed];
}


- (void)uploadShaobaoFileWithPath:(NSString *)filePath
                 successBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{

    [self POST:[NSString stringWithFormat:@"%@/file/save",BJ_SERVER]
    parameters:@{
                 @"accessToken":[LoginUserUtil accessToken],
                 @"subDirName":@"shaobao"
                 }
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         NSData *data = [NSData dataWithContentsOfFile:filePath];
         [formData appendPartWithFileData:data name:@"file" fileName:[LocalTimeUtil getCurrentTimstamp] mimeType:@"image/jpeg"];
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}

#pragma mark - 辣新鲜
- (void)getBbsList:(NSString *)type
             bbsId:(NSString *)bbsId
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{

    NSDictionary *reqDic =  @{
                              @"bbsId":bbsId,
                              @"sortType":type,
                              @"pageSize":@"20",
                              };

    [self startNormalPostWith:@"bbs/getBbsList" paragram:reqDic successedBlock:success failedBolck:failed];
}

- (void)delBbs:(NSString *)bbsId
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"bbsId":bbsId,
                              };

    [self startNormalPostWith:@"bbs/delete" paragram:reqDic successedBlock:success failedBolck:failed];
}


- (void)sendBbs:(NSString *)content
       withPics:(NSString *)pics
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"content":content,
                              @"picUrls":pics
                              };

    [self startNormalPostWith:@"bbs/send" paragram:reqDic successedBlock:success failedBolck:failed];
}


- (void)sendBbsComment:(NSString *)bbsId
       content:(NSString *)content
 successedBlock:(SuccessedBlock)success
    failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"content":content,
                              @"bbsId":bbsId
                              };

    [self startNormalPostWith:@"bbs/sendComment" paragram:reqDic successedBlock:success failedBolck:failed];
}

- (void)uploadShaobaoFileWithPathData:(NSData *)FileData
                     successBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{

    [self POST:[NSString stringWithFormat:@"%@/file/save",BJ_SERVER]
    parameters:@{
                 @"accessToken":[LoginUserUtil accessToken],
                 @"subDirName":@"shaobao"
                 }
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:FileData name:@"file" fileName:[LocalTimeUtil getCurrentTimstamp] mimeType:@"image/jpeg"];
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}

#pragma mark - 支付
///支付宝支付
- (void)aliPay:(NSString *)helpId
    serviceFee:(NSString *)serviceFee
     creditFee:(NSString *)creditFee
         total:(NSString *)total
      netMoney:(NSString *)netMoney
      relMoney:(NSString *)relMoney
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"serviceFee":serviceFee,
                              @"creditFee":creditFee == nil ? @"" : creditFee,
                              @"total":total==nil ? @"" : total,
                              @"netMoney":netMoney,
                              @"relMoney":relMoney,
                              };
    [self startNormalPostWith:@"pay/alipay" paragram:reqDic successedBlock:success failedBolck:failed];
}

///微信支付
- (void)wxPay:(NSString *)helpId
    serviceFee:(NSString *)serviceFee
     creditFee:(NSString *)creditFee
         total:(NSString *)total
      netMoney:(NSString *)netMoney
      relMoney:(NSString *)relMoney
successedBlock:(SuccessedBlock)success
   failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"serviceFee":serviceFee,
                              @"creditFee":creditFee == nil ? @"" : creditFee,
                              @"total":total==nil ? @"" : total,
                              @"netMoney":netMoney,
                              @"relMoney":relMoney,
                              };
    [self startNormalPostWith:@"pay/wxpay" paragram:reqDic successedBlock:success failedBolck:failed];
}

///网币支付
- (void)netMoneyPay:(NSString *)helpId
   serviceFee:(NSString *)serviceFee
    creditFee:(NSString *)creditFee
        total:(NSString *)total
     netMoney:(NSString *)netMoney
     relMoney:(NSString *)relMoney
successedBlock:(SuccessedBlock)success
  failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"helpId":helpId,
                              @"serviceFee":serviceFee,
                              @"creditFee":creditFee == nil ? @"" : creditFee,
                              @"total":total==nil ? @"" : total,
                              @"netMoney":netMoney,
                              @"relMoney":relMoney,
                              };
    [self startNormalPostWith:@"pay/yepay" paragram:reqDic successedBlock:success failedBolck:failed];
}

- (void)payResult:(NSString *)payId
       resultCode:(NSString *)resultCode
responseContent:(NSString *)responseContent
   successedBlock:(SuccessedBlock)success
      failedBolck:(FailedBlock)failed
{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              @"payId":payId,
                              @"resultCode":resultCode,
                              @"responseContent":responseContent,
                              };
    [self startNormalPostWith:@"pay/payResult" paragram:reqDic successedBlock:success failedBolck:failed];
}

#pragma mark - 我的
///查询我的网币余额
- (void)getCash:(SuccessedBlock)success
      failedBolck:(FailedBlock)failed{
    NSDictionary *reqDic =  @{
                              @"accessToken":[LoginUserUtil accessToken],
                              };
    [self startNormalPostWith:@"my/cash" paragram:reqDic successedBlock:success failedBolck:failed];
}
@end
