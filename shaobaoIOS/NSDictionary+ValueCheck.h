//
//  NSDictionary+ValueCheck.h
//  xxt_xj
//
//  Created by Points on 14-4-19.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(valueCheck)
-(id)stringWithFilted:(NSString *)key;

@end

@interface NSMutableDictionary(valueCheck)
-(id)stringWithFilted:(NSString *)key;

@end
