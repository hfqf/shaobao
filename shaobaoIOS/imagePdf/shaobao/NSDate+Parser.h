//
//  NSDate+Parser.h
//  SocialNetwork
//
//  Created by morris on 14-2-25.
//  Copyright (c) 2014年 xintong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Parser)

+ (id)dateWithString:(NSString *)string;//yyyy-MM-dd HH:mm:ss
+ (id)dateWithString:(NSString *)string format:(NSString *)format;
- (BOOL)laterThan2000;
- (NSString *)timestamp;
- (NSString *)year;
- (NSString *)month;
- (NSString *)day;
- (NSString *)hour;
- (NSString *)minute;
- (NSString *)second;

@end
