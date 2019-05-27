//
//  ADTStaffItem.h
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADTStaffItem : NSObject
@property(nonatomic,strong)NSString *m_orgId;
@property(nonatomic,strong)NSString *m_orgName;
@property(nonatomic,strong)NSString *m_name;
@property(nonatomic,strong)NSString *m_jobNumber;
@property(nonatomic,strong)NSString *m_duty;
@property(nonatomic,strong)NSString *m_grade;
@property(nonatomic,strong)NSString *m_image1;
@property(nonatomic,strong)NSString *m_image2;
@property(nonatomic,strong)NSString *m_image3;
@property(nonatomic,strong)NSString *m_gztd;
@property(nonatomic,strong)NSString *m_gztd_g;
@property(nonatomic,strong)NSString *m_gztd_z;
@property(nonatomic,strong)NSString *m_gztd_d;
@property(nonatomic,strong)NSString *m_ywnl;
@property(nonatomic,strong)NSString *m_ywnl_g;
@property(nonatomic,strong)NSString *m_ywnl_z;
@property(nonatomic,strong)NSString *m_ywnl_d;
@property(nonatomic,strong)NSString *m_qyjs;
@property(nonatomic,strong)NSString *m_qyjs_g;
@property(nonatomic,strong)NSString *m_qyjs_z;
@property(nonatomic,strong)NSString *m_qyjs_d;
@property(nonatomic,strong)NSString *m_pxpz;
@property(nonatomic,strong)NSString *m_pxpz_g;
@property(nonatomic,strong)NSString *m_pxpz_z;
@property(nonatomic,strong)NSString *m_pxpz_d;
@property(nonatomic,strong)NSString *m_ljzl;
@property(nonatomic,strong)NSString *m_ljzl_g;
@property(nonatomic,strong)NSString *m_ljzl_z;
@property(nonatomic,strong)NSString *m_ljzl_d;
@property(nonatomic,strong)NSString *m_shgx;
@property(nonatomic,strong)NSString *m_shgx_g;
@property(nonatomic,strong)NSString *m_shgx_z;
@property(nonatomic,strong)NSString *m_shgx_d;
@property(nonatomic,strong)NSString *m_zwpz;
@property(nonatomic,strong)NSString *m_zwpz_g;
@property(nonatomic,strong)NSString *m_zwpz_z;
@property(nonatomic,strong)NSString *m_zwpz_d;
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_createName;
@property(nonatomic,strong)NSMutableArray *m_arrComment;
@property(nonatomic,strong)NSMutableArray *m_arrPics;
@property(nonatomic,assign)BOOL m_isNew;
+ (ADTStaffItem *)from:(NSDictionary *)info;
@end


@interface ADTComment : NSObject
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_createrName;
@property(nonatomic,strong)NSString *m_content;
@property(nonatomic,strong)NSString *m_title;
@property(nonatomic,strong)NSString *m_time;
@property(nonatomic,strong)NSArray *m_arrPics;
+(ADTComment *)from:(NSDictionary *)info;
@end
NS_ASSUME_NONNULL_END
