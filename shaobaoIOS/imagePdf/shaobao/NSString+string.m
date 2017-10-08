//
//  NSString+string.m
//  SocialNetwork
//
//  Created by morris on 13-9-23.
//  Copyright (c) 2013年 xintong. All rights reserved.
//

#import "NSString+string.h"

@implementation NSString (string)

- (NSUInteger)findFirstAppearanceOf:(unichar)target FromIndex:(NSUInteger)beginIndex
{
    NSUInteger length = self.length;
    
    for (NSUInteger i = beginIndex; i < length; ++i)
    {
        if (target == [self characterAtIndex:i])
        {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSUInteger)findLastAppearanceOfSet:(NSCharacterSet *)charset ToIndex:(NSUInteger)endIndex
{
    NSUInteger length = self.length;
    if (endIndex >= length)
    {
        return NSNotFound;
    }
    
    for (NSInteger i = endIndex; i >= 0; --i)
    {
        if ([charset characterIsMember:[self characterAtIndex:i]])
        {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSString *)substringToFirstAppearanceOf:(unichar)target
{
    NSUInteger location = [self findFirstAppearanceOf:target FromIndex:0];
    if (NSNotFound != location)
    {
        return [self substringToIndex:location];
    }
    
    return nil;
}

- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset
{
    NSRange range = [self rangeOfCharacterFromSet:charset];
    if (NSNotFound == range.location)
    {
        return nil;
    }
    
    return [self substringToIndex:range.location];
}

- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset location:(NSUInteger *)location
{
    NSRange range = [self rangeOfCharacterFromSet:charset];
    *location = range.location;
    if (NSNotFound == range.location)
    {
        return nil;
    }
    SpeLog(@"substringToFirstAppearanceOfSet location:%lu, %@", (unsigned long)range.location, [self substringToIndex:range.location]);
    return [self substringToIndex:range.location];
}

- (NSUInteger)locationOfFirstAppearanceOfSet:(NSCharacterSet *)charset from:(NSUInteger)location
{
    if (self.length <= location)
    {
        return NSNotFound;
    }
    
    NSString* tmp = [self substringFromIndex:location];
    NSRange range = [tmp rangeOfCharacterFromSet:charset];
    
    return ((NSNotFound == range.location) ? NSNotFound : (range.location + location));
}

- (NSArray *)seperateByCharacter:(unichar)separate
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    
    if (nil == self)
    {
        return ret;
    }
    
    NSUInteger length = self.length;
    
    NSUInteger begin = 0;
    for (NSUInteger i = 0; i < length; ++i)
    {
        if (separate == [self characterAtIndex:i])
        {
            NSString* obj = [self substringWithRange:NSMakeRange(begin, i - begin)];
            [ret addObject:obj];
            begin = i + 1;
        }
        else if (i == length - 1)
        {
            NSString* obj = [self substringFromIndex:begin];
            [ret addObject:obj];
        }
    }
    
    if (0 == [ret count])
    {
        [ret addObject:self];
    }
    return ret;
}

- (NSArray *)seperateByCharacters:(NSCharacterSet *)charset
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    
    NSUInteger length = self.length;
    
    NSUInteger begin = 0;
    for (NSUInteger i = 0; i < length; ++i)
    {
        
        if ([charset characterIsMember:[self characterAtIndex:i]])
        {
            NSString* obj = [self substringWithRange:NSMakeRange(begin, i - begin)];
            [ret addObject:obj];
            begin = i + 1;
        }
        else if (i == length - 1)
        {
            NSString* obj = [self substringFromIndex:begin];
            [ret addObject:obj];
        }
    }
    
    if (0 == [ret count])
    {
        [ret addObject:self];
    }
    return ret;
}

- (NSString *)substringFromFirstAppearanceOf:(unichar)target
{
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c", target]]];
    if (NSNotFound == range.location)
    {
        return nil;
    }
    
    if (range.location == (self.length - 1))
    {
        return @"";
    }
    
    return [self substringFromIndex:(range.location + 1)];
}

- (NSString *)substringFromFirstAppearanceOf:(unichar)target1 ToFirstAppearanceOf:(unichar)target2 FromIndex:(NSUInteger)beginIndex LastLocation:(NSUInteger *)lastLocation
{
    if (target1 == target2)
    {
        *lastLocation = NSNotFound;
        return nil;
    }
    
    NSUInteger location1 = [self findFirstAppearanceOf:target1 FromIndex:beginIndex];
    if (NSNotFound == location1)
    {
        *lastLocation = NSNotFound;
        return nil;
    }
    
    NSUInteger location2 = [self findFirstAppearanceOf:target2 FromIndex:beginIndex];
    if ((NSNotFound == location2) || (location2 < location1))
    {
        *lastLocation = NSNotFound;
        return nil;
    }
    
    if (nil != lastLocation)
    {
        *lastLocation = location2;
    }
    
    return [self substringWithRange:NSMakeRange(location1 + 1, (location2 - location1 - 1))];
}

- (BOOL)isSubstringOf:(NSString *)source CaseSensitive:(BOOL)casesensitive
{
    NSString* target = nil;
    NSString* srcString = nil;
    if (casesensitive)
    {
        target = self;
        srcString = source;
    }
    else
    {
        target = [self lowercaseString];
        srcString = [source lowercaseString];
    }
    
    NSRange range = [srcString rangeOfString:target];
    if (NSNotFound == range.location)
    {
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)makeDictionary
{
    if (7 > self.length) //至少应是{"":""}形式
    {
        return nil;
    }
    
    unichar c1 = [self characterAtIndex:0];
    unichar c2 = [self characterAtIndex:(self.length - 1)];
    if (('{' != c1) || ('}' != c2))
    {
        return nil;
    }
    
    NSString* payload = [self substringWithRange:NSMakeRange(1, (self.length - 2))];
    NSArray* items = [payload seperateByCharacter:','];
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    
    for (NSString* string in items)
    {
        NSArray* pair = [string seperateByCharacter:':'];
        if (2 != [pair count])
        {
            return nil;
        }
        
        NSString* grossKey = [pair[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *grossObject = [pair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ((2 > grossObject.length) || (2 > grossKey.length))
        {
            return nil;
        }
        
        if ('"' != [grossObject characterAtIndex:0])
        {
            grossObject = [NSString stringWithFormat:@"\"%@", grossObject];
        }
        
        if ('"' != [grossObject characterAtIndex:(grossObject.length - 1)])
        {
            grossObject = [NSString stringWithFormat:@"%@\"", grossObject];
        }

        if (('"' != [grossKey characterAtIndex:0]) || ('"' != [grossKey characterAtIndex:(grossKey.length - 1)]))
        {
            return nil;
        }
        
        NSString* object = [grossObject substringWithRange:NSMakeRange(1, (grossObject.length - 2))];
        NSString* key = [grossKey substringWithRange:NSMakeRange(1, (grossKey.length - 2))];
        
        [ret setObject:object forKey:key];
    }
    
    return ret;
}

- (NSString *)substringFromLastAppearanceOf:(unichar)target
{
    NSUInteger index = [self findLastAppearanceOfSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c", target]] ToIndex:(self.length - 1)];
    return (((index == (self.length - 1) || (NSNotFound == index))) ? @"" : [self substringFromIndex:(index + 1)]);
}

- (NSString *)substringToLastAppearanceOf:(unichar)target
{
    NSUInteger index = [self findLastAppearanceOfSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c", target]] ToIndex:(self.length - 1)];
    return ((NSNotFound == index) ? @"" : [self substringToIndex:(index + 1)]);
}

- (BOOL)IsWhiteSpaceString
{
    NSString* temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return (0 == temp.length);
}

- (NSString *)removeBlankSpace:(NSString *)currentStr {
    NSString *changeStr = [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return changeStr;
}

+ (NSString *)changNilData:(NSString *)str {
    if (IsStrEmpty(str)) {
        str = @"";
    }
    return str;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


@end
