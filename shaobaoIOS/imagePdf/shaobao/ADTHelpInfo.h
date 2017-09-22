//
//  ADTHelpInfo.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTHelpInfo : NSObject
@property(nonatomic,strong) NSString *m_type;
@property(nonatomic,strong) NSString *m_desc;
@property(nonatomic,strong) NSDictionary *m_area;
@property(nonatomic,strong) NSString *m_address;
@property(nonatomic,strong) NSString *m_promise1;
@property(nonatomic,strong) NSString *m_promise2;
@property(nonatomic,strong) NSString *m_sender;
@property(nonatomic,strong) NSString *m_tel;
@property(nonatomic,strong) NSMutableArray *m_arrPics;
@end
