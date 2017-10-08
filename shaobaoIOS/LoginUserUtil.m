//
//  LoginUserUtil.m
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "LoginUserUtil.h"
@implementation LoginUserUtil


+ (NSString *)credit
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"credit"];
    return name;
}

+ (NSString *)deptId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"deptid"];
    return name;
}

+ (NSString *)orgId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"orgid"];
    return name;
}


+ (NSString *)deptName
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"deptname"];
    return name;
}

+ (NSString *)orgName
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"orgname"];
    return name;
}

+ (NSString *)money
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"money"];
    return name;
}

//登录时输入的账户
+ (NSString *)accountOfInput
{
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGINID_IMTOKEN];
    return  account == nil ? @"" :account;

}
+ (NSString *)nameOfCurrentLoginer
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"username"];
    return name;
}

+ (NSString *)accountOfCurrentLoginer
{
   return  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_ACCOUTN];
}

+ (NSString *)pwdOfCurrentLoginer
{
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_PASSWORD];
    return pwd;
}



+ (NSString *)accessToken
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic objectForKey:@"accessToken"];
}

//获得联系人后返回的token,再来创建im
+ (NSString *)imToken
{
    NSString * imToken = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IM_TOKEN];
    imToken = imToken == nil ? @"" : imToken;
    return imToken;
}

//给后台判断是否需要更新联系人的标识
+ (NSString *)mdSign
{
    NSString * sign = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IM_MDSIGN];
    sign = sign == nil ? @"-1" : sign;
    return sign;

}

+ (long long)loginUserId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    long long  userId = [[dic objectForKey:@"id"]longLongValue];
    return  userId;
}


+ (NSString *)userId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return  [dic stringWithFilted:@"userid"];
}

+ (NSString *)userName
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return  [dic stringWithFilted:@"username"];
}

+ (NSString *)loginParentId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic objectForKey:@"id"];
}

+ (NSString *)remoteId
{
    NSString *remote = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_REMOTEID];
    return remote == nil ?@"":remote;
}

+ (NSString *)loginIdToIm
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *loginId = [self isTeacher]?[dic objectForKey:@"id"]:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGINID_IMTOKEN];
    return loginId == nil ? @"" : loginId;
}


+ (NSString *)imageOfUserWith:(NSString *)userId
{
    return nil;
}

+ (BOOL)isTeacher
{
//    NSDictionary *dic = [self readDictionartFromPlist];
//    return [[dic objectForKey:@"role"]intValue] == 0;
    
    return   [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGIN_ROLE]isEqualToString:@"1"];
}

+ (NSString *)extend
{
    NSString * token = [self accessToken];
    return token;
}

+ (NSString *)IMEI
{
   return  [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

+ (NSString *)get32BitString
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *ret = [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    return [ret lowercaseString];
}

+ (NSString *)getInnerId
{
    return [NSString stringWithFormat:@"%@%@",[LocalTimeUtil getCurrentTimstamp],[[self get32BitString]substringToIndex:5]];
}

//家长或老师选择完

#pragma mark - 当前登陆的用户信息

+ (NSString *)pathOfCurrentLoginer
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doc = [paths objectAtIndex:0];
    NSString *path=[doc stringByAppendingPathComponent:@"currentLoginUser.plist"];
    
    BOOL * flag = NO;
    if(![fileManager fileExistsAtPath:path isDirectory:flag])
    {
        NSDictionary * dic = [NSDictionary dictionary];
        [dic writeToFile:path atomically:YES];
    }
    return path;
}


+ (BOOL)writeDictionaryToPlist:(NSDictionary *)protalsDic
{
    if(protalsDic == nil)
    {
        return NO;
    }
    NSString * path = [self pathOfCurrentLoginer];
    NSDictionary * dic = [self checkValueValid:protalsDic];
    return  [dic writeToFile:path atomically:YES];
}

+ (NSDictionary *)readDictionartFromPlist
{
    NSString * path = [self pathOfCurrentLoginer];
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

+ (NSDictionary *)checkValueValid :(NSDictionary *)oriDic
{
    int i = 0;
    NSArray * arrValue = [oriDic allValues];
    NSArray *arrKey = [oriDic allKeys];
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc]init];
    for(NSDictionary * dic in oriDic)
    {
        SpeLog(@"%@",dic);
        if([[arrValue objectAtIndex:i] isKindOfClass:[NSNull class]])
        {
            [newDic setObject:@"" forKey:[arrKey objectAtIndex:i]];
        }
        else
        {
            [newDic setObject:[arrValue objectAtIndex:i] forKey:[arrKey objectAtIndex:i]];
        }
        i++;
    }
    return newDic;
}

#pragma mark - 

+ (NSURL *)headUrl
{
    return nil;
}


+ (BOOL)isNeedSound
{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_STATE_SOUND_TIP]isEqualToString:@"1"];
}

+ (BOOL)isNeedShake
{
   return  [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_STATE_SHAKE_TIP]isEqualToString:@"1"];
}


#pragma mark - 未读个数
+ (int)numOfNewFriendReq
{
    NSString *num = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_FRIEND_REQ];
    //return 5;
    return [num intValue];
}

#pragma mark - sso
+ (NSString *)ssoName
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SSO_NAME];
    return ret == nil ? @"" : ret;
}

+ (NSString *)ssoPwd
{
    return @"111111";
//    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SSO_PWD];
//    return ret == nil ? @"" : ret;
}

+ (BOOL)ssoIsNeedLogin
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SSO_IS_NEED_LOGIN];
    return ret == nil ? NO : [ret isEqualToString:@"1"];
}

+ (NSArray *)reosuceIds
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *ret = [dic objectForKey:@"resourcesId"];
    return [ret componentsSeparatedByString:@","];
}

+ (NSArray *)arrModules
{
    
    NSArray *arrResourceIds = [LoginUserUtil reosuceIds];
    
    __block  BOOL isShowGWGL = NO; //公文管理
    __block  BOOL isShowTZGL = NO; //通知管理
    __block  BOOL isShowHYGL = NO; //会议管理
    __block  BOOL isShowDCDB = NO;//督查督办
    __block  BOOL isShowLDRC = NO; //领导日程
    __block  BOOL isShowTXL = NO; //通讯录
    __block  BOOL isShowDZQK = NO; //电子期刊
    __block  BOOL isShowZYZX = NO; //资源中心
    __block  BOOL isShowDWSW = NO; //单位收文
    __block  BOOL isShowGZBX = NO; //故障报修
    [arrResourceIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //“单位收文”，已控制，权限代码：1406,290001,290002,290003
        if([obj integerValue] == 1406 ||
           [obj integerValue] == 290001 ||
           [obj integerValue] == 290002 ||
           [obj integerValue] == 290003 ){
            isShowDWSW = YES;
        }
        
        //“领导日程”，已控制，权限代码：310101
        if([obj integerValue] == 310101){
            isShowLDRC = YES;
        }
        
        //“督查督办”，已控制，权限代码：300206
        if([obj integerValue] == 300206){
            isShowDCDB = YES;
        }
        
        
        //“公文管理”，暂未控制，权限代码：100002,200002,100003,200003
        if([obj integerValue] == 100002||
           [obj integerValue] == 200002||
           [obj integerValue] == 100003||
           [obj integerValue] == 200003){
            isShowGWGL = YES;
        }
        
        //“通知管理”，暂未控制，权限代码：10411,10412,10413,10414
        if([obj integerValue] == 10411||
           [obj integerValue] == 10412||
           [obj integerValue] == 10413||
           [obj integerValue] == 10414){
            isShowTZGL = YES;
        }
        
        //“会议管理”，暂未控制，权限代码：420111,420112
        if([obj integerValue] == 420111||
           [obj integerValue] == 420112){
            isShowHYGL = YES;
        }
        
        //“通讯录”  ，暂未控制，权限代码：10101

        if([obj integerValue] == 10101){
            isShowTXL = YES;
        }
        
        //“电子期刊”，暂未控制，权限代码：10605
        if([obj integerValue] == 10605){
            isShowDZQK = YES;
        }
        
        //故障保修”，暂未控制权限代码：445101,445102
        if([obj integerValue] == 445101||
           [obj integerValue] == 445102){
            isShowGZBX = YES;
        }
        
        //“资源中心”，暂未控制，权限代码：10605
        if([obj integerValue] == 10605){
            isShowZYZX = YES;
        }
    }];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[
                                                           @{
                                                               @"name":@"公文管理",
                                                               @"icon":@"home_1",
                                                               @"key":@"gwgl"
                                                               },
                                                           @{
                                                               @"name":@"通知管理",
                                                               @"icon":@"home_2",
                                                               @"key":@"tzgl"
                                                               },
                                                           @{
                                                               @"name":@"会议管理",
                                                               @"icon":@"home_3",
                                                               @"key":@"hygl"
                                                               },
                                                           @{
                                                               @"name":@"督查督办",
                                                               @"icon":@"home_4",
                                                               @"key":@"dcdb"
                                                               },
                                                           @{
                                                               @"name":@"领导日程",
                                                               @"icon":@"home_5",
                                                               @"key":@"ldrc"
                                                               },
                                                           @{
                                                               @"name":@"通讯录",
                                                               @"icon":@"home_6",
                                                               @"key":@"txl"
                                                               },
                                                           @{
                                                               @"name":@"电子期刊",
                                                               @"icon":@"home_7",
                                                               @"key":@"dzqk"
                                                               },
                                                           @{
                                                               @"name":@"资源中心",
                                                               @"icon":@"home_8",
                                                               @"key":@"zyzx"
                                                               },
                                                           @{
                                                               @"name":@"单位收文",
                                                               @"icon":@"home_9",
                                                               @"key":@"dwsw"
                                                               },
                                                           @{
                                                               @"name":@"故障报修",
                                                               @"icon":@"home_10",
                                                               @"key":@"gzbx"
                                                               },
                                                           
                                                           ]];
    NSMutableArray *arrFinal = [NSMutableArray array];
    for(NSDictionary *info in arr){
        if([info[@"key"]isEqualToString:@"gwgl"]){
            if(isShowGWGL){
                [arrFinal addObject:info];
                 continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"tzgl"]){
            if(isShowTZGL){
                [arrFinal addObject:info];
                 continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"hygl"]){
            if(isShowHYGL){
                [arrFinal addObject:info];
                 continue;
            }else{
                continue;
            }
        }
        
        
        if([info[@"key"]isEqualToString:@"dcdb"]){
            if(isShowDCDB){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"ldrc"]){
            if(isShowLDRC){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"txl"]){
            if(isShowTXL){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"dzqk"]){
            if(isShowDZQK){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"zyzx"]){
            if(isShowZYZX){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"dwsw"]){
            if(isShowDWSW){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"gzbx"]){
            if(isShowGZBX){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
  
        [arrFinal addObject:info];
    }
    
    return arrFinal;
    
}

+ (NSArray *)arrModulesSlider
{
   
    NSArray *arrResourceIds = [LoginUserUtil reosuceIds];
    

    __block  BOOL isShowGWGL = NO; //公文管理
    __block  BOOL isShowTZGL = NO; //通知管理
    __block  BOOL isShowHYGL = NO; //会议管理
    __block  BOOL isShowDCDB = NO;//督查督办
    __block  BOOL isShowLDRC = NO; //领导日程
    __block  BOOL isShowTXL = NO; //通讯录
    __block  BOOL isShowDZQK = NO; //电子期刊
    __block  BOOL isShowZYZX = NO; //资源中心
    __block  BOOL isShowDWSW = NO; //单位收文
    __block  BOOL isShowGZBX = NO; //故障报修
    [arrResourceIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //“单位收文”，已控制，权限代码：1406,290001,290002,290003
        if([obj integerValue] == 1406 ||
           [obj integerValue] == 290001 ||
           [obj integerValue] == 290002 ||
           [obj integerValue] == 290003 ){
            isShowDWSW = YES;
        }
        
        //“领导日程”，已控制，权限代码：310101
        if([obj integerValue] == 310101){
            isShowLDRC = YES;
        }
        
        //“督查督办”，已控制，权限代码：300206
        if([obj integerValue] == 300206){
            isShowDCDB = YES;
        }
        
        
        //“公文管理”，暂未控制，权限代码：100002,200002,100003,200003
        if([obj integerValue] == 100002||
           [obj integerValue] == 200002||
           [obj integerValue] == 100003||
           [obj integerValue] == 200003){
            isShowGWGL = YES;
        }
        
        //“通知管理”，暂未控制，权限代码：10411,10412,10413,10414
        if([obj integerValue] == 10411||
           [obj integerValue] == 10412||
           [obj integerValue] == 10413||
           [obj integerValue] == 10414){
            isShowTZGL = YES;
        }
        
        //“会议管理”，暂未控制，权限代码：420111,420112
        if([obj integerValue] == 420111||
           [obj integerValue] == 420112){
            isShowHYGL = YES;
        }
        
        //“通讯录”  ，暂未控制，权限代码：10101
        
        if([obj integerValue] == 10101){
            isShowTXL = YES;
        }
        
        //“电子期刊”，暂未控制，权限代码：10605
        if([obj integerValue] == 10605){
            isShowDZQK = YES;
        }
        
        //故障保修”，暂未控制权限代码：445101,445102
        if([obj integerValue] == 445101||
           [obj integerValue] == 445102){
            isShowGZBX = YES;
        }
        
        //“资源中心”，暂未控制，权限代码：10605
        if([obj integerValue] == 10605){
            isShowZYZX = YES;
        }
    }];
    
    

    NSMutableArray *arr = [NSMutableArray arrayWithArray:
                           @[
                            @{
                             @"name":@"首页",
                             @"icon":@"home_home",
                             @"class" : @"HomeStartViewController",
                             @"key":@"home"
                           },
                           @{
                             @"name":@"公文管理",
                             @"icon":@"home_1",
                             @"class" : @"TodoViewController",
                             @"key":@"gwgl"
                             },
                           @{
                             @"name":@"通知管理",
                             @"icon":@"home_2",
                             @"class" : @"NoticeViewController",
                             @"key":@"tzgl"
                             },
                           @{
                             @"name":@"会议管理",
                             @"icon":@"home_3",
                             @"class" : @"MeetingManagerViewController",
                             @"key":@"hygl"
                             },
                           @{
                             @"name":@"督查督办",
                             @"icon":@"home_4",
                             @"class" : @"ObserveManagerViewController",
                             @"key":@"dcdb"
                             },
                           @{
                             @"name":@"领导日程",
                             @"icon":@"home_5",
                             @"class" : @"LeaderSchudeViewController",
                             @"key":@"ldrc"
                             },
                           @{
                             @"name":@"通讯录",
                             @"icon":@"home_6",
                             @"class" : @"ContactViewController",
                             @"key":@"txl"
                             },
                           @{
                             @"name":@"电子期刊",
                             @"icon":@"home_7",
                             @"class" : @"EMaganizeViewController",
                             @"key":@"dzqk"
                             },
                           @{
                             @"name":@"资源中心",
                             @"icon":@"home_8",
                             @"class" : @"ResourceCentreViewController",
                             @"key":@"zyzx"
                             },
                           @{
                             @"name":@"单位收文",
                             @"icon":@"home_9",
                             @"class" : @"DepartmentReceiveArticeViewController",
                             @"key":@"dwsw"
                             },
                           @{
                             @"name":@"故障报修",
                             @"icon":@"home_10",
                             @"class":@"FaultReprairViewController",
                             @"key":@"gzbx"
                             }]];

    
    NSMutableArray *arrFinal = [NSMutableArray array];
    for(NSDictionary *info in arr){
        if([info[@"key"]isEqualToString:@"gwgl"]){
            if(isShowGWGL){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"tzgl"]){
            if(isShowTZGL){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"hygl"]){
            if(isShowHYGL){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        
        if([info[@"key"]isEqualToString:@"dcdb"]){
            if(isShowDCDB){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"ldrc"]){
            if(isShowLDRC){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"txl"]){
            if(isShowTXL){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"dzqk"]){
            if(isShowDZQK){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"zyzx"]){
            if(isShowZYZX){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"dwsw"]){
            if(isShowDWSW){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        if([info[@"key"]isEqualToString:@"gzbx"]){
            if(isShowGZBX){
                [arrFinal addObject:info];
                continue;
            }else{
                continue;
            }
        }
        
        [arrFinal addObject:info];
    }
    
    return arrFinal;
    
    
}

#pragma mark - shaobao
+(NSString *)shaobaoToken
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"accessToken"];
}

+(NSString *)shaobaoHeadUrl
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"avatar"];
}

+(NSString *)shaobaoUserId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"id"];
}

+(NSString *)shaobaoLoginName
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"loginName"];
}

+(NSString *)shaobaoAccessToken
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"accessToken"];
}

+(NSString *)shaobaoLoginPass
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"loginPass"];
}

+(NSString *)shaobaoTel
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"phone"];
}

+(NSString *)shaobaoUserType
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"type"];
}

+(NSString *)shaobaoUserName
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic stringWithFilted:@"userName"];
}

@end
