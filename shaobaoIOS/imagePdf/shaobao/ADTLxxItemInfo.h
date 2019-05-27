//
//  ADTLxxItemInfo.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/6.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTLxxItemInfo : NSObject
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_commentCount;
@property(nonatomic,strong)NSString *m_content;
@property(nonatomic,strong)NSString *m_createTime;
@property(nonatomic,strong)NSArray *m_arrPics;
@property(nonatomic,strong)NSString *m_userAvatar;
@property(nonatomic,strong)NSString *m_userId;
@property(nonatomic,strong)NSString *m_userName;
@property(nonatomic,strong)NSString *m_userType;
@property(nonatomic,strong)NSArray *m_arrComments;
+(ADTLxxItemInfo *)from:(NSDictionary *)info;

+(ADTLxxItemInfo *)from2:(NSDictionary *)info;
@end
