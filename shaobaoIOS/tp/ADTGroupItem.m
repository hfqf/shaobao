//
//  ADTGroupItem.m
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "ADTGroupItem.h"

@implementation ADTGroupItem
+ (ADTGroupItem *)from:(NSDictionary *)info{
    ADTGroupItem *item = [[ADTGroupItem alloc]init];
    item.m_parentId = [info stringWithFilted:@"parentId"];
    item.m_id = [info stringWithFilted:@"id"];
    item.m_orgId = [info stringWithFilted:@"id"];
    item.m_address = [info stringWithFilted:@"address"];
    item.m_createId = [info stringWithFilted:@"createId"];
    item.m_createName = [info stringWithFilted:@"createName"];
    item.m_createTime = [info stringWithFilted:@"createTime"];
    item.m_email = [info stringWithFilted:@"email"];
    item.m_name = [info stringWithFilted:@"name"];
    item.m_status = [info stringWithFilted:@"status"];
    item.m_tel1 = [info stringWithFilted:@"tel1"];
    item.m_tel2 = [info stringWithFilted:@"tel2"];
    item.m_tel3 = [info stringWithFilted:@"tel3"];
    item.m_isNew = NO;
    return item;
}
@end
