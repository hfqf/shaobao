//
//  NSDictionary+ValueCheck.m
//  xxt_xj
//
//  Created by Points on 14-4-19.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "NSDictionary+ValueCheck.h"

@implementation NSDictionary(valueCheck)
-(id)stringWithFilted:(NSString *)key
{
    if(self == nil)
    {
        return  @"";
    }
    
    id obj = [self objectForKey:key];
    if([obj isKindOfClass:[NSNull class]])
    {
        obj = @"";
         return obj;
    }
    
    if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *ret = (NSNumber *)obj;
        return [NSString stringWithFormat:@"%lld",[ret longLongValue]];
    }
    return obj == nil ? @"" : obj;
}
@end
