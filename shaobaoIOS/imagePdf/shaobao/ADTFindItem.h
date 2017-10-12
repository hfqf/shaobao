//
//  ADTFindItem.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/29.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTFindItem : NSObject
@property(nonatomic,strong) NSString *m_acceptScoreContent;
@property(nonatomic,strong) NSString *m_acceptScoreResult;
@property(nonatomic,strong) NSString *m_acceptTime;
@property(nonatomic,strong) NSString *m_acceptUserAvatar;
@property(nonatomic,strong) NSString *m_acceptUserId;
@property(nonatomic,strong) NSString *m_acceptUserName;
@property(nonatomic,strong) NSString *m_acceptUserPhone;
@property(nonatomic,strong) NSString *m_acceptUserType;
@property(nonatomic,strong) NSString *m_address;
@property(nonatomic,strong) NSString *m_city;
@property(nonatomic,strong) NSString *m_cityName;
@property(nonatomic,strong) NSString *m_content;
@property(nonatomic,strong) NSString *m_county;
@property(nonatomic,strong) NSString *m_countyName;
@property(nonatomic,strong) NSString *m_createTime;
@property(nonatomic,strong) NSString *m_creditFee;
@property(nonatomic,strong) NSString *m_id;
@property(nonatomic,strong) NSString *m_payStatus;
@property(nonatomic,strong) NSArray  *m_arrPics;
@property(nonatomic,strong) NSString *m_province;
@property(nonatomic,strong) NSString *m_provinceName;
@property(nonatomic,strong) NSString *m_serviceFee;
@property(nonatomic,strong) NSString *m_status;
@property(nonatomic,strong) NSString *m_type;
@property(nonatomic,strong) NSString *m_userAvatar;
@property(nonatomic,strong) NSString *m_userId;
@property(nonatomic,strong) NSString *m_userName;
@property(nonatomic,strong) NSString *m_userPhone;
@property(nonatomic,strong) NSString *m_userScoreContent;
@property(nonatomic,strong) NSString *m_userScoreResult;
@property(nonatomic,strong) NSString *m_userType;
@property(nonatomic,strong) NSString *m_email;
@property(assign)BOOL m_isSender;

+ (ADTFindItem *)from:(NSDictionary *)info;

@end
