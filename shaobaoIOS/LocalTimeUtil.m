//
//  LocalTimeUtil.m
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "LocalTimeUtil.h"
#import "sqliteADO.h"

@implementation LocalTimeUtil


+ (BOOL)isTodayWith:(NSString *)dayTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    
    return [strDate isEqualToString:dayTime];
}

+ (NSString *)getCurrentTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (NSString *)getCurrentTimstamp
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (NSString *)getCurrentDay
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}



+ (NSString *)getLocalTimeWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getLocalTimeWith2:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getLocalTimeWith3:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getLocalTimeWith4:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (BOOL)isToday:(NSString *)time
{
    NSString * todatTime = [self getCurrentTime];
    NSString * compareTime = [time substringToIndex:10];
    NSString * currentTime = [todatTime substringToIndex:10];
    return ([compareTime isEqualToString:currentTime]) ? YES : NO;
}

+ (BOOL)isYesterday:(NSString *)time
{
    NSString * todatTime = [self getCurrentTime];
    NSString * comYM = [time substringToIndex:7];
    NSString *currentYM = [time substringToIndex:7];
    
    if([comYM isEqualToString: currentYM])
    {
        NSString * compareTime = [time substringWithRange:NSMakeRange(8, 2)];
        NSString * currentTime = [todatTime substringWithRange:NSMakeRange(8, 2)];
        if([compareTime intValue]+1 == [currentTime intValue])
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getCurrentMonth
{
    NSString *year_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_YEAR];
    NSString *month_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_MONTH];

    if(year_ && month_)
    {
        return [NSString stringWithFormat:@"%@%@",year_,month_];
    }
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMM"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (BOOL)isValid:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *begin = [dateFormatter dateFromString:beginTime];
    NSDate *end = [dateFormatter dateFromString:endTime];
    NSTimeInterval secondsInterval= [end timeIntervalSinceDate:begin];
    
    return secondsInterval>= 0;

}

+ (BOOL)isValid2:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *begin = [dateFormatter dateFromString:beginTime];
    NSDate *end = [dateFormatter dateFromString:endTime];
    NSTimeInterval secondsInterval= [end timeIntervalSinceDate:begin];
    
    return secondsInterval > 0;
    
}


+ (NSString *)timeWithTimeIntervalString:(long long)timestamp
{
    if(timestamp == 0)
    {
        return @"                   ";
    }
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


+ (NSString *)getTimestamp:(NSString *)time
{
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // NSString * -> NSDate *
    NSDate *data = [format dateFromString:time];
    long long ret = [data timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld",ret];
}

+ (NSString *)getTimestamp1:(NSString *)time
{
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    // NSString * -> NSDate *
    NSDate *data = [format dateFromString:time];
    long long ret = [data timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld",ret];
}




@end
