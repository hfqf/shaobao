//
//  NSDate+Parser.m
//  SocialNetwork
//
//  Created by morris on 14-2-25.
//  Copyright (c) 2014年 xintong. All rights reserved.
//

#import "NSDate+Parser.h"
#import "NSString+string.h"

@implementation NSDate (Parser)

+ (id)dateWithString:(NSString *)string
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* ret = [dateFormatter dateFromString:string];
    
    return ret;
}

+ (id)dateWithString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate* ret = [dateFormatter dateFromString:string];
    
    return ret;
}

- (BOOL)laterThan2000
{
    NSDate* year2000 = [NSDate dateWithString:@"2000-01-01 00:00:00"];
    return (NSOrderedDescending == [self compare:year2000]);
}

- (NSString *)timestamp
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    return timestamp;
}

- (NSString *)year
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    return [timestamp substringToFirstAppearanceOf:'-'];
}

- (NSString *)month
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    NSString* tmp = [timestamp substringFromFirstAppearanceOf:'-'];
    if (nil == tmp)
    {
        return nil;
    }
    
    return [tmp substringToFirstAppearanceOf:'-'];
}

- (NSString *)day
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    NSString* tmp1 = [timestamp substringFromFirstAppearanceOf:'-'];
    if (nil == tmp1)
    {
        return nil;
    }
    
    NSString* tmp2 = [tmp1 substringFromFirstAppearanceOf:'-'];
    
    if (nil == tmp2)
    {
        return nil;
    }
    
    return [tmp2 substringToFirstAppearanceOf:' '];
}

- (NSString *)hour
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    NSString* tmp1 = [timestamp substringFromFirstAppearanceOf:' '];
    if (nil == tmp1)
    {
        return nil;
    }
    
    return [tmp1 substringToFirstAppearanceOf:':'];
}

- (NSString *)minute
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    NSString* tmp1 = [timestamp substringFromFirstAppearanceOf:':'];
    if (nil == tmp1)
    {
        return nil;
    }
    
    return [tmp1 substringToFirstAppearanceOf:':'];
}

- (NSString *)second
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timestamp = [dateFormatter stringFromDate:self];
    NSString* tmp1 = [timestamp substringFromFirstAppearanceOf:':'];
    if (nil == tmp1)
    {
        return nil;
    }
    
    return [tmp1 substringFromFirstAppearanceOf:':'];
}

@end
