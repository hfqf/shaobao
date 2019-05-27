//
//  ADTVoteItem.m
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "ADTVoteItem.h"

@implementation ADTVoteItem
+ (ADTVoteItem *)from:(NSDictionary *)info{
    ADTVoteItem *item = [[ADTVoteItem alloc]init];
    item.m_isNew =NO;
    item.m_title = [info stringWithFilted:@"title"];
    item.m_id = [info stringWithFilted:@"id"];
    item.m_image1 = [info stringWithFilted:@"image1"];
    item.m_image2 = [info stringWithFilted:@"image2"];
    item.m_image3 = [info stringWithFilted:@"image3"];
    item.m_time = [info stringWithFilted:@"createTime"];
    item.m_createName = [info stringWithFilted:@"createName"];
    NSMutableArray *arrPics = [NSMutableArray array];
    if(item.m_image1.length > 0){
        [arrPics addObject:item.m_image1];
    }
    
    if(item.m_image2.length > 0){
        [arrPics addObject:item.m_image2];
    }
    
    if(item.m_image3.length > 0){
        [arrPics addObject:item.m_image3];
    }
    
    NSMutableArray *arr =[NSMutableArray array];
    NSArray *arr1 =  [info stringWithFilted:@"optionList"];
    if([arr1 isKindOfClass:[NSArray class]]){
        for(NSDictionary *option in arr1){
            ADTVoteOptionItem *_opt = [ADTVoteOptionItem from:option];
            [arr addObject:_opt];
        }
        item.m_arrOptitonItem = arr;
    }
    item.m_arrPics = arrPics;
    return item;
}
@end


@implementation ADTVoteOptionItem

+ (ADTVoteOptionItem *)from:(NSDictionary *)info{
    ADTVoteOptionItem *option = [[ADTVoteOptionItem alloc]init];
    option.m_isNew = false;
    option.m_num = [info stringWithFilted:@"optionCount"];
    option.m_option = [info stringWithFilted:@"optionName"];
    option.m_optionId = [info stringWithFilted:@"id"];
    return option;
 }

@end
