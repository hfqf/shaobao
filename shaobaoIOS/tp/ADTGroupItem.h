//
//  ADTGroupItem.h
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADTGroupItem : NSObject
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_status;
@property(nonatomic,strong)NSString *m_createTime;
@property(nonatomic,strong)NSString *m_orgId;
@property(nonatomic,strong)NSString *m_parentId;
@property(nonatomic,strong)NSString *m_createId;
@property(nonatomic,strong)NSString *m_createName;
@property(nonatomic,strong)NSString *m_name;
@property(nonatomic,strong)NSString *m_address;
@property(nonatomic,strong)NSString *m_email;
@property(nonatomic,strong)NSString *m_tel1;
@property(nonatomic,strong)NSString *m_tel2;
@property(nonatomic,strong)NSString *m_tel3;
@property(nonatomic,strong)NSMutableArray *m_arrStaff;
@property(nonatomic,assign)BOOL m_isNew;
+ (ADTGroupItem *)from:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
