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
    NSString *images = [info stringWithFilted:@"imageUrl"];
    if(images.length == 0){
        ret.m_arrPics = @[];
    }else{
        NSArray *_arrPics = [images componentsSeparatedByString:@","];
        NSMutableArray *arrPics = [NSMutableArray array];
        for(NSString *str in _arrPics){
            if(str.length > 0){
                [arrPics addObject:str];
            }
        }
        ret.m_arrPics = arrPics;
    }
    ret.m_userAvatar = [info stringWithFilted:@"userAvatar"];
    ret.m_userId = [info stringWithFilted:@"userId"];
    ret.m_userName = [info stringWithFilted:@"userName"];
    ret.m_userType = [info stringWithFilted:@"userType"];
    
    NSArray *arr = info[@"commentList"];
    ret.m_arrComments = [arr isKindOfClass:[NSNull class]] ? @[] : arr;
    return ret;
}
@end
