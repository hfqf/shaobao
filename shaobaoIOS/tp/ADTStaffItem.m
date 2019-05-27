//
//  ADTStaffItem.m
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "ADTStaffItem.h"

@implementation ADTStaffItem
- (instancetype)init{
    if(self = [super init]){
        self.m_gztd = @"1";
        self.m_ywnl = @"1";
        self.m_qyjs = @"1";
        self.m_pxpz = @"1";
        self.m_ljzl = @"1";
        self.m_shgx = @"1";
        self.m_zwpz = @"1";
    }
    return self;
}
+ (ADTStaffItem *)from:(NSDictionary *)info{
    ADTStaffItem *person = [[ADTStaffItem alloc]init];
    person.m_createName = [info stringWithFilted:@"createName"];
    person.m_duty = [info stringWithFilted:@"duty"];
    person.m_grade = [info stringWithFilted:@"grade"];
    person.m_id = [info stringWithFilted:@"id"];
    person.m_image1 = [info stringWithFilted:@"image1"];
    person.m_image2 = [info stringWithFilted:@"image2"];
    person.m_image3 = [info stringWithFilted:@"image3"];
    
    NSMutableArray *arrPics = [NSMutableArray array];
    if(person.m_image1.length > 0){
        [arrPics addObject:person.m_image1];
    }
    if(person.m_image2.length > 0){
        [arrPics addObject:person.m_image2];
    }
    if(person.m_image3.length > 0){
        [arrPics addObject:person.m_image3];
    }
    person.m_arrPics = arrPics;
    
    person.m_jobNumber = [info stringWithFilted:@"jobNumber"];
    person.m_name = [info stringWithFilted:@"name"];
    person.m_orgName = [info stringWithFilted:@"orgName"];
    person.m_orgId = [info stringWithFilted:@"orgId"];
    
    NSInteger gztdD = [info[@"gztdD"]integerValue];
    NSInteger gztdG = [info[@"gztdG"]integerValue];
    NSInteger gztdZ = [info[@"gztdZ"]integerValue];
    if(gztdG == 1){
        person.m_gztd = @"1";
    }
    if(gztdZ == 1){
        person.m_gztd = @"2";
    }
    if(gztdD == 1){
        person.m_gztd = @"3";
    }
    person.m_gztd_g = [info stringWithFilted:@"gztdG"];
    person.m_gztd_z = [info stringWithFilted:@"gztdZ"];
    person.m_gztd_d = [info stringWithFilted:@"gztdD"];
    
    NSInteger ljzlD = [info[@"ljzlD"]integerValue];
    NSInteger ljzlG = [info[@"ljzlG"]integerValue];
    NSInteger ljzlZ = [info[@"ljzlZ"]integerValue];
    if(ljzlG == 1){
        person.m_ljzl = @"1";
    }
    if(ljzlZ == 1){
        person.m_ljzl = @"2";
    }
    if(ljzlD == 1){
        person.m_ljzl = @"3";
    }
    person.m_ljzl_g = [info stringWithFilted:@"ljzlG"];
    person.m_ljzl_z = [info stringWithFilted:@"ljzlZ"];
    person.m_ljzl_d = [info stringWithFilted:@"ljzlD"];
    
    
    
    NSInteger pxpzD = [info[@"pxpzD"]integerValue];
    NSInteger pxpzG = [info[@"pxpzG"]integerValue];
    NSInteger pxpzZ = [info[@"pxpzZ"]integerValue];
    if(pxpzG == 1){
        person.m_pxpz = @"1";
    }
    if(pxpzZ == 1){
        person.m_pxpz = @"2";
    }
    if(pxpzD == 1){
        person.m_pxpz = @"3";
    }
    person.m_pxpz_g = [info stringWithFilted:@"pxpzG"];
    person.m_pxpz_z = [info stringWithFilted:@"pxpzZ"];
    person.m_pxpz_d = [info stringWithFilted:@"pxpzD"];
    
    
    NSInteger qyjsD = [info[@"qyjsD"]integerValue];
    NSInteger qyjsG = [info[@"qyjsG"]integerValue];
    NSInteger qyjsZ = [info[@"qyjsZ"]integerValue];
    if(qyjsG == 1){
        person.m_qyjs = @"1";
    }
    if(qyjsZ == 1){
        person.m_qyjs = @"2";
    }
    if(qyjsD == 1){
        person.m_qyjs = @"3";
    }
    person.m_qyjs_g = [info stringWithFilted:@"qyjsG"];
    person.m_qyjs_z = [info stringWithFilted:@"qyjsZ"];
    person.m_qyjs_d = [info stringWithFilted:@"qyjsD"];
    
    NSInteger shgxD = [info[@"shgxD"]integerValue];
    NSInteger shgxG = [info[@"shgxG"]integerValue];
    NSInteger shgxZ = [info[@"shgxZ"]integerValue];
    if(shgxG == 1){
        person.m_shgx = @"1";
    }
    if(shgxZ == 1){
        person.m_shgx = @"2";
    }
    if(shgxD == 1){
        person.m_shgx = @"3";
    }
    person.m_shgx_g = [info stringWithFilted:@"shgxG"];
    person.m_shgx_z = [info stringWithFilted:@"shgxZ"];
    person.m_shgx_d = [info stringWithFilted:@"shgxD"];
    
    NSInteger ywnlD = [info[@"ywnlD"]integerValue];
    NSInteger ywnlG = [info[@"ywnlG"]integerValue];
    NSInteger ywnlZ = [info[@"ywnlZ"]integerValue];
    if(ywnlG == 1){
        person.m_ywnl = @"1";
    }
    if(ywnlZ == 1){
        person.m_ywnl = @"2";
    }
    if(ywnlD == 1){
        person.m_ywnl = @"3";
    }
    person.m_ywnl_g = [info stringWithFilted:@"ywnlG"];
    person.m_ywnl_z = [info stringWithFilted:@"ywnlZ"];
    person.m_ywnl_d = [info stringWithFilted:@"ywnlD"];
    
    NSInteger zwpzD = [info[@"zwpzD"]integerValue];
    NSInteger zwpzG = [info[@"zwpzG"]integerValue];
    NSInteger zwpzZ = [info[@"zwpzZ"]integerValue];
    if(zwpzG == 1){
        person.m_zwpz = @"1";
    }
    if(zwpzZ == 1){
        person.m_zwpz = @"2";
    }
    if(zwpzD == 1){
        person.m_zwpz = @"3";
    }
    person.m_zwpz_g = [info stringWithFilted:@"zwpzG"];
    person.m_zwpz_z = [info stringWithFilted:@"zwpzZ"];
    person.m_zwpz_d = [info stringWithFilted:@"zwpzD"];
    return person;
}
@end

@implementation ADTComment
+(ADTComment *)from:(NSDictionary *)info{
    ADTComment *comment = [[ADTComment alloc]init];
    comment.m_id = [info stringWithFilted:@"id"];
    comment.m_createrName = [info stringWithFilted:@"createName"];
    comment.m_title = [info stringWithFilted:@"content"];
    comment.m_content = [info stringWithFilted:@"content"];
    comment.m_time = [info stringWithFilted:@"createTime"];
    NSString *images = [info stringWithFilted:@"imageUrl"];
    if(images.length == 0){
        comment.m_arrPics = @[];
    }else{
        NSArray *_arrPics = [images componentsSeparatedByString:@","];
        NSMutableArray *arrPics = [NSMutableArray array];
        for(NSString *str in _arrPics){
            if(str.length > 0){
                [arrPics addObject:str];
            }
        }
        comment.m_arrPics = arrPics;
    }
    return comment;
}


@end
