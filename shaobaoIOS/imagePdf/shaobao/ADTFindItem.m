//
//  ADTFindItem.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/29.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ADTFindItem.h"

@implementation ADTFindItem
+ (ADTFindItem *)from:(NSDictionary *)info
{
    ADTFindItem *ret = [[ADTFindItem alloc]init];
    ret.m_acceptScoreContent = [info stringWithFilted:@"acceptScoreContent"];
    ret.m_acceptScoreResult = [info stringWithFilted:@"acceptScoreResult"];
    ret.m_acceptTime = [info stringWithFilted:@"acceptTime"];
    ret.m_acceptUserAvatar = [info stringWithFilted:@"acceptUserAvatar"];
    ret.m_acceptUserId = [info stringWithFilted:@"acceptUserId"];
    ret.m_acceptUserName = [info stringWithFilted:@"acceptUserName"];
    ret.m_acceptUserPhone = [info stringWithFilted:@"acceptUserPhone"];
    ret.m_acceptUserType = [info stringWithFilted:@"acceptUserType"];
    ret.m_address = [info stringWithFilted:@"address"];
    ret.m_city = [info stringWithFilted:@"city"];
    ret.m_cityName = [info stringWithFilted:@"cityName"];
    ret.m_content = [info stringWithFilted:@"content"];
    ret.m_county = [info stringWithFilted:@"county"];
    ret.m_countyName = [info stringWithFilted:@"countyName"];
    ret.m_createTime = [info stringWithFilted:@"createTime"];
    ret.m_creditFee = [info stringWithFilted:@"creditFee"];
    ret.m_id = [info stringWithFilted:@"id"];
    ret.m_payStatus = [info stringWithFilted:@"payStatus"];
    NSString *pics = [info stringWithFilted:@"picUrls"];
    ret.m_arrPics = [pics componentsSeparatedByString:@","];
    ret.m_province = [info stringWithFilted:@"province"];
    ret.m_provinceName = [info stringWithFilted:@"provinceName"];
    ret.m_serviceFee = [info stringWithFilted:@"serviceFee"];

    ret.m_status = [info stringWithFilted:@"status"];
    ret.m_type = [info stringWithFilted:@"type"];
    ret.m_userId = [info stringWithFilted:@"userId"];
    ret.m_userAvatar = [info stringWithFilted:@"userAvatar"];
    ret.m_userName = [info stringWithFilted:@"userName"];
    ret.m_userPhone = [info stringWithFilted:@"userPhone"];
    ret.m_userScoreContent = [info stringWithFilted:@"userScoreContent"];
    ret.m_userScoreResult = [info stringWithFilted:@"userScoreResult"];
    ret.m_userType = [info stringWithFilted:@"userType"];

    return ret;
}
@end
