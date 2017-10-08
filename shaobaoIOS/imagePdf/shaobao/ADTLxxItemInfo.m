//
//  ADTLxxItemInfo.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/6.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ADTLxxItemInfo.h"

@implementation ADTLxxItemInfo
+(ADTLxxItemInfo *)from:(NSDictionary *)info
{
    ADTLxxItemInfo *ret = [[ADTLxxItemInfo alloc]init];
    ret.m_id = [info stringWithFilted:@"id"];
    ret.m_commentCount = [info stringWithFilted:@"commentCount"];
    ret.m_createTime = [info stringWithFilted:@"createTime"];
    ret.m_content = [info stringWithFilted:@"content"];
    ret.m_arrPics = [[info stringWithFilted:@"imageUrl"]componentsSeparatedByString:@","];
    ret.m_userAvatar = [NSString stringWithFormat:@"%@%@",BJ_SERVER, [info stringWithFilted:@"userAvatar"]];
    ret.m_userId = [info stringWithFilted:@"userId"];
    ret.m_userName = [info stringWithFilted:@"userName"];
    ret.m_userType = [info stringWithFilted:@"userType"];
    return ret;
}
@end
