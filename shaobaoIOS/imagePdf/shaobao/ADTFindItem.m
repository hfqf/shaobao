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
    ret.m_creditFee = [NSString stringWithFormat:@"%@", @([info[@"creditFee"]doubleValue])];
    ret.m_id = [info stringWithFilted:@"id"];
    ret.m_payStatus = [info stringWithFilted:@"payStatus"];
    ret.m_email = [info stringWithFilted:@"userEmail"];
    ret.m_userWX = [info stringWithFilted:@"userWeixin"];
    NSString *pics = [info stringWithFilted:@"picUrls"];
    NSMutableArray *arrPic = [NSMutableArray array];
    if(pics.length > 0){
        if([pics rangeOfString:@","].length > 0){
            [arrPic addObjectsFromArray:[pics componentsSeparatedByString:@","]];
        }else{
            [arrPic addObject:pics];
        }
        ret.m_arrPics = arrPic;
    }


//    NSInteger ran = rand()%6;
//    NSMutableArray *arr = [NSMutableArray array];
//    for(NSInteger i=0;i<ran;i++){
//        [arr addObject:@""];
//    }
//    [arrPic addObject:@"/shaobao/2017/31/19/b8d9487d-4a81-44d6-94de-34ec1e57d7c3"];
    ret.m_arrPics = arrPic;
    ret.m_province = [info stringWithFilted:@"province"];
    ret.m_provinceName = [info stringWithFilted:@"provinceName"];
    ret.m_serviceFee =[NSString stringWithFormat:@"%@", @([info[@"serviceFee"]doubleValue])];

    ret.m_status = [info stringWithFilted:@"status"];
    ret.m_type = [info stringWithFilted:@"type"];
    ret.m_userId = [info stringWithFilted:@"userId"];
    ret.m_userAvatar = [info stringWithFilted:@"userAvatar"];
    ret.m_userName = [info stringWithFilted:@"userName"];
    ret.m_userPhone = [info stringWithFilted:@"userPhone"];
    ret.m_userScoreContent = [info stringWithFilted:@"userScoreContent"];
    ret.m_userScoreResult = [info stringWithFilted:@"userScoreResult"];
    ret.m_userType = [info stringWithFilted:@"userType"];
    ret.m_isSender  = ret.m_userId.longLongValue == [LoginUserUtil shaobaoUserId].longLongValue;
    ret.m_acceptScoreStatus = [info stringWithFilted:@"acceptScoreStatus"];
    ret.m_userScoreStatus = [info stringWithFilted:@"userScoreStatus"];
    return ret;
}
@end
