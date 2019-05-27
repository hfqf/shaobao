//
//  ADTVoteItem.h
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ADTVoteItem : NSObject

@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_title;
@property(nonatomic,strong)NSString *m_time;
@property(nonatomic,strong)NSString *m_option;
@property(nonatomic,strong)NSString *m_image1;
@property(nonatomic,strong)NSString *m_image2;
@property(nonatomic,strong)NSString *m_image3;
@property(nonatomic,strong)NSString *m_createName;
@property(nonatomic,strong)NSMutableArray *m_arrPics;
@property(nonatomic,strong)NSMutableArray *m_arrOptitonItem;
@property(nonatomic,strong)NSMutableArray *m_arrComments;
@property(nonatomic,assign)BOOL m_isNew;

+ (ADTVoteItem *)from:(NSDictionary *)info;
@end

@interface ADTVoteOptionItem : NSObject
@property(nonatomic,strong)NSString *m_option;
@property(nonatomic,strong)NSString *m_num;
@property(nonatomic,strong)NSString *m_optionId;
@property(nonatomic,assign)NSInteger m_index;
@property(nonatomic,assign)BOOL m_isNew;
+ (ADTVoteOptionItem *)from:(NSDictionary *)info;
@end

